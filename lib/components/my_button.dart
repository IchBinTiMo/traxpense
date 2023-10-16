import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function()? onTap;

  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (isPressed) {
          widget.onTap!();
        }
        setState(() {
          isPressed = false;
        });
      },
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: SizedBox(
        height: 50,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 0,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: isPressed
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
