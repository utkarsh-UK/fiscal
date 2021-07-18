import 'package:fiscal/core/core.dart';
import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const ScreenTitle({
    Key? key,
    required this.title,
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title.titleCase, style: FiscalTheme.screenTitleText, key: ValueKey('screen_title')),
          actions.isEmpty
              ? SizedBox.shrink()
              : Row(key: ValueKey('actions'), crossAxisAlignment: CrossAxisAlignment.center, children: actions),
        ],
      ),
    );
  }
}
