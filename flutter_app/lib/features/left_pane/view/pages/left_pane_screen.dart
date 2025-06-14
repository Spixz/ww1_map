import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/common_widgets/common_widgets_export.dart';
import 'package:ww1_map/features/left_pane/providers/all_regiments_provider.dart';
import 'package:ww1_map/features/left_pane/providers/left_pane_notifier.dart';
import 'package:ww1_map/features/left_pane/view/widgets/close_arrow.dart';
import 'package:ww1_map/features/left_pane/view/widgets/open_arrow.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';
import 'package:ww1_map/shared/domain/repositories/regiment_repository.dart';
import 'package:ww1_map/utils/extensions/extensions.dart';

class LeftPaneScreen extends ConsumerWidget {
  const LeftPaneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paneState = ref.watch(leftPaneNotifierProvider);

    if (!paneState.enabled) {
      return SizedBox(
        height: context.height,
        child: Center(child: OpenArrow()),
      );
    } else {
      return const Row(children: [_ListRegiments(), CloseArrow()]);
    }
  }
}

class _ListRegiments extends ConsumerWidget {
  const _ListRegiments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 290,
      height: context.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [BoxShadow(blurRadius: 20, offset: Offset(3, 3))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Expanded(child: _RegimentListViewBuilder())],
      ),
    );
  }
}

class _RegimentListViewBuilder extends ConsumerWidget {
  const _RegimentListViewBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRegiments = ref.watch(
      allRegimentsProvider(SortRegimentBy.eventsAvailibility),
    );

    return allRegiments.when(
      data: (regiments) {
        return ListView.builder(
          itemCount: regiments.length,
          itemBuilder: (context, index) {
            final regiment = regiments[index];
            return _RegimentCard(regiment);
          },
        );
      },
      loading: () => LoadingCircle(),
      error: (_, __) => Text("error lor"),
    );
  }
}

class _RegimentCard extends ConsumerWidget {
  const _RegimentCard(this.regiment);
  final Regiment regiment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(regiment.title),
      enabled: regiment.description != null,
    );
  }
}
