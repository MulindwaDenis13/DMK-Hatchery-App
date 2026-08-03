import 'package:flutter/material.dart';
import '../../widgets/button.dart';
import '../../widgets/password_field.dart';
import '../../widgets/password_strength_indicator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  // Password strength indicators
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_updatePasswordStrength);
  }

  void _updatePasswordStrength() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade50,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.15),
                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.password_rounded,
                      size: 44,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Update Your Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Choose a strong password to keep your account secure',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Current password
                PasswordField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  hint: 'Enter current password',
                ),
                const SizedBox(height: 24),

                // New password
                PasswordField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hint: 'Enter new password',
                ),
                const SizedBox(height: 12),

                // Password strength indicators
                if (_newPasswordController.text.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  PasswordStrengthIndicator(
                    text: 'At least 8 characters',
                    isMet: _hasMinLength,
                  ),
                  PasswordStrengthIndicator(
                    text: 'Contains uppercase letter',
                    isMet: _hasUppercase,
                  ),
                  PasswordStrengthIndicator(
                    text: 'Contains lowercase letter',
                    isMet: _hasLowercase,
                  ),
                  PasswordStrengthIndicator(
                    text: 'Contains a number',
                    isMet: _hasNumber,
                  ),
                  const SizedBox(height: 8),
                ],

                // Confirm password
                PasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Re-enter new password',
                ),
                const SizedBox(height: 10),

                // Matching indicator
                if (_confirmPasswordController.text.isNotEmpty &&
                    _newPasswordController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          _newPasswordController.text ==
                                  _confirmPasswordController.text
                              ? Icons.check_circle_rounded
                              : Icons.error_outline_rounded,
                          color: _newPasswordController.text ==
                                  _confirmPasswordController.text
                              ? Colors.green.shade600
                              : Colors.red.shade400,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _newPasswordController.text ==
                                  _confirmPasswordController.text
                              ? 'Passwords match'
                              : 'Passwords do not match',
                          style: TextStyle(
                            fontSize: 13,
                            color: _newPasswordController.text ==
                                    _confirmPasswordController.text
                                ? Colors.green.shade700
                                : Colors.red.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),

                // Update button
                Button(
                  onPressed: _handleChangePassword,
                  text: 'Update Password',
                  icon: Icons.lock_reset_rounded,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),

                // Back to login
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                    ),
                    child: const Text(
                      '← Back to Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleChangePassword() async {
    // Validate
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_hasMinLength || !_hasUppercase || !_hasLowercase || !_hasNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password does not meet strength requirements'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Password updated successfully! 🔒'),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
