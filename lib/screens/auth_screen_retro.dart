import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class AuthScreenRetro extends StatefulWidget {
  const AuthScreenRetro({super.key});

  @override
  State<AuthScreenRetro> createState() => _AuthScreenRetroState();
}

class _AuthScreenRetroState extends State<AuthScreenRetro>
    with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _pixelController;
  late AnimationController _glitchController;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _pixelController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Random glitch effect
    Future.delayed(const Duration(seconds: 2), () {
      _startRandomGlitch();
    });
  }

  void _startRandomGlitch() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 2 + math.Random().nextInt(5)));
      if (mounted) {
        _glitchController.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _pixelController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Pixel art background
          CustomPaint(
            painter: PixelGridPainter(
              animation: _pixelController,
              glitchAnimation: _glitchController,
            ),
            size: Size.infinite,
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildPixelButton(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                        small: true,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 8-bit style logo
                    _buildPixelContainer(
                      child: const Icon(
                        Icons.videogame_asset,
                        size: 50,
                        color: Color(0xFF00FF00),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Retro title
                    Text(
                      isLogin ? 'PLAYER LOGIN' : 'NEW PLAYER',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 20,
                        color: const Color(0xFF00FF00),
                        shadows: [
                          Shadow(
                            color: const Color(0xFF00FF00).withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!isLogin) ...[
                            _buildRetroTextField(
                              controller: _nameController,
                              hint: 'PLAYER NAME',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),
                          ],
                          _buildRetroTextField(
                            controller: _emailController,
                            hint: 'EMAIL',
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 20),
                          _buildRetroTextField(
                            controller: _passwordController,
                            hint: 'PASSWORD',
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 40),

                          // Submit button
                          _buildRetroButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Add authentication logic
                              }
                            },
                            text: isLogin ? 'START GAME' : 'CREATE PLAYER',
                          ),

                          const SizedBox(height: 20),

                          // Toggle button
                          TextButton(
                            onPressed: () => setState(() => isLogin = !isLogin),
                            child: Text(
                              isLogin ? 'NEW PLAYER? REGISTER' : 'EXISTING PLAYER? LOGIN',
                              style: GoogleFonts.pressStart2p(
                                fontSize: 12,
                                color: const Color(0xFF00FF00),
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
        ],
      ),
    );
  }

  Widget _buildPixelContainer({required Widget child}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: const Color(0xFF00FF00),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF00).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRetroTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: const Color(0xFF00FF00),
          width: 2,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.pressStart2p(
          color: const Color(0xFF00FF00),
          fontSize: 12,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.pressStart2p(
            color: const Color(0xFF00FF00).withOpacity(0.5),
            fontSize: 12,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF00FF00)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'REQUIRED';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRetroButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) {
        setState(() => _isButtonPressed = false);
        onPressed();
      },
      onTapCancel: () => setState(() => _isButtonPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        decoration: BoxDecoration(
          color: _isButtonPressed ? const Color(0xFF00FF00) : Colors.black,
          border: Border.all(
            color: const Color(0xFF00FF00),
            width: 2,
          ),
          boxShadow: _isButtonPressed
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF00FF00).withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
        ),
        child: Text(
          text,
          style: GoogleFonts.pressStart2p(
            fontSize: 14,
            color: _isButtonPressed ? Colors.black : const Color(0xFF00FF00),
          ),
        ),
      ),
    );
  }

  Widget _buildPixelButton({
    required VoidCallback onTap,
    required Widget child,
    bool small = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(small ? 8 : 12),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: const Color(0xFF00FF00),
            width: 2,
          ),
        ),
        child: child,
      ),
    );
  }
}

class PixelGridPainter extends CustomPainter {
  final Animation<double> animation;
  final Animation<double> glitchAnimation;

  PixelGridPainter({
    required this.animation,
    required this.glitchAnimation,
  }) : super(repaint: Listenable.merge([animation, glitchAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF00).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final pixelSize = 10.0;
    final columns = (size.width / pixelSize).ceil();
    final rows = (size.height / pixelSize).ceil();

    for (var i = 0; i < columns; i++) {
      for (var j = 0; j < rows; j++) {
        if (math.Random().nextDouble() > 0.8) {
          final opacity = (math.sin(animation.value * 2 * math.pi +
                      (i + j) * 0.1) *
                  0.5 +
              0.5);
          paint.color = const Color(0xFF00FF00).withOpacity(opacity * 0.1);

          // Add glitch effect
          double offsetX = 0;
          double offsetY = 0;
          if (glitchAnimation.value > 0) {
            offsetX = math.Random().nextDouble() * 2 - 1;
            offsetY = math.Random().nextDouble() * 2 - 1;
          }

          canvas.drawRect(
            Rect.fromLTWH(
              i * pixelSize + offsetX,
              j * pixelSize + offsetY,
              pixelSize,
              pixelSize,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 