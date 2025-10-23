// Importing necessary packages and files.
import 'package:flutter/material.dart'; // Flutter's material design package for UI components.
import 'package:firebase_core/firebase_core.dart';
import 'package:my_pocket_wallet/firebase_options.dart';
import 'package:my_pocket_wallet/classes/homecontent.dart';

// Splashscreen now Stateful to initialize Firebase without blocking first frame
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool _firebaseReady = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase after first frame to show UI ASAP
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initFirebase();
    });
  }

  Future<void> _initFirebase() async {
    try {
      // Avoid duplicate initialization (e.g., after hot restart)
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      if (!mounted) return;
      setState(() {
        _firebaseReady = true;
        _error = null;
      });
    } catch (e, st) {
      // Log full error to console for diagnostics
      debugPrint('Firebase init failed: $e');
      debugPrint('$st');
      if (!mounted) return;
      setState(() => _error = 'Failed to initialize services');
    }
  }

  @override
  void didChangeDependencies() {
    // Precache splash image to avoid first paint hiccup
    precacheImage(const AssetImage("assets/images/bank_wallet.png"), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            Colors.blue.shade900, // Background color matching the app theme.
        body: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers the content vertically.
          children: [
            _topImageSection(), // Displays the top image section.
            const SizedBox(height: 24), // Spacing between sections.
            _middleScreenText(), // Displays the middle text section.
            const SizedBox(height: 24),
            if (_error != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _initFirebase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Retry'),
              ),
            ] else if (!_firebaseReady) ...[
              const SizedBox(height: 8),
              const CircularProgressIndicator(color: Colors.orangeAccent),
              const SizedBox(height: 16),
            ],
            _splashButton(context,
                enabled: _firebaseReady), // Displays the action buttons.
            const SizedBox(height: 8),
            TextButton(
              onPressed: !_firebaseReady
                  ? null
                  : () => Navigator.pushNamed(context, '/login'),
              child: const Text(
                'I already have an account? Log in',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Top Image Section - Optimized with RepaintBoundary
Widget _topImageSection() {
  return Container(
    padding: const EdgeInsets.all(16.0), // Padding around the image.
    child: Center(
      child: RepaintBoundary(
        child: Image.asset(
          "assets/images/bank_wallet.png", // Path to the image asset.
          width: 200, // Width of the image.
          height: 200, // Height of the image.
          fit: BoxFit.cover,
          cacheWidth: 200, // Cache optimized width
          cacheHeight: 200, // Cache optimized height
        ),
      ),
    ),
  );
}

// Middle Screen Text Section
Widget _middleScreenText() {
  return const Column(
    children: [
      Text(
        "My Pocket Wallet", // Main title text.
        style: TextStyle(
          fontSize: 24, // Font size.
          fontWeight: FontWeight.bold, // Bold font weight.
          color: Colors.white, // Text color.
        ),
      ),
      SizedBox(height: 10), // Spacing between texts.
      Text(
        "Your secure digital wallet for easy transactions", // Subtitle text.
        textAlign: TextAlign.center, // Center-align the text.
        style: TextStyle(
          fontSize: 16, // Font size.
          color: Colors.white70, // Text color with opacity.
        ),
      ),
    ],
  );
}

// Splash Button Section
Widget _splashButton(BuildContext context, {required bool enabled}) {
  return Column(
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent, // Button background color.
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30), // Rounded corners for the button.
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 32, vertical: 12), // Button padding.
        ),
        onPressed: !enabled
            ? null
            : () {
                // Navigate to register to create an account.
                Navigator.pushNamed(context, '/register');
              },
        child: const Text(
          "Create account", // Button text.
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold), // Button text style.
        ),
      ),
      const SizedBox(height: 12),
      TextButton(
        onPressed: !enabled
            ? null
            : () {
                // Option to continue without registration for now
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Homecontent()));
              },
        child: const Text(
          "Skip for now",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    ],
  );
}
