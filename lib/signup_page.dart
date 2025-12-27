import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crisis_banner.dart';
import 'landing_page.dart';
import 'widgets/keyboard_padding.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _usernameController =
      TextEditingController(); // Used as email for now or display name
  final _passwordController = TextEditingController();
  final _emergencyContactsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create user in Firebase Auth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _usernameController.text.trim(),
            password: _passwordController.text,
          );

      final user = userCredential.user;
      if (user != null) {
        // Update display name
        if (_nameController.text.isNotEmpty) {
          await user.updateDisplayName(_nameController.text);
        }

        // Parse emergency contacts
        final emergencyContacts = _emergencyContactsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        // Save user data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': _nameController.text.trim(),
          'email': _usernameController.text.trim(),
          'emergencyContacts': emergencyContacts,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LandingPage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emergencyContactsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFEEF2FF),
      body: KeyboardPadding(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CrisisBanner(),

                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        // Logo
                        const Icon(
                          Icons.landscape,
                          size: 60,
                          color: Color(0xFF1E3A8A),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        const Text(
                          'Join MentalPing',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'A safe space for men\'s mental health support',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),

                        // Feature Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFeatureIcon(
                              Icons.shield_outlined,
                              'Emergency Support',
                            ),
                            _buildFeatureIcon(
                              Icons.people_outline,
                              'Men\'s Groups',
                            ),
                            _buildFeatureIcon(
                              Icons.favorite_border,
                              'Peer Support',
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // First Name
                        _buildLabel('First Name'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _nameController,
                          hintText: 'What should we call you?',
                        ),
                        const SizedBox(height: 10),

                        // Username (Email)
                        _buildLabel(
                          'Username',
                        ), // Treating as Email based on Login page context
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _usernameController,
                          hintText: 'Email address',
                        ),
                        const SizedBox(height: 10),

                        // Password
                        _buildLabel('Password'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: 'Create a secure password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),

                        // Emergency Contacts
                        _buildLabel('Emergency Contacts (Optional)'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _emergencyContactsController,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                                'Enter phone numbers or emails, separated by commas',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'These contacts will be notified if you send an emergency ping',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Create Account Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF2196F3,
                              ), // Lighter blue from image
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sign In Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4B5563),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return SizedBox(
      height: 30,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13),
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF2563EB)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2196F3), size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
