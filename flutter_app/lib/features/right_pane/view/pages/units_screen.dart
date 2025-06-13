import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/features/right_pane/view/widgets/content_tab.dart';
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
  double width = 330;

  void _onDrag(DragUpdateDetails details) {
    setState(() {
      width = (width - details.delta.dx).clamp(330, 700);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // color: Colors.grey.shade300,
            // color: Color(0xFFF5E1C0),
            color: Colors.white,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RegimentInfosHeader(),
                    Expanded(child: const RightPaneContentTab()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
