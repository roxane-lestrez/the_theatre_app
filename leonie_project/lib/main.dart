import 'package:first_app/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is the color theme that will be applied to the whole app
var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 187, 37, 70));

// Create the dark color theme
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 187, 37, 70),
);

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Use a default theme provided by flutter and overwrite some selected settings
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        // Style of the AppBar (top bar)
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
      ),
      // Add a dark mode theme
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
      ),
      home: SplashScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
