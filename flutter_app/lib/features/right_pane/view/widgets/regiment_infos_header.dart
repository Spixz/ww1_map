import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ww1_map/common_widgets/common_widgets_export.dart';
import 'package:ww1_map/core/colors.dart';
import 'package:ww1_map/features/pdf_window/providers/pdf_window_notifier.dart';
import 'package:ww1_map/features/right_pane/providers/selected_regiment_provider.dart';
import 'package:ww1_map/shared/domain/models/regiments/regiment.dart';

class RegimentInfosHeader extends ConsumerWidget {
  const RegimentInfosHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegiment = ref.watch(selectedRegimentProvider);

    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(color: rightPaneHeaderColor),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Text(
            regiment!.title,
            style: TextStyle(
              fontFamily: "Mulish", //"Merriweather",
              fontSize: 27,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 15),
            child: _PdfButton(),
          ),
        ),
      ],
    );
  }
}

class _PdfButton extends ConsumerWidget {
  const _PdfButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regimentProvider = ref.watch(selectedRegimentProvider);

    return regimentProvider.maybeWhen(
      data: (Regiment? regiment) {
        if (regiment == null) return Empty();

        final pdfAvailaible = regiment.medias.pdf != null;
        final Color color =
            (pdfAvailaible) ? Colors.white : Colors.grey.shade600;

        return InkWell(
          onTap: () {
            if (!pdfAvailaible) return;
            ref
                .read(pdfWindowNotifierProvider.notifier)
                .openDocument(title: regiment.title, url: regiment.medias.pdf!);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              Icon(Icons.menu_book_outlined, size: 16, color: color),
              Text(
                context.tr("OriginalEdition"),
                style: TextStyle(fontSize: 14, color: color),
              ),
            ],
          ),
        );
      },
      orElse: () => LoadingCircle(),
    );
  }
}
