import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:passport_digital_itc/providers/admin_provider.dart';
import 'package:passport_digital_itc/providers/conference_provider.dart';
import 'package:passport_digital_itc/providers/professor_provider.dart';
import 'package:passport_digital_itc/providers/student_provider.dart';
import 'package:passport_digital_itc/screens/admin/add_user_screen.dart';
import 'package:passport_digital_itc/screens/admin/admin_screen.dart';
import 'package:passport_digital_itc/screens/admin_screen.dart';
import 'package:passport_digital_itc/screens/not_found_screen.dart';
import 'package:passport_digital_itc/screens/professors/staff_creen.dart';
import 'package:passport_digital_itc/services/firebase_auth_methods.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'config/palette.dart';
import 'package:passport_digital_itc/screens/login_screen.dart';
import 'package:passport_digital_itc/screens/onboarding_screen.dart';
import 'package:passport_digital_itc/screens/register_screen.dart';
import 'package:passport_digital_itc/screens/students/profile_screen.dart';
import 'screens/admin/users_admin_screen.dart';
import 'screens/forgot_pass_screen.dart';
import 'screens/professors/add_conference_screen.dart';
import 'screens/professors/home_screen.dart';
import 'screens/students/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PassPortDigitalITC());
}

class PassPortDigitalITC extends StatefulWidget {
  const PassPortDigitalITC({super.key});

  @override
  State<PassPortDigitalITC> createState() => _PassPortDigitalITCState();
}

class _PassPortDigitalITCState extends State<PassPortDigitalITC> {
  @override
  Widget build(BuildContext context) {
    final routes = {
      '/student': (context) => const HomeStudentScreen(), //lista
      '/tutorial': (context) => const OnBoardingScreen(), //lista
      '/profile': (context) => const ProfileScreen(), //lista
      '/login': (context) => const LoginScreen(), //lista
      '/register': (context) => const RegisterScreen(), //lista
      '/staff': (context) => const HomeScreenStaff(), //lista
      '/professors': (context) => const HomeScreenProfessor(), //lista
      '/admin': (context) => const AdminScreen(), //pendiente de crear
      '/usersAdmin': (context) => const UsersAdminScreen(), //pendiente de crear
      '/forgotpassword': (context) => const ForgotPasswordScreen(), //lista
      '/addConference': (context) => const AddConferenceScreen(),
      '/addUser': (context) => const addUserScreen(),
      // '/livedata': (context) => const UserInformation(),
    };
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AdminProvider>(create: (_) => AdminProvider()),
        ChangeNotifierProvider<ConferenceProvider>(
            create: (_) => ConferenceProvider()),
        ChangeNotifierProvider<StudentProvider>(
            create: (_) => StudentProvider()),
        ChangeNotifierProvider<ProfessorProvider>(
            create: (_) => ProfessorProvider()),
        ChangeNotifierProvider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null),
        StreamProvider(
            create: (context) =>
                context.read<ConferenceProvider>().getConferenceListStream(),
            initialData: null),
        StreamProvider(
            create: (context) =>
                context.read<ConferenceProvider>().getIdByConferenceStream(),
            initialData: null),
        StreamProvider(
            create: (context) => context.read<AdminProvider>().getUsers(),
            initialData: null),
      ],
      child: MaterialApp(
        scrollBehavior: CustomScrollBehavior(),
        title: 'Pasaporte Digital ITC',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: routes,
        onGenerateRoute: (settings) {
          // esta opción se ejecuta cuando se llama una ruta que no existe
          return MaterialPageRoute(
            builder: (context) => const NotFoundScreen(),
          );
        },
        theme: ThemeData(primarySwatch: Palette.ktoGreen),
        home: const Scaffold(
          resizeToAvoidBottomInset: false,
          body: (AuthWrapper()),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    final role = context.watch<FirebaseAuthMethods>().role;
    if (firebaseUser != null) {
      switch (role) {
        case 'Estudiante':
          return const OnBoardingScreen();
        case 'Monitor':
          return const HomeScreenStaff();
        case 'Profesor':
          return const HomeScreenProfessor();
        case 'JVP':
          return const AdminScreen();
        default:
          return const LoginScreen();
      }
    }
    return const LoginScreen();
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
