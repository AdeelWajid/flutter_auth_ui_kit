import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class AuthScreenIsometric extends StatefulWidget {
  const AuthScreenIsometric({super.key});

  @override
  State<AuthScreenIsometric> createState() => _AuthScreenIsometricState();
}

class _AuthScreenIsometricState extends State<AuthScreenIsometric>
    with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _rotationController;
  late AnimationController _floatController;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2A),
      body: Stack(
        children: [
          // Animated isometric shapes
          ...List.generate(6, (index) {
            return AnimatedBuilder(
              animation: Listenable.merge([_rotationController, _floatController]),
              builder: (context, child) {
                final rotationValue = _rotationController.value * 2 * math.pi;
                final floatValue = math.sin(_floatController.value * math.pi);
                return Positioned(
                  left: MediaQuery.of(context).size.width * 0.5 +
                      math.cos(rotationValue + (index * math.pi / 3)) * 150,
                  top: MediaQuery.of(context).size.height * 0.3 +
                      math.sin(rotationValue + (index * math.pi / 3)) * 150 +
                      (floatValue * 20),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..rotateX(0.8)
                      ..rotateY(rotationValue)
                      ..rotateZ(0.5),
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(Colors.blue, Colors.purple,
                                index / 5)!.withOpacity(0.5),
                            Color.lerp(Colors.purple, Colors.pink,
                                index / 5)!.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    _buildIsometricButton(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                      small: true,
                    ),

                    const SizedBox(height: 40),

                    // Title
                    FadeInDown(
                      child: Text(
                        isLogin ? 'Welcome\nBack' : 'Create\nAccount',
                        style: GoogleFonts.spaceMono(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!isLogin) ...[
                              _buildIsometricTextField(
                                controller: _nameController,
                                hint: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 20),
                            ],
                            _buildIsometricTextField(
                              controller: _emailController,
                              hint: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            _buildIsometricTextField(
                              controller: _passwordController,
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            const SizedBox(height: 32),
                            _buildSubmitButton(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Toggle button
                    Center(
                      child: TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(
                          isLogin ? 'Create new account' : 'Already have an account?',
                          style: GoogleFonts.spaceMono(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIsometricTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.spaceMono(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.spaceMono(
            color: Colors.white.withOpacity(0.3),
          ),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildIsometricButton({
    required VoidCallback onTap,
    required Widget child,
    bool small = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(small ? 8 : 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: child,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) {
        setState(() => _isButtonPressed = false);
        if (_formKey.currentState!.validate()) {
          // Add authentication logic
        }
      },
      onTapCancel: () => setState(() => _isButtonPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.purple.shade400,
            ],
            begin: _isButtonPressed ? Alignment.centerRight : Alignment.centerLeft,
            end: _isButtonPressed ? Alignment.centerLeft : Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isButtonPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            isLogin ? 'Sign In' : 'Create Account',
            style: GoogleFonts.spaceMono(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
} 