import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Screens
import 'src/screens/auth/login_screen.dart';
import 'src/screens/auth/sign_up_screen.dart';
import 'src/screens/auth/welcome_screen.dart';
import 'src/screens/home/main_dashboard.dart';
import 'src/screens/Questionaire/questionaire.dart';
import 'src/screens/faqs/faq_screen.dart';
import 'src/screens/auth/log_sign.dart';
import 'src/screens/Project/saved_project.dart';
import 'src/screens/Project/project_detail_page.dart';
import 'src/screens/utils/questionnaire_storage.dart';
import 'src/screens/Project/ui_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(); // required
  runApp(const NexovateApp());
}


class NexovateApp extends StatelessWidget {
  const NexovateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexovate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.orange,
          secondary: Colors.deepOrangeAccent,
        ),
      ),
      
      initialRoute: '/welcome',
      onGenerateRoute: (settings) {
        
        switch (settings.name) {
          case '/welcome':
            return _fadeRoute(const WelcomeScreen());
          case '/login':
            return _fadeRoute(const EnhancedAuthScreen());
          case '/dashboard':
            return _fadeRoute(const DashboardScreen());
          case '/start_project':
            return _fadeRoute(const QuestionnaireScreen());
          case '/home':
            return _fadeRoute(const HomeScreen());
          case '/completion':
            return _fadeRoute(const DashboardScreen());
          case '/faqs':
            return _fadeRoute(FAQScreen());
          case '/saved_proj':
          return _fadeRoute(const SavedProjectsScreen());
          case '/project_detail':
          final project = settings.arguments as SavedProject;
          return _fadeRoute(ProjectDetailPage(project: project));
          case '/uiPreview':
          final project = settings.arguments as SavedProject;
          return _fadeRoute(UIProjectScreen(project: project));
          default:
            return _fadeRoute(const WelcomeScreen());
        }
      },
    );
  }

  PageRouteBuilder _fadeRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.rocket_launch, size: 70, color: Colors.orange),
              const SizedBox(height: 25),
              const Text(
                'Welcome to Nexovate!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Your journey to smart innovation starts here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

