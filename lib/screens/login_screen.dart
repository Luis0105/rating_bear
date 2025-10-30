import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

// Pantalla principal del login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controlador de la animación de Rive
  StateMachineController? controller;
  // Variables que controlan las animaciones (definidas en Rive)
  SMIBool? isChecking; // Booleano de verificación
  SMITrigger? trigFail; // Dispara animación de fallo
  SMITrigger? trigSuccess; // Dispara animación de éxito
  SMINumber? numLook; // Controla dirección o mirada del personaje

  int _rating = 0; // Guarda la cantidad de estrellas seleccionadas
  bool _showRating = false; // Controla si se muestra el texto del resultado

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // Tamaño de pantalla

    return Scaffold(
      // Estructura básica visual
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20), // Márgenes laterales
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Alinea los widgets arriba
            children: [
              const SizedBox(height: 30), // Espacio superior

              // Contenedor de la animación del personaje
              SizedBox(
                width: size.width, // Ancho completo
                height: 270, // Altura fija para la animación
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv', // Archivo .riv usado
                  stateMachines: ["Login Machine"], // Nombre del StateMachine
                  onInit: (artboard) {
                    // Callback al inicializar
                    // Se inicializa el controlador de la animación
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    if (controller == null) return;
                    artboard.addController(controller!);
                    // Se buscan las variables creadas en Rive
                    isChecking = controller!.findSMI('isChecking');
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigFail = controller!.findSMI('trigFail');
                    numLook = controller!.findSMI('numLook');
                  },
                ),
              ),

              // Primer texto: "Enjoying Sounter?"
              const SizedBox(height: 15),
              const Text(
                "Enjoying Sounter?", // Título
                textAlign: TextAlign.center, // Centrado
                style: TextStyle(
                  // Estilo del texto
                  color: Colors.black,
                  fontWeight: FontWeight.bold, // Negrita
                  fontSize: 22, // Tamaño de fuente
                ),
              ),
              const SizedBox(height: 10),

              // Texto descriptivo
              SizedBox(
                width: size.width * 0.85, // 85% del ancho total
                child: const Text(
                  "With how many stars do you rate your experience?\nTap a star to rate!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500, // Peso medio
                    fontSize: 18,
                    height: 1.5, // Altura de línea
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Fila de estrellas para calificar
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra las estrellas
                children: List.generate(5, (index) {
                  // Genera 5 estrellas
                  final bool isSelected =
                      index < _rating; // Determina si la estrella está activa

                  return AnimatedScale(
                    // Animación de escalado para cada estrella
                    // isSelected indica si la estrella está encendida
                    scale: isSelected
                        ? 1.3
                        : 1.0, // 1.3: agranda estrella, 1.0: normal
                    duration:
                        const Duration(seconds: 1), // Tiempo de la animación
                    curve: Curves.easeOutBack, // Suaviza el rebote visual
                    child: IconButton(
                      splashRadius: 28, // Tamaño del efecto al presionar
                      onPressed: () async {
                        setState(() {
                          _rating = index + 1; // Actualiza número de estrellas
                          _showRating =
                              false; // Oculta el texto hasta que presione “Rate now”
                        });

                        // Control de la mirada según la calificación
                        if (_rating == 1) {
                          trigFail?.fire();
                          numLook?.value =
                              100; // Mira completamente a la derecha
                        } else if (_rating == 2) {
                          trigFail?.fire();
                          numLook?.value = 100;
                        } else if (_rating == 3) {
                          isChecking?.value = true; // Neutral
                          numLook?.value = 30; // Mira al centro
                        } else if (_rating == 4) {
                          trigSuccess?.fire();
                          numLook?.value = 0; // Mira a la izquierda
                        } else if (_rating == 5) {
                          trigSuccess?.fire();
                          numLook?.value = 0;
                        }

                        // Espera un segundo para dar tiempo a la animación
                        await Future.delayed(const Duration(milliseconds: 200));
                      },
                      icon: Icon(
                        isSelected
                            ? Icons.star
                            : Icons.star_border, // Llena o vacía
                        color: Colors.amber, // Color dorado
                        size: 50, // Tamaño del ícono
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 10),

              // Botón para mostrar la calificación
              Container(
                width: 300, // Ancho del botón
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  boxShadow: [
                    // Sombra del botón
                    BoxShadow(
                      // Sombra azul
                      color: Colors.blue,
                      blurRadius: 10, // Difuminado de la sombra
                      offset: const Offset(0, 5), // Desplazamiento
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showRating = true; // Muestra el resultado
                    });
                  },
                  child: const Text(
                    "Rate now", // Texto del botón
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Muestra resultado de calificación con animación
              AnimatedOpacity(
                // Animación de opacidad para el texto de resultado
                duration: const Duration(seconds: 1), // Tiempo de aparición
                // Se usa para mostrar u ocultar el mensaje de calificación cuando el usuario presiona el botón “Rate now”.
                opacity: _showRating ? 1 : 0, // 1 visible, 0 invisible
                child: Column(
                  children: [
                    Text(
                      "You rated: ${_rating.toStringAsFixed(1)} ★", // Muestra número de estrellas, ejemplo: "You rated: 4.0 ★"
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold, // Negrita
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Mensaje según la calificación
                    Text(
                      _rating <=
                              2 // Si la calificación es 2 o menos muestra mensaje triste
                          ? "😢 We'll try to do better!"
                          : _rating == 3 // Si es 3 muestra mensaje neutral
                              ? "😊 Thanks for your feedback!"
                              : "🤩 We're glad you loved it!",
                      style: TextStyle(
                        color: Colors.blue[800], // Azul oscuro
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Botón de "No gracias"
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12), // Bordes redondeados
                  border:
                      Border.all(color: Colors.blue, width: 2), // Borde azul
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {}, // Sin acción por ahora
                  child: const Text(
                    "NO THANKS", // Texto del botón
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
