import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class AuthScreenOrigami extends StatefulWidget {
  const AuthScreenOrigami({super.key});

  @override
  State<AuthScreenOrigami> createState() => _AuthScreenOrigamiState();
}

class _AuthScreenOrigamiState extends State<AuthScreenOrigami>
    with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _foldingController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _foldingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _foldingController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Animated geometric background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([_foldingController, _rotationController]),
              builder: (context, child) {
                return CustomPaint(
                  painter: OrigamiPainter(
                    foldAnimation: _foldingController,
                    rotateAnimation: _rotationController,
                  ),
                );
              },
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.black12,
                        elevation: 8,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title with folding animation
                    FadeInDown(
                      child: Text(
                        isLogin ? 'Welcome\nBack' : 'Join\nUs',
                        style: GoogleFonts.raleway(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: const Color(0xFF2A2A2A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!isLogin) ...[
                              _buildOrigamiTextField(
                                controller: _nameController,
                                hint: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 20),
                            ],
                            _buildOrigamiTextField(
                              controller: _emailController,
                              hint: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            _buildOrigamiTextField(
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
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: const Color(0xFF2A2A2A),
                            fontWeight: FontWeight.w600,
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

  Widget _buildOrigamiTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.raleway(
          color: const Color(0xFF2A2A2A),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.raleway(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
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

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B8EFF), Color(0xFF4338CA)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4338CA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Add authentication logic
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isLogin ? 'Sign In' : 'Create Account',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OrigamiPainter extends CustomPainter {
  final Animation<double> foldAnimation;
  final Animation<double> rotateAnimation;

  OrigamiPainter({
    required this.foldAnimation,
    required this.rotateAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    void drawPolygon(List<Offset> points, Color color) {
      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      paint.color = color;
      canvas.drawPath(path, paint);
    }

    // Draw multiple rotating and folding polygons
    for (var i = 0; i < 5; i++) {
      final angle = (rotateAnimation.value * 2 * math.pi) + (i * math.pi / 2.5);
      final fold = math.sin(foldAnimation.value * 2 * math.pi + i);
      final scale = 0.6 + fold * 0.4;

      final centerX = size.width * (0.3 + i * 0.1);
      final centerY = size.height * (0.2 + i * 0.15);
      final radius = size.width * 0.15 * scale;

      final points = <Offset>[];
      for (var j = 0; j < 4; j++) {
        final pointAngle = angle + (j * math.pi / 2);
        points.add(Offset(
          centerX + math.cos(pointAngle) * radius,
          centerY + math.sin(pointAngle) * radius,
        ));
      }

      drawPolygon(
        points,
        Color.lerp(
          const Color(0xFFE5E7EB),
          const Color(0xFFD1D5DB),
          fold,
        )!.withOpacity(0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 