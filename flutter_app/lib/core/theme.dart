import 'package:flutter/material.dart';

final ThemeData ww1Theme = ThemeData(
  useMaterial3: false, // ou true si tu veux M3
  brightness: Brightness.light,

  // 1) Définition du ColorScheme
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF8B0000), // rouge sombre
    secondary: Color(0xFF556B2F), // olive drab (ancien accentColor)
    surface: Color(0xFFF5E1C0), // parchemin clair
    onSurface: Color(0xFF3E2723), // texte marron foncé
  ),

  // 2) Fond général / Scaffold
  scaffoldBackgroundColor: const Color(0xFFF5E1C0),

  // 3) AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF8B0000),
    foregroundColor: Colors.white,
    elevation: 2,
    titleTextStyle: TextStyle(
      fontFamily: 'Merriweather',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),

  // 4) Texte remappé
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
  ).apply(
    bodyColor: const Color(0xFF3E2723),
    displayColor: const Color(0xFF3E2723),
  ),

  // 5) Boutons mis à jour
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF8B0000), // ancien primary
      foregroundColor: Colors.white, // ancien onPrimary
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  ),

  // 6) Divers
  cardColor: const Color(0xFFFFFBEA),
  dividerColor: const Color(0xFF8B0000).withOpacity(0.3),
  iconTheme: const IconThemeData(color: Color(0xFF3E2723)),
  // scaffoldBackgroundColor: const Color(0xFFF5E1C0),
);
