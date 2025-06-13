import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww1_map/common_widgets/loading_circle.dart';
import 'package:ww1_map/features/right_pane/providers/selected_regiment_provider.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';

class RegimentInfosHeader extends ConsumerWidget {
  const RegimentInfosHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegiment = ref.watch(selectedRegimentProvider);

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: selectedRegiment.when(
        data: (Regiment? regiment) => _Header(regiment),
        error: (_, __) => Center(child: Text("Error")),
        loading: () => LoadingCircle(),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header(this.regiment);
  final Regiment? regiment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (regiment == null) {
      return Center(child: Text("Aucun regiment sélectionné"));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(regiment!.title, style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
