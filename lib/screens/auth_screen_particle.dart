import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class AuthScreenParticle extends StatefulWidget {
  const AuthScreenParticle({super.key});

  @override
  State<AuthScreenParticle> createState() => _AuthScreenParticleState();
}

class _AuthScreenParticleState extends State<AuthScreenParticle>
    with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _particleController;
  Offset? _mousePosition;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle());
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: MouseRegion(
        onHover: (event) {
          setState(() {
            _mousePosition = event.localPosition;
          });
        },
        child: Stack(
          children: [
            // Particle Animation Layer
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticlePainter(
                      particles: _particles,
                      mousePosition: _mousePosition,
                      animation: _particleController,
                    ),
                  );
                },
              ),
            ),

            // Content
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
              
                      const SizedBox(height: 30),
              
                      // Animated Logo
                      FadeInDown(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00FFD1), Color(0xFF4700FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FFD1).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 40),
              
                      // Title
                      FadeInDown(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          isLogin ? 'Welcome Back' : 'Join Us',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 40),
              
                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!isLogin)
                              FadeInDown(
                                delay: const Duration(milliseconds: 400),
                                child: _buildParticleTextField(
                                  controller: _nameController,
                                  hint: 'Full Name',
                                  icon: Icons.person_outline,
                                ),
                              ),
                            const SizedBox(height: 20),
                            FadeInDown(
                              delay: const Duration(milliseconds: 600),
                              child: _buildParticleTextField(
                                controller: _emailController,
                                hint: 'Email',
                                icon: Icons.email_outlined,
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeInDown(
                              delay: const Duration(milliseconds: 800),
                              child: _buildParticleTextField(
                                controller: _passwordController,
                                hint: 'Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                              ),
                            ),
                            const SizedBox(height: 40),
                            
                            // Submit Button
                            FadeInUp(
                              delay: const Duration(milliseconds: 1000),
                              child: _buildSubmitButton(),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Toggle Button
                            FadeInUp(
                              delay: const Duration(milliseconds: 1200),
                              child: TextButton(
                                onPressed: () => setState(() => isLogin = !isLogin),
                                child: Text(
                                  isLogin ? 'Create new account' : 'Already have an account?',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: const Color(0xFF00FFD1),
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
          ],
        ),
      ),
    );
  }

  Widget _buildParticleTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF00FFD1).withOpacity(0.2),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.spaceGrotesk(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.spaceGrotesk(
            color: Colors.white.withOpacity(0.5),
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF00FFD1)),
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
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF00FFD1), Color(0xFF4700FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FFD1).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
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
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double speed;
  late double radius;
  late Color color;

  Particle() {
    reset();
  }

  void reset() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    speed = 0.0001 + math.Random().nextDouble() * 0.0003;
    radius = 1 + math.Random().nextDouble() * 3;
    color = Color.lerp(
      const Color(0xFF00FFD1),
      const Color(0xFF4700FF),
      math.Random().nextDouble(),
    )!;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? mousePosition;
  final Animation<double> animation;

  ParticlePainter({
    required this.particles,
    required this.mousePosition,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Update particle position
      particle.y -= particle.speed * size.height;
      if (particle.y < 0) {
        particle.y = 1.0;
      }

      // Draw particle
      paint.color = particle.color.withOpacity(0.6);
      
      // Calculate distance from mouse if available
      if (mousePosition != null) {
        final dx = (particle.x * size.width - mousePosition!.dx);
        final dy = (particle.y * size.height - mousePosition!.dy);
        final distance = math.sqrt(dx * dx + dy * dy);
        
        if (distance < 100) {
          // Move particles away from mouse
          final angle = math.atan2(dy, dx);
          particle.x += math.cos(angle) * 0.01;
          particle.y += math.sin(angle) * 0.01;
        }
      }

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 