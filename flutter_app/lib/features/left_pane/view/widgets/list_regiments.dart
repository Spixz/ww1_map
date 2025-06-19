import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ww1_map/features/left_pane/providers/all_regiments_provider.dart';
import 'package:ww1_map/common_widgets/common_widgets_export.dart';
import 'package:ww1_map/features/right_pane/providers/selected_regiment_id_notifier.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';
import 'package:ww1_map/shared/domain/repositories/regiment_repository.dart';
import 'package:ww1_map/utils/extensions/buildcontext_extension.dart';

class ListRegiments extends ConsumerWidget {
  const ListRegiments({super.key});

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
  const _RegimentListViewBuilder();

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
      loading: () => CircularLoading(),
      error: (_, __) => CenteredMessage(message: context.tr("ErrorNoRegimentsFound")),
    );
  }
}

class _RegimentCard extends ConsumerWidget {
  const _RegimentCard(this.regiment);
  final Regiment regiment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegimentId = ref.watch(selectedRegimentIdProvider);

    return ListTile(
      title: Text(regiment.title),
      selected: selectedRegimentId == regiment.id,
      enabled: regiment.description != null,
      onTap: () {
        ref.read(selectedRegimentIdProvider.notifier).updateToggle(regiment.id);
      },
    );
  }
}
