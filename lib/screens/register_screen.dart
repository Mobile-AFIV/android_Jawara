import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_dialog.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/services/auth_service.dart';
import 'package:jawara_pintar/utils/app_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPassController =
      TextEditingController();
  final TextEditingController _alamatManualController = TextEditingController();

  bool _obscurePass = true;
  bool _obscureKonfirmasi = true;

  String? _selectedGender;
  String? _selectedRumah;
  String? _selectedStatus;

  final List<String> genderOptions = ["Laki-laki", "Perempuan"];
  final List<String> statusRumahOptions = ["Pemilik", "Penyewa"];

  bool _isLoading = false;

  // dummy list rumah
  final List<String> rumahOptions = [];

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _telpController.dispose();
    _passwordController.dispose();
    _konfirmasiPassController.dispose();
    _alamatManualController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    final nama = _namaController.text.trim();
    final nik = _nikController.text.trim();
    final email = _emailController.text.trim();
    final telp = _telpController.text.trim();
    final pass = _passwordController.text;
    final passKonfirmasi = _konfirmasiPassController.text;
    final alamatManual = _alamatManualController.text.trim();

    // === VALIDASI ===

    if (nama.isEmpty) {
      _showError("Nama lengkap tidak boleh kosong");
      return;
    }

    if (nik.length != 16 || int.tryParse(nik) == null) {
      _showError("NIK harus angka 16 digit");
      return;
    }

    if (email.isEmpty || !email.contains("@")) {
      _showError("Email tidak valid");
      return;
    }

    if (telp.isEmpty || telp.length < 10 || int.tryParse(telp) == null) {
      _showError("Nomor telepon tidak valid");
      return;
    }

    if (pass.length < 6) {
      _showError("Password minimal 6 karakter");
      return;
    }

    if (pass != passKonfirmasi) {
      _showError("Konfirmasi password tidak cocok");
      return;
    }

    if (_selectedGender == null) {
      _showError("Silakan pilih jenis kelamin");
      return;
    }

    // Rumah (ada 2 kondisi)
    // 1. Jika list rumah kosong -> wajib isi alamat manual
    // 2. Jika list rumah ada -> user boleh pilih salah satu atau isi manual

    // String? rumahFinal;

    if (rumahOptions.isEmpty) {
      if (alamatManual.isEmpty) {
        _showError("Isi alamat rumah terlebih dahulu");
        return;
      }
      // rumahFinal = alamatManual;
    } else {
      // rumahOptions ada isinya
      if (_selectedRumah == null && alamatManual.isEmpty) {
        _showError("Pilih rumah atau isi alamat manual");
        return;
      }

      // rumahFinal = _selectedRumah ?? alamatManual;
    }

    if (_selectedStatus == null) {
      _showError("Silakan pilih status kepemilikan rumah");
      return;
    }

    // === Hasil ===
    debugPrint("Nama: $nama");
    debugPrint("NIK: $nik");
    debugPrint("Email: $email");
    debugPrint("Telp: $telp");
    debugPrint("Jenis Kelamin: $_selectedGender");
    debugPrint("Rumah: ${_selectedRumah ?? alamatManual}");
    debugPrint("Status Rumah: $_selectedStatus");
    debugPrint("Password: $pass");

    Map<String, dynamic> result = await AuthService.instance.register(
      namaLengkap: nama,
      nik: nik,
      email: email,
      telp: telp,
      password: pass,
      jenisKelamin: _selectedGender!,
      statusRumah: _selectedStatus!,
      selectedRumahPath: _selectedRumah,
      alamatManual: alamatManual,
    );

    setState(() => _isLoading = false);
    if (result['success']) {
      if (mounted) {
        CustomDialog.show(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomDialog.alertDialog(
            title: const Text(
              'Registrasi Berhasil',
            ),
            content: Text(
              "${result['message']},\nSelamat datang ${AuthService.instance.currentUser?.displayName ?? "Anonym"}!",
            ),
            actions: [
              CustomDialog.actionFilledButton(
                onPressed: () => context.goNamed('dashboard'),
                textButton: "OK",
              ),
            ],
          ),
        );
      }
    } else {
      _showError(result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Akun",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppStyles.textPrimaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppStyles.textPrimaryColor),
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLabel("Nama Lengkap"),
            CustomTextField(
              controller: _namaController,
              hintText: "Masukkan nama lengkap",
            ),
            const SizedBox(height: 20),
            _buildLabel("NIK"),
            CustomTextField(
              controller: _nikController,
              hintText: "Masukkan NIK sesuai KTP",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildLabel("Email"),
            CustomTextField(
              controller: _emailController,
              hintText: "Masukkan email aktif",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            _buildLabel("No Telepon"),
            CustomTextField(
              controller: _telpController,
              hintText: "08xxxxxxxxx",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildLabel("Password"),
            CustomTextField(
              controller: _passwordController,
              hintText: "Masukkan password",
              obscureText: _obscurePass,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePass ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePass = !_obscurePass;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel("Konfirmasi Password"),
            CustomTextField(
              controller: _konfirmasiPassController,
              hintText: "Masukkan ulang password",
              obscureText: _obscureKonfirmasi,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureKonfirmasi ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureKonfirmasi = !_obscureKonfirmasi;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel("Jenis Kelamin"),
            _buildDropdown<String>(
              hint: "-- Pilih Jenis Kelamin --",
              value: _selectedGender,
              items: genderOptions,
              onChanged: (v) => setState(() => _selectedGender = v),
            ),
            const SizedBox(height: 20),
            _buildLabel("Pilih Rumah yang Sudah Ada"),
            _buildDropdown<String>(
              hint: "-- Pilih Rumah --",
              value: _selectedRumah,
              items: rumahOptions,
              onChanged: (v) => setState(() => _selectedRumah = v),
            ),
            const SizedBox(height: 10),
            Text(
              "Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppStyles.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildLabel("Alamat Rumah (Jika Tidak Ada di List)"),
            CustomTextField(
              controller: _alamatManualController,
              hintText: "Blok 5A / No.10",
            ),
            const SizedBox(height: 20),
            _buildLabel("Status Kepemilikan Rumah"),
            _buildDropdown<String>(
              hint: "-- Pilih Status --",
              value: _selectedStatus,
              items: statusRumahOptions,
              onChanged: (v) => setState(() => _selectedStatus = v),
            ),
            const SizedBox(height: 30),
            CustomButton(
              width: double.maxFinite,
              onPressed: _handleRegister,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "Buat Akun",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun? ",
                    style: GoogleFonts.poppins(
                        color: AppStyles.textSecondaryColor),
                  ),
                  InkWell(
                    onTap: () => context.goNamed("login"),
                    child: Text(
                      "Masuk",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: AppStyles.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppStyles.textPrimaryColor,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: AppStyles.textPrimaryColor,
      ),
      hint: Text(
        hint,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: AppStyles.textSecondaryColor,
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(e.toString()),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
