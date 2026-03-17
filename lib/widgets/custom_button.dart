import 'package:flutter/material.dart';
import '../config/themes.dart';

enum CustomButtonStyle { primary, secondary, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonStyle style;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final Color? backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = CustomButtonStyle.primary,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: style == CustomButtonStyle.outlined ? AppTheme.primaryRed : Colors.white,
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(text),
        ],
      ],
    );

    switch (style) {
      case CustomButtonStyle.outlined:
        return _buildSizedButton(
          OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: content,
          ),
        );
      case CustomButtonStyle.secondary:
        return _buildSizedButton(
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: isLoading ? null : onPressed,
            child: content,
          ),
        );
      case CustomButtonStyle.primary:
        return _buildSizedButton(
          ElevatedButton(
            style: backgroundColor != null 
              ? ElevatedButton.styleFrom(backgroundColor: backgroundColor)
              : null,
            onPressed: isLoading ? null : onPressed,
            child: content,
          ),
        );
    }
  }

  Widget _buildSizedButton(Widget child) {
    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: child);
    }
    return child;
  }
}
