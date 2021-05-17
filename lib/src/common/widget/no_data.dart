import 'package:flutter/material.dart';
import 'package:spaceflight_news/src/common/theme.dart';

class NoData extends StatelessWidget {
  final ImageProvider image;
  final String text;
  final Widget? child;

  const NoData({Key? key, required this.image, required this.text, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Widget textWidget;
    if (child != null) {
      textWidget = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyles.caption2,
          ),
          child!
        ],
      );
    } else {
      textWidget = Text(
        text,
        style: TextStyles.caption2,
      );
    }

    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(
          image: image,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: textWidget,
        )
      ],
    ));
  }
}
