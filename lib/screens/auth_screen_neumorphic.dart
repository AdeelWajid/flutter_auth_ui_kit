import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class AuthScreenNeumorphic extends StatefulWidget {
  const AuthScreenNeumorphic({super.key});

  @override
  State<AuthScreenNeumorphic> createState() => _AuthScreenNeumorphicState();
}

class _AuthScreenNeumorphicState extends State<AuthScreenNeumorphic>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _colorController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      body: Stack(
        children: [
          // Dynamic color circles
          AnimatedBuilder(
            animation: _colorController,
            builder: (context, child) {
              return Stack(
                children: List.generate(3, (index) {
                  final List<Color> colors = [
                    Colors.blue.shade200,
                    Colors.purple.shade200,
                    Colors.pink.shade200,
                  ];
                  return Positioned(
                    top: -100 + (index * 50) * _colorController.value,
                    right: -100 + (index * 30) * _colorController.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors[index].withOpacity(0.3),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button with Neumorphic effect
                    _buildNeumorphicButton(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF4A4A4A),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),

                    const SizedBox(height: 40),

                    // Title with 3D effect
                    FadeInDown(
                      child: Text(
                        isLogin ? 'Welcome\nBack' : 'Create\nAccount',
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A4A4A),
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Form fields with Neumorphic design
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!isLogin)
                            FadeInDown(
                              delay: const Duration(milliseconds: 200),
                              child: _buildNeumorphicTextField(
                                controller: _nameController,
                                hint: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                            ),
                          const SizedBox(height: 20),
                          FadeInDown(
                            delay: const Duration(milliseconds: 400),
                            child: _buildNeumorphicTextField(
                              controller: _emailController,
                              hint: 'Email',
                              icon: Icons.email_outlined,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInDown(
                            delay: const Duration(milliseconds: 600),
                            child: _buildNeumorphicTextField(
                              controller: _passwordController,
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Submit button with pressed effect
                          FadeInUp(
                            delay: const Duration(milliseconds: 800),
                            child: GestureDetector(
                              onTapDown: (_) => setState(() => _isPressed = true),
                              onTapUp: (_) => setState(() => _isPressed = false),
                              onTapCancel: () => setState(() => _isPressed = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E5EC),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: _isPressed
                                      ? [
                                          const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-5, -5),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            offset: const Offset(5, 5),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : [
                                          const BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(5, 5),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            offset: const Offset(-5, -5),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                ),
                                child: Text(
                                  isLogin ? 'Sign In' : 'Create Account',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF4A4A4A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Toggle button
                    Center(
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 1000),
                        child: TextButton(
                          onPressed: () => setState(() => isLogin = !isLogin),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF4A4A4A),
                          ),
                          child: Text(
                            isLogin
                                ? "Don't have an account? Sign Up"
                                : 'Already have an account? Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
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

  Widget _buildNeumorphicTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5, -5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Color(0xFF4A4A4A)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: const Color(0xFF4A4A4A).withOpacity(0.5)),
          prefixIcon: Icon(icon, color: const Color(0xFF4A4A4A)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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

  Widget _buildNeumorphicButton({
    required VoidCallback onTap,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E5EC),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-5, -5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(5, 5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
} 