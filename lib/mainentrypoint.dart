import 'package:flutter/material.dart';
// We no longer need to import HomePage here.
import 'loginpage.dart';
import 'package:rec_app/homepage.dart';
import 'package:rec_app/recipedetailspage.dart';


// The main function is the entry point for all Flutter apps.
void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        // Define the default brightness and colors.
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Define the default font family.
        fontFamily: 'Roboto',
      ),
      // Use named routes to navigate between screens
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        // --- The '/home' route is now REMOVED ---
        // Navigation to the HomePage is handled directly from the LoginPage,
        // which allows us to pass the user data.
      },
      debugShowCheckedModeBanner: false, // Hides the debug banner
    );
  }
}

