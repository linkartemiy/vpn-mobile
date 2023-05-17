
import 'package:ViewPN/screens/login_page.dart';
import 'package:ViewPN/screens/loader_page.dart';
import 'package:ViewPN/screens/register_page.dart';
import 'package:ViewPN/screens/servers_page.dart';
import 'package:ViewPN/screens/settings_page.dart';
import 'package:ViewPN/screens/subscription_page.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import 'package:ViewPN/utils/custom_theme.dart';
import 'package:ViewPN/screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: customLightTheme,
        dark: customDarkTheme,
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
              title: 'ViewPN',
              debugShowCheckedModeBanner: false,
              theme: theme,
              darkTheme: darkTheme,
              home: LoaderPage.create(),
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == 'login') {
                  return PageRouteBuilder<dynamic>(
                    pageBuilder: (context, animation1, animation2) =>
                        LoginPage.create(),
                    transitionDuration: Duration.zero,
                  );
                } else if (settings.name == 'home') {
                  return PageRouteBuilder<dynamic>(
                    pageBuilder: (context, animation1, animation2) =>
                        HomePage.create(settings.arguments as HomePageArguments),
                    transitionDuration: Duration.zero,
                  );
                } else if (settings.name == 'loader') {
                  return PageRouteBuilder<dynamic>(
                    pageBuilder: (context, animation1, animation2) =>
                        LoaderPage.create(),
                    transitionDuration: Duration.zero,
                  );
                } else if (settings.name == 'register') {
                  return PageRouteBuilder<dynamic>(
                    pageBuilder: (context, animation1, animation2) =>
                        RegisterPage.create(),
                    transitionDuration: Duration.zero,
                  );
                } else if (settings.name == 'subscription') {
                  return PageRouteBuilder<dynamic>(
                    pageBuilder: (context, animation1, animation2) =>
                        SubscriptionPage.create(settings.arguments as SubscriptionPageArguments),
                    transitionDuration: Duration.zero,
                  );
                } else if (settings.name == 'settings') {
                  return PageRouteBuilder<dynamic>(
                    pageBuilder: (context, animation1, animation2) =>
                        SettingsPage.create(),
                    transitionDuration: Duration.zero,
                  );
                } else if (settings.name == 'servers') {
                  return PageRouteBuilder<dynamic>(
                    pageBuilder: (context, animation1, animation2) =>
                        ServersPage.create(settings.arguments as ServersPageArguments),
                    transitionDuration: Duration.zero,
                  );
                }
              },
            ));
  }
}
