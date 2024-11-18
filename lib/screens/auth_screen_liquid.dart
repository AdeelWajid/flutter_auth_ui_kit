import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class AuthScreenLiquid extends StatefulWidget {
  const AuthScreenLiquid({super.key});

  @override
  State<AuthScreenLiquid> createState() => _AuthScreenLiquidState();
}

class _AuthScreenLiquidState extends State<AuthScreenLiquid>
    with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _liquidController;
  late AnimationController _rippleController;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _liquidController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _liquidController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          // Animated liquid background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _liquidController,
              builder: (context, child) {
                return CustomPaint(
                  painter: LiquidPainter(
                    animation: _liquidController,
                    color1: const Color(0xFF2E5CFF),
                    color2: const Color(0xFF6C1AFF),
                  ),
                );
              },
            ),
          ),

          // Content
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      _buildRippleButton(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
            
                      const SizedBox(height: 40),
            
                      // Animated title
                      FadeInDown(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFF6C1AFF)],
                          ).createShader(bounds),
                          child: Text(
                            isLogin ? 'Welcome\nBack' : 'Create\nAccount',
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
            
                      const SizedBox(height: 40),
            
                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!isLogin) ...[
                              _buildLiquidTextField(
                                controller: _nameController,
                                hint: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 20),
                            ],
                            _buildLiquidTextField(
                              controller: _emailController,
                              hint: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            _buildLiquidTextField(
                              controller: _passwordController,
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            const SizedBox(height: 40),
            
                            // Submit button with liquid effect
                            _buildSubmitButton(),
                            const SizedBox(height: 20),
            
                            // Toggle button
                            Center(
                              child: TextButton(
                                onPressed: () => setState(() => isLogin = !isLogin),
                                child: Text(
                                  isLogin ? 'Need an account?' : 'Already have an account?',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
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
        ],
      ),
    );
  }

  Widget _buildLiquidTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.5),
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

  Widget _buildRippleButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return InkWell(
      onTap: () {
        _rippleController.forward(from: 0);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
        ),
        child: child,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) => setState(() => _isButtonPressed = false),
      onTapCancel: () => setState(() => _isButtonPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2E5CFF),
              const Color(0xFF6C1AFF),
            ],
            begin: _isButtonPressed ? Alignment.topRight : Alignment.topLeft,
            end: _isButtonPressed ? Alignment.bottomLeft : Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C1AFF).withOpacity(0.3),
              blurRadius: _isButtonPressed ? 10 : 20,
              spreadRadius: _isButtonPressed ? 1 : 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            isLogin ? 'Sign In' : 'Create Account',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class LiquidPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color1;
  final Color color2;

  LiquidPainter({
    required this.animation,
    required this.color1,
    required this.color2,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final path = Path();

    // Create liquid waves
    void addWave(Color color, double amplitude, double frequency, double offset) {
      paint.color = color;
      path.reset();
      path.moveTo(0, size.height);
      
      // Start from bottom of screen
      for (double x = 0; x <= size.width; x++) {
        double y = size.height * 0.75 + // Moved waves down by adjusting this multiplier
            amplitude *
                math.sin((x / size.width * 2 * math.pi * frequency) +
                    (animation.value * 2 * math.pi) +
                    offset);
        path.lineTo(x, y);
      }
      
      // Ensure the path covers the entire bottom of the screen
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      canvas.drawPath(path, paint);
    }

    // Draw multiple waves with different parameters and increased amplitude
    addWave(color1.withOpacity(0.3), 80, 2, 0); // Increased amplitude
    addWave(color1.withOpacity(0.2), 100, 3, math.pi / 2); // Increased amplitude
    addWave(color2.withOpacity(0.3), 90, 1.5, math.pi); // Increased amplitude
    addWave(color2.withOpacity(0.2), 120, 2.5, 3 * math.pi / 2); // Increased amplitude

    // Add an extra wave at the bottom to ensure full coverage
    addWave(color2.withOpacity(0.4), 150, 2, math.pi / 4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 