import 'package:flutter/material.dart';
import 'package:jawara_pintar/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController displayNameController = TextEditingController();

  bool isLoading = false;

  void updateDisplayName() async {
    if (displayNameController.text.isEmpty) return;

    AuthService authService = AuthService();

    setState(() => isLoading = true);
    final result = await authService.updateUserDisplayName(
      displayNameController.text.trim(),
    );
    setState(() => isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Refresh Screen
    if (result['success']) {
      setState(() {});
      displayNameController.clear();
    }
  }

  @override
  void dispose() {
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: -4,
        title: const Text(
          "Your Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Display Name"),
          TextField(controller: displayNameController),
          ElevatedButton(
            onPressed: isLoading ? () {} : updateDisplayName,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text("Save"),
          ),
        ],
      ),
    );
  }
}
