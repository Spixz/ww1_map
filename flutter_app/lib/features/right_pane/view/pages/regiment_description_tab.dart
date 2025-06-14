import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/widget/markdown.dart';

import 'package:ww1_map/common_widgets/common_widgets_export.dart';
import 'package:ww1_map/features/right_pane/providers/selected_regiment_provider.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';

class RegimentDescription extends ConsumerWidget {
  const RegimentDescription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegiment = ref.watch(selectedRegimentProvider);

    return selectedRegiment.when(
      data: (Regiment? regiment) {
        if (regiment == null) return Empty();
        if (regiment.description == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Text(context.tr("NoRegimentDescription")),
            ),
          );
        }
        return MarkdownWidget(
          data: regiment.description!,
          padding: EdgeInsets.only(left: 19, top: 13, right: 19, bottom: 20),
        );
      },
      error: (_, __) => Center(child: Text(context.tr("Error"))),
      loading: () => LoadingCircle(),
    );
  }
}
