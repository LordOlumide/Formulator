import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final FocusNode? focusNode;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final double? width;
  final double? height;
  final bool shrink;
  final Color? splashColor;
  final Color? highlightColor;
  final bool autofocus;

  const PrimaryButton({
    required this.onPressed,
    this.onLongPressed,
    this.width,
    this.focusNode,
    this.height,
    this.shrink = false,
    this.padding,
    this.borderRadius,
    this.borderSide,
    this.color,
    required this.child,
    super.key,
    this.margin,
    this.splashColor,
    this.highlightColor,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget button = RawMaterialButton(
      autofocus: autofocus,
      onLongPress: onLongPressed,
      focusNode: focusNode,
      onPressed: onPressed,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      fillColor: onPressed == null
          ? Colors.black.withOpacity(0.4)
          : color ?? Colors.blue,
      highlightColor: highlightColor,
      splashColor: splashColor,
      constraints: BoxConstraints(
        minWidth: shrink ? 0 : width ?? double.infinity,
        minHeight: shrink ? 0 : height ?? 48,
      ),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        side: borderSide ?? BorderSide.none,
      ),
      child: child,
    );
    return margin == null
        ? button
        : Padding(
            padding: margin!,
            child: button,
          );
  }
}
