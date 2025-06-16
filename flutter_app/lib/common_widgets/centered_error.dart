import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:ww1_map/common_widgets/centered_message.dart';

class CenteredError extends StatelessWidget {
  const CenteredError({super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredMessage(message: context.tr("AnErrorOccured"));
  }
}
