import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';

class PlaceHolderNetworkImage extends StatelessWidget {
  final String src;
  final String? semanticLabel;
  final BoxFit? fit;
  final double? height;
  final double? width;

  const PlaceHolderNetworkImage(
    this.src, {
    Key? key,
    this.semanticLabel,
    this.fit,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      semanticLabel: semanticLabel,
      fit: fit,
      height: height,
      width: width,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        if (frame == 0) {
          return Placeholder();
        }
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      },
    );
  }
}

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    required this.closedBuilder,
    required this.openedWidget,
    this.transitionType = ContainerTransitionType.fade,
  });

  final Widget openedWidget;
  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return openedWidget;
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
