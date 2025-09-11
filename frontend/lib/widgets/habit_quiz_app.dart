import 'package:flutter/material.dart';

class HabitQuizApp extends StatelessWidget {
  const HabitQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuizScreen();
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  List<String?> _answers = List.filled(12, null);

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "🎂 ¿Cuántas vueltas al sol llevas ya?",
      "options": [
        "Menos de 18",
        "18–25",
        "26–35",
        "36–50",
        "Más de 50",
      ],
    },
    {
      "question": "👤 ¿Cómo te identificas?",
      "options": [
        "Mujer",
        "Hombre",
        "Prefiero no decirlo",
        "Otro",
      ],
    },
    {
      "question": "🏃 ¿Qué capítulo describe mejor tu actividad física?",
      "options": [
        "Maratón de sillón",
        "Un par de episodios activos",
        "Siempre en movimiento",
      ],
    },
    {
      "question": "🌱 ¿Qué hábito quieres plantar primero en tu jardín de bienestar?",
      "options": [
        "Ejercicio físico",
        "Alimentación balanceada",
        "Mejorar el sueño",
        "Hidratación",
        "Manejo del estrés",
      ],
    },
    {
      "question": "⏳ ¿Qué tan rápido te gustaría ver los frutos de tu esfuerzo?",
      "options": [
        "En pocas semanas",
        "En unos meses",
        "No tengo prisa, lo importante es el camino",
      ],
    },
    {
      "question": "🪨 ¿Con qué obstáculos te has topado antes al intentar un nuevo hábito?",
      "options": [
        "Falta de tiempo",
        "Falta de motivación", 
        "No saber cómo empezar",
        "Me rindo fácilmente",
        "Otro"
      ],
    },
    {
      "question": "🧩 ¿Qué pieza crees que te falta para mantener la constancia?",
      "options": [
        "Recordatorios",
        "Motivación extra",
        "Información clara", 
        "Acompañamiento",
        "Gamificación/diversión",
        "Rutina y preferencias"
      ],
    },
    {
      "question": "⏰ ¿En qué momento del día floreces más para trabajar tus hábitos?",
      "options": [
        "Mañana",
        "Tarde",
        "Noche"
      ],
    },
    {
      "question": "📅 ¿Cuánto tiempo realista puedes regalarte cada día?",
      "options": [
        "5–10 minutos",
        "15–30 minutos",
        "30–60 minutos",
        "Más de 1 hora"
      ],
    },
    {
      "question": "🔔 ¿Qué tipo de recordatorio prefieres?",
      "options": [
        "Un empujoncito suave",
        "Un \"¡vamos, tú puedes!\"",
        "Silencio, que yo me acuerdo"
      ],
    },
    {
      "question": "🎮 Si tu progreso fuera un videojuego, ¿qué estilo prefieres?",
      "options": [
        "Nivel a nivel con retos",
        "Historia relajada y flexible",
        "Competencia amistosa",
        "Social y emocional"
      ],
    },
    {
      "question": "🌍 ¿Quieres que tu viaje sea solitario o compartido con otros exploradores?",
      "options": [
        "Prefiero hacerlo sola/o",
        "Quiero compartir con amigos",
        "Quiero competir con otros",
        "Prefiero decidir más adelante"
      ],
    }
  ];

  void _selectAnswer(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
    
    if (_currentQuestionIndex < _questions.length - 1) {
      _nextQuestion();
    } else {
      _completeQuiz();
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _completeQuiz() {
    // Aquí puedes guardar las respuestas del usuario
    print('Respuestas del cuestionario: $_answers');
    
    // Mostrar un mensaje de éxito antes de navegar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Cuestionario completado! Redirigiendo al dashboard...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navegar al dashboard después de completar el cuestionario
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        leading: _currentQuestionIndex > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousQuestion,
              )
            : null,
        title: const Text("Cuestionario de Hábitos"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "${_currentQuestionIndex + 1}/${_questions.length}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de progreso
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion["question"],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion["options"].length,
                itemBuilder: (context, index) {
                  final option = currentQuestion["options"][index];
                  final isSelected = _answers[_currentQuestionIndex] == option;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: isSelected ? 4 : 2,
                    color: isSelected ? Colors.blue.shade50 : null,
                    child: ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      leading: Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                      onTap: () => _selectAnswer(option),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
