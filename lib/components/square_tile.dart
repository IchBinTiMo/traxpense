import 'package:flutter/material.dart';

class SquareTile extends StatefulWidget {
  final String imagePath;
  final String pressedImage;
  final String text;
  final Function()? onTap;
  const SquareTile({
    super.key,
    required this.imagePath,
    required this.pressedImage,
    required this.text,
    required this.onTap,
  });

  @override
  State<SquareTile> createState() => _SquareTileState();
}

class _SquareTileState extends State<SquareTile> {
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      isPressed ? widget.pressedImage : widget.imagePath,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
