import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final ImageProvider image;
  final String message;

  const NoData({Key? key, required this.image, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [Image(image: image,fit: BoxFit.cover,), Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(message),
      )],
    ));
  }
}
