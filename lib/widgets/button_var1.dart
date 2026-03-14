//button_var1.dart defines a custom button widget that can be used throughout the app. It has two variants: filled and text. The filled variant is a button with a background color, while the text variant is a button without a background color. Both variants have the same properties: label and onPressed callback.
import 'package:flutter/material.dart';

enum ButtonVariant { filled, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // If this is null, button is disabled
  final ButtonVariant variant;

  const AppButton({super.key, required this.label, required this.onPressed})
    : variant = ButtonVariant.filled;

  // Named constructor for the Text version
  const AppButton.text({super.key, required this.label, required this.onPressed})
    : variant = ButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    // Logic to decide which Material button to return
    if (variant == ButtonVariant.text) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 84, 37, 33)),
        child: Text(label),
      );
    }

    return FilledButton(
      onPressed: onPressed,
      child: Text(label),
      style: FilledButton.styleFrom(backgroundColor: const Color.fromARGB(255, 84, 37, 33)),
    );
  }
}
