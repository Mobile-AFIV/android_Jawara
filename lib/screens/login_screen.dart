import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_pintar/screens/widgets/custom_button.dart';
import 'package:jawara_pintar/screens/widgets/custom_dialog.dart';
import 'package:jawara_pintar/screens/widgets/custom_text_field.dart';
import 'package:jawara_pintar/utils/app_styles.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  String _errorMessage = '';
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Set default email and password for testing purposes
    _emailController.text = 'admin1@gmail.com';
    _passwordController.text = 'password';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final result = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (result['success']) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );

      if (mounted) {
        CustomDialog.show(
          context: context,
          barrierDismissible: false,
          builder: (context) => CustomDialog.alertDialog(
            title: const Text(
              'Login Berhasil',
            ),
            content: const Text(
              'Selamat datang admin!',
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
      // Show error message
      setState(() {
        _errorMessage = result['message'];
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppStyles.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // App Title
                  Text(
                    'Jawara Pintar',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Welcome Text
              Text(
                'Selamat Datang',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle
              Text(
                'Login untuk mengakses sistem Jawara Pintar.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppStyles.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 36),

              // Login Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field Label
                  Text(
                    'Email',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Email TextField
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Masukkan email disini',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password Field Label
                  Text(
                    'Password',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Password TextField
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Masukkan password disini',
                    obscureText: _obscureText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),

                  // Error message
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage,
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Login Button
                  CustomButton(
                    width: double.maxFinite,
                    onPressed: _isLoading ? null : _handleLogin,
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
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  // Register Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: AppStyles.textSecondaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.goNamed('register');
                          },
                          child: Text(
                            'Daftar',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
