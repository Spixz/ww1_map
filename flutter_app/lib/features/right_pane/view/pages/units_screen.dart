import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/right_pane/view/widgets/drag_indicator.dart';
import 'package:ww1_map/features/right_pane/view/widgets/regiment_infos_header.dart';
import 'package:ww1_map/utils/extensions/extensions.dart';

class RightPaneScreen extends ConsumerStatefulWidget {
  const RightPaneScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UnitsPageState();
}

class _UnitsPageState extends ConsumerState<RightPaneScreen> {
  bool _hovering = false;
  double width = 300;

  void _onDrag(DragUpdateDetails details) {
    setState(() {
      width = (width - details.delta.dx).clamp(150, 300);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tests = List<String>.generate(
      50,
      (index) => "${index.toString()} entry",
    );

    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight, // ou .resizeUpDown
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onPanUpdate: _onDrag, // gère la taille en fonction du delta
        child: Container(
          width: width,
          height: context.height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(blurRadius: 20, offset: Offset.fromDirection(5)),
            ],
          ),
          child: Row(
            children: [
              const DragIndicator(),
              Expanded(child: Column(children: [const RegimentInfosHeader()])),
            ],
          ),
        ),
      ),
    );
  }
}
