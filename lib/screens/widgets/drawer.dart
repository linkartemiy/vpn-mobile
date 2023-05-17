import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget with PreferredSizeWidget {
  DrawerWidget(this.login, this.toggleTheme, this.navigateToSubscriptionPage, {Key? key}) : super(key: key);
  final login;
  final toggleTheme;
  final navigateToSubscriptionPage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
      AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).theme.drawerTheme.backgroundColor,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      login,
                      style: AdaptiveTheme.of(context)
                          .theme
                          .textTheme
                          .headline5
                          ?.copyWith(
                          color: AdaptiveTheme.of(context)
                              .theme
                              .appBarTheme
                              .color),
                    ),
                    IconButton(
                        onPressed: toggleTheme,
                        icon: Icon(
                            color: AdaptiveTheme.of(context)
                                .theme
                                .primaryIconTheme
                                .color,
                            AdaptiveTheme.of(context).theme ==
                                AdaptiveTheme.of(context).lightTheme
                                ? Icons.color_lens
                                : Icons.color_lens_outlined))
                  ],
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Subscriptions',
              style: AdaptiveTheme.of(context).theme.textTheme.bodyText1,
            ),
            onTap: navigateToSubscriptionPage,
          ),
          ListTile(
            title: Text('Settings',
                style:
                AdaptiveTheme.of(context).theme.textTheme.bodyText1),
            onTap: () {
              Navigator.of(context).pushNamed('settings');
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}