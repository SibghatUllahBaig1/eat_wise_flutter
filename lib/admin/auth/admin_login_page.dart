import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/admin_theme.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Login failed';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminTheme.background,
      body: Row(
        children: [
          // Left branding panel
          Expanded(
            child: Container(
              color: AdminTheme.sidebar,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/custom-images/favicon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('EatWise',
                      style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 8),
                  Text('Admin Dashboard',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.6))),
                  const SizedBox(height: 48),
                  _featureRow(Icons.people_rounded, 'Manage customers'),
                  const SizedBox(height: 16),
                  _featureRow(Icons.restaurant_menu_rounded, 'Manage recipes'),
                  const SizedBox(height: 16),
                  _featureRow(Icons.description_rounded, 'Edit content'),
                  const SizedBox(height: 16),
                  _featureRow(Icons.key_rounded, 'Configure API keys'),
                ],
              ),
            ),
          ),
          // Right login form
          Container(
            width: 480,
            color: AdminTheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 60),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Welcome back',
                      style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AdminTheme.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Sign in to your admin account',
                      style: GoogleFonts.inter(
                          fontSize: 15, color: AdminTheme.textSecondary)),
                  const SizedBox(height: 40),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: AdminTheme.textSecondary),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Error message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AdminTheme.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AdminTheme.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: AdminTheme.error, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(_errorMessage!,
                                  style: GoogleFonts.inter(
                                      fontSize: 13, color: AdminTheme.error))),
                        ],
                      ),
                    ),

                  // Login button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text('Sign In',
                              style: GoogleFonts.inter(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AdminTheme.primary, size: 18),
        const SizedBox(width: 10),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 14, color: Colors.white.withValues(alpha: 0.75))),
      ],
    );
  }
}
