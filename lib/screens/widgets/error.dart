import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ErrorTextWidget extends StatelessWidget with PreferredSizeWidget {
  ErrorTextWidget(this.errorText);
  final errorText;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      style: AdaptiveTheme.of(context).theme.textTheme.titleMedium?.copyWith(color: AdaptiveTheme.of(context).theme.errorColor),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}