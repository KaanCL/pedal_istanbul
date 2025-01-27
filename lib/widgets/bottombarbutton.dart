import 'package:flutter/material.dart';

class BottomBarButton extends StatelessWidget {

  final Image img;

  const BottomBarButton({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      child: img
    );
  }
}
