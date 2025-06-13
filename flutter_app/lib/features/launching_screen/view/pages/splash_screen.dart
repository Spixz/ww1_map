import 'package:flutter/material.dart';
import 'package:ww1_map/common_widgets/loading_circle.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const Scaffold(body: LoadingCircle()));
  }
}
