import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppLoadingFailedScreen extends StatelessWidget {
  const AppLoadingFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [Center(child: Text(context.tr("AppLoadingFailed")))],
        ),
      ),
    );
  }
}
