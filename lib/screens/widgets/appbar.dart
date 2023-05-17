import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  AppBarWidget({Key? key, this.navigate, this.title, this.textButton}) : super(key: key);
  final navigate;
  final title;
  final textButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: navigate,
          icon: Icon(Icons.arrow_back, color: AdaptiveTheme.of(context).theme.appBarTheme.iconTheme?.color,)),
      title: Text(
        title,
        style: AdaptiveTheme.of(context).theme.textTheme.titleMedium?.copyWith(color: AdaptiveTheme.of(context).theme.appBarTheme.titleTextStyle?.color),
      ),
      actions: [textButton != null ? textButton : Container()],
      backgroundColor: AdaptiveTheme.of(context).theme.backgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}