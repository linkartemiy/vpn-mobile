import 'package:ViewPN/screens/widgets/appbar.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:ViewPN/utils/custom_theme.dart';

import 'package:ViewPN/domain/entities/server.dart';
import 'package:ViewPN/domain/services/auth_service.dart';
import 'package:ViewPN/domain/services/server_service.dart';
import 'package:ViewPN/domain/services/user_service.dart';
import 'package:ViewPN/screens/navigation/main_navigation.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:country_icons/country_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:openvpn_flutter/openvpn_flutter.dart';

import 'package:provider/provider.dart';

import '../domain/entities/user.dart';

class ServersPageArguments {
  List<Server> servers;
  Server serverBest;
  Server server;
  User user;
  ServersPageArguments(
      {required this.user,
      required this.server,
      required this.servers,
      required this.serverBest});
}

class _ViewModelState {
  List<Server>? servers;
  Server? serverBest;
  Server? server;
  User? user;
  _ViewModelState({this.servers, this.serverBest, this.server, this.user});
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();
  final _serverService = ServerService();

  List<Server> servers = <Server>[
    Server(
        id: -1,
        country: 'Unknown',
        city: 'Unknown',
        code: 'jp',
        ip: '',
        port: -1,
        ping: -1,
        config: '1111',
        availability: false)
  ];
  Server serverBest = Server(
      id: -1,
      country: 'Unknown',
      city: 'Unknown',
      code: 'jp',
      ip: '',
      port: -1,
      ping: -1,
      config: '1111',
      availability: false);
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

  var _state = _ViewModelState();
  _ViewModelState get state => _state;

  void loadValue() async {
    await _userService.initilalize();
    user = _userService.user;
    _updateState();
  }

  void loadServers() async {
    await _serverService.initilalize();
    servers = _serverService.servers;
    server = _serverService.server;
    serverBest = _serverService.serverBest;
    _updateState();
  }

  void selectServer(int id) async {
    if (id != server.id) {
      await _serverService.selectServer(id);
      server = _serverService.server;
      _updateState();
    }
  }

  _ViewModel(ServersPageArguments serversPageArguments) {
    user = serversPageArguments.user;
    server = serversPageArguments.server;
    servers = serversPageArguments.servers;
    serverBest = serversPageArguments.serverBest;
    user = User.userDefault;
    loadServers();
    loadValue();
    _updateState();
  }

  void _updateState() {
    _state = _ViewModelState(
        servers: servers, serverBest: serverBest, server: server, user: user);
    notifyListeners();
  }
}

class ServersPage extends StatefulWidget {
  const ServersPage({Key? key}) : super(key: key);

  static Widget create(ServersPageArguments serversPageArguments) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(serversPageArguments),
      child: const ServersPage(),
    );
  }

  @override
  _ServersPage createState() => _ServersPage();
}

class _ServersPage extends State<ServersPage> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });
    super.initState();
  }

  void selectServer() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {});
    });

    return Scaffold(
        backgroundColor: AdaptiveTheme.of(context).theme.backgroundColor,
        appBar: AppBarWidget(navigate: () {
          Navigator.of(context).pop(1);
        }, title: 'Servers'),
        body: ListView(children: <Widget>[
          Column(
            children: [
              SizedBox(height: 5),
              Text(
                'Best server',
                style: AdaptiveTheme.of(context).theme.textTheme.titleMedium,
              ),
              SizedBox(height: 5),
              ServerWidget(
                  server: viewModel.serverBest, selectServer: selectServer),
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.only(left: 32, right: 32),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey),
                    ),
                  )),
              SizedBox(height: 10),
              ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    for (int i = 0; i < viewModel.servers.length; i++)
                      if (viewModel.servers[i].id != viewModel.serverBest.id)
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: ServerWidget(
                                server: viewModel.servers[i],
                                selectServer: selectServer)),
                  ])
            ],
          ),
        ]));
  }
}

class ServerWidget extends StatelessWidget {
  const ServerWidget(
      {Key? key, required this.server, required this.selectServer})
      : super(key: key);

  final server, selectServer;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();
    if (server != null) {
      return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        height: 90,
        decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(17)),
        child: ElevatedButton(
            onPressed: () {
              selectServer();
              viewModel.selectServer(server.id);
            },
            style: AdaptiveTheme.of(context)
                .theme
                .elevatedButtonTheme
                .style
                ?.copyWith(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.0),
                ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    minRadius: 32,
                    maxRadius: 32,
                    backgroundImage: NetworkImage(
                        'https://countryflagsapi.com/png/' + server.code),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 170,
                        margin: EdgeInsets.only(right: 10),
                        child: Column(children: [
                          Text(
                            server.country,
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: AdaptiveTheme.of(context)
                                        .theme
                                        .cardColor),
                          ),
                          SizedBox(height: 5),
                          Text(
                            server.city,
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: AdaptiveTheme.of(context)
                                        .theme
                                        .colorScheme
                                        .secondary),
                          )
                        ])),
                  ],
                ),
                if (viewModel.server.id == server.id) Text('Selected')
              ],
            )),
      );
    } else {
      return Container();
    }
  }
}
