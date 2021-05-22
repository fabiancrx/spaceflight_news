import 'package:flutter/material.dart';
import 'package:spaceflight_news/src/common/theme.dart';

/// A widget that displays an icon and text to communicate to the user a message
/// If the [isLoading] boolean is true a [LinearProgressIndicator] is shown.
/// This is useful for when you are awaiting a [Future] to complete
class NoData extends StatelessWidget {
  final ImageProvider image;
  final String text;
  final Widget? child;
  final bool isLoading;

  const NoData({
    Key? key,
    required this.image,
    required this.text,
    this.child,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final List<Widget> textWidget;
    if (child != null) {
      textWidget = [
        Text(
          text,
          style: TextStyles.caption2,
        ),
        child!
      ];
    } else {
      textWidget = [
        Text(
          text,
          style: TextStyles.caption2,
        )
      ];
    }

    return Stack(
      fit: StackFit.expand,
      key: Key('no_data'),
      children: [
        if (isLoading)
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor.withOpacity(.33),
              ),
            ),
          ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: image,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            ...textWidget
          ],
        ),
      ],
    );
  }
}
