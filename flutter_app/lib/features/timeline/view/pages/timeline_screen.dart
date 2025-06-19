import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:ww1_map/features/left_pane/providers/left_pane_notifier.dart';
import 'package:ww1_map/features/right_pane/providers/right_pane_notifier.dart';
import 'package:ww1_map/features/timeline/domain/models/date_interval.dart';
import 'package:ww1_map/features/timeline/providers/selected_date_provider.dart';
import 'package:ww1_map/utils/extensions/buildcontext_extension.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimelisteScreenState();
}

class _TimelisteScreenState extends ConsumerState<TimelineScreen> {
  final startAt = DateTime(1914, 1, 1);
  final endAt = DateTime(1919, 1, 1);

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final leftPane = ref.watch(leftPaneNotifierProvider);
    final rightPane = ref.watch(rightPaneProvider);
    final int totalDays = endAt.difference(startAt).inDays;
    final double paddingWithoutPane = 20;

    double leftPadding = leftPane.enabled ? 312 : paddingWithoutPane;
    double width =
        context.width - rightPane.width - leftPadding - paddingWithoutPane;

    return Container(
      margin: EdgeInsets.only(
        left: leftPadding,
        top: 10,
        right: paddingWithoutPane,
        bottom: 10,
      ),
      padding: EdgeInsets.only(top: 10),
      width: width,
      height: 113,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        // boxShadow: [BoxShadow(blurRadius: 20, offset: Offset(3, 3))],
      ),
      child: Column(
        children: [
          FlutterSlider(
            values: [selectedDate.date.difference(startAt).inDays.toDouble()],
            min: 0,
            max: totalDays.toDouble(),
            onDragCompleted: (_, handlerIndex, __) {
              final index = (handlerIndex as double).toInt();
              final selectedDate = startAt.add(Duration(days: index));

              ref
                  .read(selectedDateProvider.notifier)
                  .update(DateInterval.today(day: selectedDate));
            },
            tooltip: FlutterSliderTooltip(
              // custom: (value) {
              //   final index = (value as double).toInt();
              //   final selectedDate = startAt.add(Duration(days: index));
              //   return _SelectedDateLabel(date: selectedDate);
              // },
              textStyle: TextStyle(fontSize: 30),
              format: (value) {
                final index = double.parse(value).toInt();
                final selectedDate = startAt.add(Duration(days: index));
                final formatter = DateFormat("d MMMM y");

                return formatter.format(selectedDate);
              },
              alwaysShowTooltip: true,
            ),
            handlerAnimation: FlutterSliderHandlerAnimation(scale: 1),
          ),
          _SliderYearsLabel(),
        ],
      ),
    );
  }
}

// class _SelectedDateLabel extends StatelessWidget {
//   const _SelectedDateLabel({super.key, required this.date});
//   final DateTime date;

//   @override
//   Widget build(BuildContext context) {
//     final formatter = DateFormat("d MMMM y");

//     return Container(
//       width: 100,
//       height: 30,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(2)),
//         // boxShadow: [BoxShadow(blurRadius: 20, offset: Offset(3, 3))],
//       ),
//       child: Text(formatter.format(date), style: TextStyle(fontSize: 16)),
//     );
//   }
// }

class _SliderYearsLabel extends StatelessWidget {
  const _SliderYearsLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(
          5,
          (index) => Text(
            (index + 1914).toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
