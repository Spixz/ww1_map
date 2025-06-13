import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/map/view/pages/map_screen.dart';
import 'package:ww1_map/features/pdf_window/view/page/pdf_window.dart';
import 'package:ww1_map/features/left_pane/view/pages/left_pane_screen.dart';
import 'package:ww1_map/features/right_pane/view/pages/right_pane_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapScreen(),
          Positioned(top: 0, left: 0, child: const LeftPaneScreen()),
          Positioned(top: 0, right: 0, child: const RightPaneScreen()),
          PdfWindowScreen(),
        ],
      ),
    );
  }
}
