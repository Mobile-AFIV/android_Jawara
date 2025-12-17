import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jawara_pintar/models/rumah.dart';
import 'package:jawara_pintar/models/user_profile.dart';
import 'package:jawara_pintar/screens/widgets/shimmer_widget.dart';
import 'package:jawara_pintar/services/auth_service.dart';
import 'package:jawara_pintar/services/user_profile_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>?> loadFullProfile(String uid) async {
    // Get Profil
    final UserProfile? profile =
        await UserProfileService.instance.getUserProfileByUid(uid);
    if (profile == null) return null;

    // Get Rumah
    final DocumentSnapshot rumah = await profile.rumah.get();

    return {
      'profile': profile,
      'rumah': Rumah.fromFirestore(rumah),
    };
  }

  @override
  Widget build(BuildContext context) {
    final User currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Profil Saya",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          // IconButton(
          //   icon:
          //       const Icon(Icons.edit_outlined, color: AppStyles.primaryColor),
          //   onPressed: () {
          //     // TODO: Implement edit profile
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Fitur edit profil coming soon')),
          //     );
          //   },
          // ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: loadFullProfile(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Profil tidak ditemukan",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final UserProfile profile = snapshot.data!['profile'] as UserProfile;
          final Rumah rumah = snapshot.data!['rumah'] as Rumah;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header Profile Card with Avatar
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppStyles.primaryColor,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              AppStyles.primaryColor.withOpacity(0.1),
                          child: Text(
                            _getInitials(profile.namaLengkap),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        profile.namaLengkap,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Username
                      Text(
                        '@${currentUser.displayName ?? 'user'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Personal Information Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi Pribadi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.badge_outlined,
                        title: "NIK",
                        value: profile.nik,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        icon: Icons.wc_outlined,
                        title: "Jenis Kelamin",
                        value: profile.jenisKelamin,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        icon: Icons.phone_outlined,
                        title: "No Telepon",
                        value: profile.noTelepon,
                      ),
                      const SizedBox(height: 24),

                      // Address Information Section
                      const Text(
                        "Informasi Tempat Tinggal",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.home_outlined,
                        title: "Alamat",
                        value: rumah.alamat,
                        isMultiline: true,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoCard(
                        icon: Icons.key_outlined,
                        title: "Status Kepemilikan",
                        value: rumah.statusKepemilikan,
                      ),
                      const SizedBox(height: 24),

                      // Account Actions Section
                      const Text(
                        "Akun",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildActionCard(
                        icon: Icons.lock_outline,
                        title: "Ubah Password",
                        subtitle: "Ganti password akun Anda",
                        onTap: () {
                          _showChangePasswordDialog(context);
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildActionCard(
                        icon: Icons.logout,
                        title: "Keluar",
                        subtitle: "Keluar dari akun Anda",
                        iconColor: AppStyles.errorColor,
                        titleColor: AppStyles.errorColor,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header shimmer
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const ProfileAvatarShimmer(),
          ),
          const SizedBox(height: 16),

          // Info cards shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                const SizedBox(height: 12),
                const InfoCardShimmer(),
                const SizedBox(height: 8),
                const InfoCardShimmer(),
                const SizedBox(height: 8),
                const InfoCardShimmer(),
                const SizedBox(height: 24),
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                const SizedBox(height: 12),
                const InfoCardShimmer(),
                const SizedBox(height: 8),
                const InfoCardShimmer(),
                const SizedBox(height: 24),
                ShimmerWidget(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 16,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                const SizedBox(height: 12),
                const InfoCardShimmer(),
                const SizedBox(height: 8),
                const InfoCardShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isMultiline = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppStyles.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppStyles.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? AppStyles.primaryColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppStyles.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;
    bool isLoading = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppStyles.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.lock_reset,
                      color: AppStyles.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Ubah Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masukkan password lama dan password baru Anda:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // Error Message (ditampilkan jika ada error dari server)
                    if (errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppStyles.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppStyles.errorColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppStyles.errorColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: TextStyle(
                                  color: AppStyles.errorColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Password Lama
                    TextField(
                      controller: currentPasswordController,
                      obscureText: obscureCurrentPassword,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: 'Password Lama',
                        hintText: 'Masukkan password lama',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureCurrentPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureCurrentPassword = !obscureCurrentPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        // Clear error saat user mulai mengetik
                        if (errorMessage != null) {
                          setState(() {
                            errorMessage = null;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Password Baru
                    TextField(
                      controller: newPasswordController,
                      obscureText: obscureNewPassword,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: 'Password Baru',
                        hintText: 'Masukkan password baru',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureNewPassword = !obscureNewPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Konfirmasi Password Baru
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Password Baru',
                        hintText: 'Masukkan ulang password baru',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Password minimal 6 karakter.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: isLoading ? Colors.grey : Colors.grey.shade700,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final currentPassword =
                              currentPasswordController.text.trim();
                          final newPassword = newPasswordController.text.trim();
                          final confirmPassword =
                              confirmPasswordController.text.trim();

                          // Clear error sebelumnya
                          setState(() {
                            errorMessage = null;
                          });

                          // Validasi client-side (pakai SnackBar)
                          if (currentPassword.isEmpty ||
                              newPassword.isEmpty ||
                              confirmPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Semua field harus diisi'),
                                backgroundColor: AppStyles.errorColor,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          if (newPassword.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Password baru minimal 6 karakter'),
                                backgroundColor: AppStyles.errorColor,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          if (newPassword != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Konfirmasi password tidak cocok'),
                                backgroundColor: AppStyles.errorColor,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          // Set loading state
                          setState(() {
                            isLoading = true;
                          });

                          // Call change password service
                          final result =
                              await AuthService.instance.changePassword(
                            currentPassword: currentPassword,
                            newPassword: newPassword,
                          );

                          // Reset loading state
                          setState(() {
                            isLoading = false;
                          });

                          // Handle result
                          if (result['success']) {
                            // Success - close dialog dan tampilkan sukses
                            Navigator.of(dialogContext).pop();

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result['message']),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }
                          } else {
                            // Error - tampilkan error di dialog (jangan close)
                            setState(() {
                              errorMessage = result['message'];
                            });

                            // Clear password lama jika error password salah
                            if (result['message']
                                    .toLowerCase()
                                    .contains('password lama') ||
                                result['message']
                                    .toLowerCase()
                                    .contains('salah')) {
                              currentPasswordController.clear();
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLoading ? Colors.grey : AppStyles.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Ubah Password',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Konfirmasi Keluar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun Anda?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                // Navigation will be handled by auth state listener
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.errorColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
