import 'package:ViewPN/domain/entities/server.dart';
import 'package:ViewPN/domain/services/auth_service.dart';
import 'package:ViewPN/domain/services/server_service.dart';
import 'package:ViewPN/domain/services/user_service.dart';
import 'package:ViewPN/screens/navigation/main_navigation.dart';
import 'package:ViewPN/screens/servers_page.dart';
import 'package:ViewPN/screens/subscription_page.dart';
import 'package:ViewPN/screens/widgets/drawer.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:country_icons/country_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:openvpn_flutter/openvpn_flutter.dart';

import 'package:provider/provider.dart';

import '../domain/entities/discount.dart';
import '../domain/entities/subscription.dart';
import '../domain/entities/user.dart';
import '../domain/services/discount_service.dart';
import '../domain/services/subscription_service.dart';
import 'loader_page.dart';

class HomePageArguments {
  User user;
  Subscription subscription;
  Discount discount;
  HomePageArguments(
      {required this.user, required this.subscription, required this.discount});
}

class _ViewModelState {
  Server? server;
  User? user;
  _ViewModelState({this.server, this.user});
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();
  final _serverService = ServerService();
  final _subscriptionService = SubscriptionService();
  final _discountService = DiscountService();

  Server server = Server(
      id: -1,
      country: 'Unknown',
      city: 'Unknown',
      code: 'jp',
      ip: '',
      port: -1,
      ping: -1,
      config: '1111',
      availability: false);
  User user = User.userDefault;
  Subscription subscription = Subscription.subscriptionDefault;
  Discount discount = Discount.discountDefault;
  bool loading = false;

  var _state = _ViewModelState();
  _ViewModelState get state => _state;

  void loadValue() async {
    await _userService.initilalize();
    user = _userService.user;

    subscription = await _subscriptionService.getById(user.subscriptionId);

    if (user.discountId != -1) {
      discount = await _discountService.get(user.discountId);
    }

    _updateState();
  }

  Future<void> loadServers() async {
    await _serverService.initilalize();
    server = _serverService.server;
    _updateState();
  }

  Future<void> loadSubscription() async {
    subscription = await _subscriptionService.getById(user.subscriptionId);
  }

  Future<void> loadDiscount() async {
    if (user.discountId != -1) {
      discount = await _discountService.get(user.discountId);
    }
  }

  Future<void> toggleLoader() async {
    loading = !loading;
    _updateState();
  }

  _ViewModel(HomePageArguments homePageArguments) {
    user = homePageArguments.user;
    subscription = homePageArguments.subscription;
    discount = homePageArguments.discount;
    loadServers();
    _updateState();
  }

  Future<void> onLogoutPressed(BuildContext context) async {
    await _authService.logout();
    await _serverService.deleteServer();
    MainNavigation.showLoader(context);
  }

  void _updateState() {
    _state = _ViewModelState(server: server, user: user);
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Widget create(HomePageArguments homePageArguments) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(homePageArguments),
      child: const HomePage(),
    );
  }

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late OpenVPN engine;
  late VpnStatus status = VpnStatus.empty();
  late VPNStage stage = VPNStage.disconnected;

  @override
  void initState() {
    for (int i = 1; i < 5; i++) {
      int time = 500 * i;
      Future.delayed(Duration(milliseconds: time), () {
        setState(() {});
      });
    }
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data!;
        });
      },
      onVpnStageChanged: (data, raw) {
        setState(() {
          stage = data;
        });
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "ViewPN",
      lastStage: (stage) {
        setState(() {
          this.stage = stage;
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );

    super.initState();
  }

  Future<void> initPlatformState(Server server) async {
    print(server.config);
    engine.connect(server.config, server.country,
        username: "link", password: "sticks18rus", certIsRequired: false);
    if (!mounted) return;
  }

  void connect(Server server) {
    if (stage == VPNStage.disconnected) {
      initPlatformState(server);
    } else {
      engine.disconnect();
    }
  }

  void toggleTheme(BuildContext context) {
    AdaptiveTheme.of(context).toggleThemeMode();
    setState(() {});
  }

  void navigateToServersPage(BuildContext context) async {
    final viewModel = context.read<_ViewModel>();
    viewModel.toggleLoader();
    await viewModel.loadServers();
    viewModel.toggleLoader();
    final args = await Navigator.of(context).pushNamed('servers',
        arguments: ServersPageArguments(
            user: viewModel.user,
            server: viewModel.server,
            servers: viewModel._serverService.servers,
            serverBest: viewModel._serverService.serverBest));
    await viewModel.loadServers();
    setState(() {});
  }

  void navigateToSubscriptionPage(BuildContext context) async {
    final viewModel = context.read<_ViewModel>();
    final args = await Navigator.of(context).pushNamed('subscription',
        arguments: SubscriptionPageArguments(
            user: viewModel.user,
            subscription: viewModel.subscription,
            discount: viewModel.discount)) as HomePageArguments;
    viewModel.user = args.user;
    viewModel.subscription = args.subscription;
    viewModel.discount = args.discount;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();

    return MaterialApp(
      title: 'ViewPN',
      debugShowCheckedModeBanner: false,
      home: viewModel.loading
          ? LoaderWidget()
          : Scaffold(
              drawer: DrawerWidget(viewModel.user.login, () {
                toggleTheme(context);
              }, () {
                navigateToSubscriptionPage(context);
              }),
              backgroundColor:
                  AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
              appBar: AppBar(
                iconTheme: IconThemeData(
                    color: AdaptiveTheme.of(context).theme.colorScheme.primary),
                backgroundColor:
                    AdaptiveTheme.of(context).theme.backgroundColor,
                elevation: 0,
                actions: [
                  TextButton(
                    onPressed: () => viewModel.onLogoutPressed(context),
                    child: Padding(
                      child: Text('Log out',
                          style: TextStyle(
                              color: AdaptiveTheme.of(context)
                                  .theme
                                  .colorScheme
                                  .primary)),
                      padding: EdgeInsets.only(left: 10, right: 10),
                    ),
                  ),
                ],
              ),
              body: Container(
                alignment: Alignment.center,
                child: viewModel.user.discountId == 1 ||
                        DateTime.now()
                                .compareTo(viewModel.user.expirationDate) ==
                            -1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ConnectButtonWidget(
                            stage: stage,
                            status: status,
                            connect: connect,
                          ),
                          _StatusWidget(stage: stage, status: status),
                          SizedBox(height: 40),
                          Container(
                            width: 300,
                            height: 60,
                            decoration: BoxDecoration(
                                color: AdaptiveTheme.of(context)
                                    .theme
                                    .colorScheme
                                    .primary,
                                borderRadius: BorderRadius.circular(20)),
                            child: ElevatedButton(
                                onPressed: () {
                                  navigateToServersPage(context);
                                },
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .elevatedButtonTheme
                                    .style,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            'https://countryflagsapi.com/png/' +
                                                viewModel.server.code),
                                      ),
                                    ),
                                    Container(
                                        width: 170,
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text(
                                          viewModel.server.country,
                                          style: AdaptiveTheme.of(context)
                                              .theme
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  color:
                                                      AdaptiveTheme.of(context)
                                                          .theme
                                                          .buttonTheme
                                                          .colorScheme
                                                          ?.secondary),
                                        ))
                                  ],
                                )),
                          )
                          // _PingWidget()
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text('Subscription is not paid',
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .textTheme
                                    .headlineSmall),
                            ElevatedButton(
                                onPressed: () {
                                  navigateToSubscriptionPage(context);
                                },
                                child: Text('Pay for a month'),
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .elevatedButtonTheme
                                    .style
                                    ?.copyWith(
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                Size(300, 40)))),
                            viewModel.user.trialAvailable
                                ? TextButton(
                                    onPressed: () {
                                      navigateToSubscriptionPage(context);
                                    },
                                    child: Text('Try for free'),
                                    style: AdaptiveTheme.of(context)
                                        .theme
                                        .textButtonTheme
                                        .style
                                        ?.copyWith(
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(300, 40))))
                                : Container()
                          ]),
              )),
    );
  }
}

class _ConnectButtonWidget extends StatelessWidget {
  const _ConnectButtonWidget(
      {Key? key,
      required this.stage,
      required this.status,
      required this.connect})
      : super(key: key);

  final stage, status, connect;
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return IconButton(
      onPressed: () {
        connect(model.server);
      },
      icon: Icon(
        Icons.wifi,
        color: stage != VPNStage.connected && stage != VPNStage.disconnected
            ? Colors.greenAccent
            : stage == VPNStage.connected
                ? Colors.greenAccent[700]
                : Colors.redAccent,
      ),
      iconSize: 200,
      color: AdaptiveTheme.of(context).theme.iconTheme.color,
      alignment: Alignment.center,
    );
  }
}

class _StatusWidget extends StatelessWidget {
  const _StatusWidget({Key? key, required this.stage, required this.status})
      : super(key: key);

  final stage, status;
  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    if (stage != VPNStage.connected && stage != VPNStage.disconnected) {
      return Text('Connecting',
          style: AdaptiveTheme.of(context)
              .theme
              .textTheme
              .headline5
              ?.copyWith(color: Colors.greenAccent));
    } else {
      return Text(stage == VPNStage.connected ? status.duration! : 'Idle',
          style: AdaptiveTheme.of(context).theme.textTheme.headline5?.copyWith(
              color: stage == VPNStage.connected
                  ? Colors.greenAccent[700]
                  : Colors.redAccent));
    }
  }
}

class _PingWidget extends StatelessWidget {
  const _PingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return Text('Ping: ' + model.server.ping.toString(),
        style: AdaptiveTheme.of(context).theme.textTheme.headline5?.copyWith(
            color: model.server.ping >= 90
                ? Colors.yellow[600]
                : model.server.ping >= 200
                    ? Colors.redAccent
                    : model.server.ping <= 90
                        ? Colors.greenAccent[700]
                        : Colors.redAccent));
  }
}
