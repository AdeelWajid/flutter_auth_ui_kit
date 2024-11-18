import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class AuthScreenSpace extends StatefulWidget {
  const AuthScreenSpace({super.key});

  @override
  State<AuthScreenSpace> createState() => _AuthScreenSpaceState();
}

class _AuthScreenSpaceState extends State<AuthScreenSpace>
    with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _starsController;
  late AnimationController _planetsController;
  bool _isButtonPressed = false;
  final List<Star> _stars = List.generate(200, (_) => Star());
  final List<Planet> _planets = List.generate(3, (_) => Planet());

  @override
  void initState() {
    super.initState();
    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _planetsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _starsController.dispose();
    _planetsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D2C),
      body: Stack(
        children: [
          // Animated starfield
          CustomPaint(
            painter: StarfieldPainter(
              stars: _stars,
              animation: _starsController,
            ),
            size: Size.infinite,
          ),

          // Animated planets
          ...List.generate(_planets.length, (index) {
            return AnimatedBuilder(
              animation: _planetsController,
              builder: (context, child) {
                final planet = _planets[index];
                final angle = _planetsController.value * 2 * math.pi + 
                    (index * (2 * math.pi / _planets.length));
                final radius = MediaQuery.of(context).size.width * 0.3;
                final x = MediaQuery.of(context).size.width * 0.5 + 
                    math.cos(angle) * radius;
                final y = MediaQuery.of(context).size.height * 0.3 + 
                    math.sin(angle) * radius;

                return Positioned(
                  left: x - planet.size / 2,
                  top: y - planet.size / 2,
                  child: Container(
                    width: planet.size,
                    height: planet.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: planet.colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: planet.colors.first.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
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
                    _buildSpaceButton(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                      small: true,
                    ),

                    const SizedBox(height: 40),

                    // Title
                    FadeInDown(
                      child: Text(
                        isLogin ? 'Welcome\nExplorer' : 'Join The\nMission',
                        style: GoogleFonts.orbitron(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!isLogin) ...[
                              _buildSpaceTextField(
                                controller: _nameController,
                                hint: 'CREW NAME',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 20),
                            ],
                            _buildSpaceTextField(
                              controller: _emailController,
                              hint: 'SPACE EMAIL',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            _buildSpaceTextField(
                              controller: _passwordController,
                              hint: 'ACCESS CODE',
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
                          isLogin ? 'NEW EXPLORER? REGISTER' : 'ALREADY REGISTERED?',
                          style: GoogleFonts.orbitron(
                            fontSize: 14,
                            color: Colors.blue[300],
                            shadows: [
                              Shadow(
                                color: Colors.blue.withOpacity(0.5),
                                blurRadius: 5,
                              ),
                            ],
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

  Widget _buildSpaceTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.orbitron(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.orbitron(
            color: Colors.white.withOpacity(0.3),
          ),
          prefixIcon: Icon(icon, color: Colors.blue[300]),
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

  Widget _buildSpaceButton({
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blue.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
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
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[700]!,
              Colors.blue[400]!,
            ],
            begin: _isButtonPressed ? Alignment.centerRight : Alignment.centerLeft,
            end: _isButtonPressed ? Alignment.centerLeft : Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isButtonPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            isLogin ? 'LAUNCH' : 'INITIATE',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Star {
  late double x;
  late double y;
  late double speed;
  late double size;

  Star() {
    reset();
  }

  void reset() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    speed = 0.1 + math.Random().nextDouble() * 0.5;
    size = 1 + math.Random().nextDouble() * 2;
  }
}

class Planet {
  final double size;
  final List<Color> colors;

  Planet()
      : size = 30 + math.Random().nextDouble() * 50,
        colors = [
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
        ];
}

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  final Animation<double> animation;

  StarfieldPainter({
    required this.stars,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var star in stars) {
      star.y += star.speed * animation.value;
      if (star.y > 1) {
        star.reset();
        star.y = 0;
      }

      final opacity = (star.speed - 0.1) / 0.5;
      paint.color = Colors.white.withOpacity(opacity);

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 