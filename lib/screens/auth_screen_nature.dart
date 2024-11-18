import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

class AuthScreenNature extends StatefulWidget {
  const AuthScreenNature({super.key});

  @override
  State<AuthScreenNature> createState() => _AuthScreenNatureState();
}

class _AuthScreenNatureState extends State<AuthScreenNature>
    with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _leafController;
  late AnimationController _flowController;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _leafController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated nature background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF1F8E9),
                  Color(0xFFDCEDC8),
                ],
              ),
            ),
          ),

          // Animated leaves
          ...List.generate(20, (index) {
            return AnimatedBuilder(
              animation: _leafController,
              builder: (context, child) {
                final random = math.Random(index);
                final size = 20.0 + random.nextDouble() * 30;
                final angle = _leafController.value * 2 * math.pi +
                    (index * math.pi / 10);
                final x = math.sin(angle) * 200 +
                    MediaQuery.of(context).size.width * 0.5;
                final y = math.cos(angle) * 100 +
                    MediaQuery.of(context).size.height * 0.3;

                return Positioned(
                  left: x,
                  top: y,
                  child: Transform.rotate(
                    angle: angle,
                    child: Icon(
                      Icons.eco,
                      size: size,
                      color: Color.lerp(
                        const Color(0xFF81C784),
                        const Color(0xFF388E3C),
                        random.nextDouble(),
                      )!.withOpacity(0.3),
                    ),
                  ),
                );
              },
            );
          }),

          // Organic shapes
          CustomPaint(
            painter: OrganicShapePainter(animation: _flowController),
            size: Size.infinite,
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
                        foregroundColor: const Color(0xFF388E3C),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    FadeInDown(
                      child: Text(
                        isLogin ? 'Welcome\nBack' : 'Join\nNature',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Form
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
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
                              _buildNatureTextField(
                                controller: _nameController,
                                hint: 'Full Name',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 20),
                            ],
                            _buildNatureTextField(
                              controller: _emailController,
                              hint: 'Email',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            _buildNatureTextField(
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
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            color: const Color(0xFF388E3C),
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

  Widget _buildNatureTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E6C9)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.lato(
          color: const Color(0xFF2E7D32),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.lato(
            color: const Color(0xFF81C784),
            fontSize: 16,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF81C784)),
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
              const Color(0xFF66BB6A),
              const Color(0xFF43A047),
            ],
            begin: _isButtonPressed ? Alignment.centerRight : Alignment.centerLeft,
            end: _isButtonPressed ? Alignment.centerLeft : Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isButtonPressed
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF66BB6A).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            isLogin ? 'Sign In' : 'Create Account',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class OrganicShapePainter extends CustomPainter {
  final Animation<double> animation;

  OrganicShapePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA5D6A7).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final random = math.Random(42);

    for (var i = 0; i < 3; i++) {
      final points = <Offset>[];
      final count = 5 + random.nextInt(3);
      final radius = size.width * (0.3 + random.nextDouble() * 0.2);
      final centerX = size.width * (0.3 + random.nextDouble() * 0.4);
      final centerY = size.height * (0.3 + random.nextDouble() * 0.4);

      for (var j = 0; j <= count; j++) {
        final angle = (j / count) * 2 * math.pi +
            animation.value * 2 * math.pi;
        final radiusOffset = math.sin(angle * 3) * 30;
        final x = centerX + (radius + radiusOffset) * math.cos(angle);
        final y = centerY + (radius + radiusOffset) * math.sin(angle);
        
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 