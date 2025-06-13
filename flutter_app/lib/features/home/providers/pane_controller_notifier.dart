import 'package:collection/collection.dart';
import 'package:flutter_resizable_container/flutter_resizable_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ww1_map/shared/domain/enums/pane_position.dart';

final paneNotifierProvider = NotifierProvider(PaneNotifier.new);

class PaneNotifier extends Notifier<ResizableController> {
  @override
  build() {
    final controller = ResizableController();
    controller.addListener(() {
      print(controller.sizes);
    });

    // controller.setSizes(const [
    //   ResizableSize.pixels(250),
    //   ResizableSize.expand(),
    //   ResizableSize.ratio(0.25),
    // ]);
    return controller;
  }

  List<double> get getPanesSizes => state.sizes.toList();
  double get totalPanesSize => getPanesSizes.sum;

  double get leftPaneSize => getPanesSizes.first;
  double get middlePaneSize => getPanesSizes[1];
  double get rightPaneSize => getPanesSizes.last;

  void changePaneSize({required PanePosition pane, required double size}) {
    double middlePaneNewSize = 0;
    List<double> newSizes = [];

    if (pane == PanePosition.middle) return;
    if (pane == PanePosition.right) {
      middlePaneNewSize = totalPanesSize - leftPaneSize - size;
      newSizes = [leftPaneSize, middlePaneNewSize, size];
    } else {
      middlePaneNewSize = totalPanesSize - rightPaneSize - size;
      newSizes = [size, middlePaneNewSize, rightPaneSize];
    }

    final resizableSize = newSizes.map((size) => ResizableSize.pixels(size));
    state.setSizes(resizableSize.toList());
  }
}
