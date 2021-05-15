import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final ImageProvider image;
  final String message;

  const NoData({Key? key, required this.image, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(children: [Image(image: image), Text(message)]));
  }
}
