import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0; // 0..5
  // Para animar brevemente la estrella que tocas
  int _pressedStarIndex = -1;

  void _setRating(int value) {
    setState(() {
      _rating = value;
      _pressedStarIndex = value - 1;
    });
    // quitar la "presión" animada después de un corto delay
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) {
        setState(() {
          _pressedStarIndex = -1;
        });
      }
    });
  }

  void _onRateNow() {
    // Aquí va la acción real; por ahora solo mostramos snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Gracias por calificar con $_rating estrella${_rating == 1 ? '' : 's'}!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                ),
              ),

              SizedBox(height: 6),

              // Título grande
              const Text(
                'Enjoying Sounter?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // Subtítulo / descripción
              const Text(
                'With how many stars do you rate your experience.\nTap a star to rate!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 22),

              // Fila de estrellas
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final selected = index < _rating;
                  final isPressed = index == _pressedStarIndex;
                  return GestureDetector(
                    onTap: () => _setRating(index + 1),
                    child: AnimatedScale(
                      scale: isPressed ? 1.18 : 1.0,
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          selected ? Icons.star : Icons.star_border,
                          size: 44,
                          color: selected
                              ? const Color(0xFFFFC107)
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 26),

              // Botón "Rate now" (estilo morado/gradient similar al video)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: InkWell(
                  onTap: _rating > 0 ? _onRateNow : null,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.blue,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Rate now',
                        style: TextStyle(
                          color: _rating > 0 ? Colors.white : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // "NO THANKS" link
              TextButton(
                onPressed: () {
                  // ejemplo: cerrar pantalla
                  Navigator.of(context).maybePop();
                },
                child: const Text(
                  'NO THANKS',
                  style: TextStyle(
                    color: Color(0xFF5B3DF1),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),

              // Empuja el contenido hacia arriba para que quede parecido al video
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
