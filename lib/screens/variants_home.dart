import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_screen.dart';
import 'auth_screen_card.dart';
import 'auth_screen_neumorphic.dart';
import 'auth_screen_neon.dart';
import 'auth_screen_liquid.dart';
import 'auth_screen_particle.dart';
import 'auth_screen_origami.dart';
import 'auth_screen_retro.dart';
import 'auth_screen_nature.dart';
import 'auth_screen_space.dart';
import 'auth_screen_material.dart';
import 'auth_screen_split.dart';
import 'auth_screen_isometric.dart';

class VariantsHome extends StatelessWidget {
  const VariantsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.purple.shade300,
              Colors.blue.shade300,
            ],
          ).createShader(bounds),
          child: Text(
            'Auth UI Variants',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: authVariants.length,
        itemBuilder: (context, index) {
          final variant = authVariants[index];
          return _VariantCard(variant: variant);
        },
      ),
    );
  }
}

class _VariantCard extends StatelessWidget {
  final AuthVariant variant;

  const _VariantCard({required this.variant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => variant.screen),
      ),
      child: Container(
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    variant.color.withOpacity(0.5),
                    variant.color,
                  ],
                ),
              ),
              child: Icon(
                variant.icon,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              variant.name,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                variant.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthVariant {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Widget screen;

  const AuthVariant({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

final List<AuthVariant> authVariants = [
  AuthVariant(
    name: 'Gradient Mesh',
    description: 'Modern UI with animated mesh background and gradient effects',
    icon: Icons.gradient,
    color: Colors.purple,
    screen: const AuthScreen(),
  ),
  AuthVariant(
    name: 'Parallax Card',
    description: 'Minimalist card design with parallax background effect',
    icon: Icons.crop_square_rounded,
    color: Colors.blue,
    screen: const AuthScreenCard(),
  ),
  AuthVariant(
    name: 'Neumorphic',
    description: 'Soft 3D interface with dynamic color transitions',
    icon: Icons.layers,
    color: Colors.grey,
    screen: const AuthScreenNeumorphic(),
  ),
  AuthVariant(
    name: 'Neon Glass',
    description: 'Futuristic UI with neon effects and floating elements',
    icon: Icons.light_mode,
    color: Colors.cyan,
    screen: const AuthScreenNeon(),
  ),
  AuthVariant(
    name: 'Liquid Motion',
    description: 'Fluid animations with morphing shapes and waves',
    icon: Icons.water_drop,
    color: Colors.blue,
    screen: const AuthScreenLiquid(),
  ),
  AuthVariant(
    name: 'Particle Flow',
    description: 'Interactive particles with mouse tracking and fluid animations',
    icon: Icons.blur_on,
    color: const Color(0xFF00FFD1),
    screen: const AuthScreenParticle(),
  ),
  AuthVariant(
    name: 'Origami',
    description: 'Minimalist design with geometric patterns and paper-fold effects',
    icon: Icons.architecture,
    color: const Color(0xFF4338CA),
    screen: const AuthScreenOrigami(),
  ),
  AuthVariant(
    name: 'Retro Gaming',
    description: '8-bit style with pixel art and arcade aesthetics',
    icon: Icons.videogame_asset,
    color: const Color(0xFF00FF00),
    screen: const AuthScreenRetro(),
  ),
  AuthVariant(
    name: 'Nature Flow',
    description: 'Organic shapes with natural elements and flowing animations',
    icon: Icons.eco,
    color: const Color(0xFF4CAF50),
    screen: const AuthScreenNature(),
  ),
  AuthVariant(
    name: 'Space Journey',
    description: 'Cosmic theme with starfield and floating planets',
    icon: Icons.rocket_launch,
    color: Colors.blue,
    screen: const AuthScreenSpace(),
  ),
  AuthVariant(
    name: 'Material You',
    description: 'Modern Material Design with dynamic color adaptation',
    icon: Icons.palette,
    color: const Color(0xFF6750A4),
    screen: const AuthScreenMaterial(),
  ),
  AuthVariant(
    name: 'Minimal Split',
    description: 'Clean split-screen design with subtle animations',
    icon: Icons.view_agenda,
    color: Colors.black87,
    screen: const AuthScreenSplit(),
  ),
  AuthVariant(
    name: 'Isometric',
    description: '3D-style design with rotating geometric shapes',
    icon: Icons.view_in_ar,
    color: Colors.purple,
    screen: const AuthScreenIsometric(),
  ),
]; 