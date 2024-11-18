import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class AuthScreenMaterial extends StatefulWidget {
  const AuthScreenMaterial({super.key});

  @override
  State<AuthScreenMaterial> createState() => _AuthScreenMaterialState();
}

class _AuthScreenMaterialState extends State<AuthScreenMaterial>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  late AnimationController _rippleController;
  bool _isButtonPressed = false;
  int _selectedColorSeed = 0;

  final List<Color> colorSeeds = [
    const Color(0xFF6750A4), // Purple
    const Color(0xFF3871BB), // Blue
    const Color(0xFF1B6C4D), // Green
    const Color(0xFFB4262C), // Red
    const Color(0xFF006A6A), // Cyan
  ];

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: colorSeeds[_selectedColorSeed],
      brightness: Brightness.light,
    );

    return Theme(
      data: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Scaffold(
          body: Stack(
            children: [
              // Background with dynamic color
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.surface,
                    ],
                  ),
                ),
              ),

              // Color seed selector
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        ...List.generate(colorSeeds.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedColorSeed = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: colorSeeds[index],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _selectedColorSeed == index
                                        ? colorScheme.onPrimaryContainer
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),

                      // Title
                      FadeInDown(
                        child: Text(
                          isLogin ? 'Welcome\nBack' : 'Create\nAccount',
                          style: GoogleFonts.roboto(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            height: 1.2,
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
                              _buildTextField(
                                controller: _nameController,
                                label: 'Full Name',
                                icon: Icons.person_outline,
                                colorScheme: colorScheme,
                              ),
                              const SizedBox(height: 16),
                            ],
                            _buildTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              colorScheme: colorScheme,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              colorScheme: colorScheme,
                            ),
                            const SizedBox(height: 32),

                            // Submit button
                            _buildSubmitButton(colorScheme),
                            const SizedBox(height: 16),

                            // Toggle button
                            TextButton(
                              onPressed: () => setState(() => isLogin = !isLogin),
                              child: Text(
                                isLogin ? 'Create new account' : 'Already have an account?',
                                style: TextStyle(color: colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (label == 'Email' && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        if (label == 'Password' && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(ColorScheme colorScheme) {
    return FilledButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Add authentication logic
        }
      },
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        isLogin ? 'Sign In' : 'Create Account',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 