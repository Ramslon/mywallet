// Importing necessary packages and files.
import 'package:flutter/material.dart'; // Flutter's material design package for UI components.
import 'package:my_pocket_wallet/classes/homecontent.dart';
import 'package:my_pocket_wallet/screens/splashscreen.dart';
import 'package:my_pocket_wallet/utils/performance_config.dart';
import 'package:my_pocket_wallet/screens/auth/register.dart';
import 'package:my_pocket_wallet/screens/pages/login_screen.dart';


// The main function is the entry point of the Flutter application.
Future<void> main() async {
  // Ensure Flutter bindings are initialized before any async calls
  WidgetsFlutterBinding.ensureInitialized();
  // Run the app by calling the MyPocketWallet widget.
  runApp(const MyPocketWallet());
}

// Root widget for the app.
class MyPocketWallet extends StatelessWidget {
  const MyPocketWallet({super.key}); // Constructor for the MyPocketWallet widget.

  @override
  Widget build(BuildContext context) {
    // The build method describes the part of the user interface represented by this widget.
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in the top-right corner.
      title: 'My Pocket Wallet', // Title of the app.
      theme: PerformanceConfig.optimizedTheme, // Use optimized theme for better performance.
      initialRoute: '/', // The initial route when the app starts.
      routes: {
        // Define the routes for the app.
        '/': (context) => const Splashscreen(), // The root route, which shows the splash screen.
        '/home': (context) => const Homecontent(), // The home route, which shows the home content.
        '/register': (context) => const RegisterScreen(), // Registration route
        '/login': (context) => const LoginPage(), // Login route
        // Add more routes as needed
      },
    );
  }
}