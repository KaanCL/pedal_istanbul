import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {

  final VoidCallback onPressed;
  final Image image;

  const MenuButton({super.key, required this.onPressed, required this.image});


  @override
  Widget build(BuildContext context) {
    return  Opacity(
        opacity: 0.7,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: onPressed,
          child: SizedBox(
            width: 26,height: 26,
            child: image,
          ),
        ),
    );
  }
}
