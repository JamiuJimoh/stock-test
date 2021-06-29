import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final Color? borderColor;
  final double? height;
  final double? width;
  final Color? containerColor;
  final double? borderRadius;
  final DecorationImage? image;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final List<BoxShadow>? boxShadow;

  CustomContainer({
    required this.child,
     this.borderColor,
    this.image,
    this.containerColor,
    this.padding,
    this.height: 100.0,
    this.width: 100.0,
    this.borderRadius: 20.0,
    this.boxShadow,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: height,
        width: width,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
            image: image,
            color: containerColor,
            border:borderColor==null? null: Border(
              top: BorderSide(color: borderColor!),
              bottom: BorderSide(color: borderColor!),
              left: BorderSide(color: borderColor!),
              right: BorderSide(color: borderColor!),
            ),
            boxShadow: boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}
