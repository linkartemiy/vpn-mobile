import 'dart:math';

import 'package:ViewPN/domain/data_providers/server_data_provider.dart';
import 'package:ViewPN/domain/entities/server.dart';
import 'package:dart_ping/dart_ping.dart';

class ServerService {
  final _serverDataProvider = ServerDataProvider();
  late Server _server;
  late Server _serverBest;
  late List<Server> _servers;
  Server get server => _server;
  Server get serverBest => _serverBest;
  List<Server> get servers => _servers;

  Future<void> initilalize() async {
    _servers = await _serverDataProvider.getServers();
    _servers = await pingServers(_servers);
    _serverBest = await findBestServer(_servers);
    _server = _serverBest;
    int? serverId = await _serverDataProvider.getServer();
    if (serverId != null) {
      try {
        Server savedServer =
            _servers.firstWhere((element) => element.id == serverId);
        _server = savedServer;
      } catch (e) {}
    }
  }

  Future<List<Server>> pingServers(List<Server> servers) async {
    int pingMin = 100000000000;
    Server serverFound = servers[0];
    List<Server> serversUpdated = servers;
    for (int i = 0; i < serversUpdated.length; i++) {
      bool available = false;
      final ping = Ping(serversUpdated[i].ip, count: 2, timeout: 5);
      ping.stream.listen((event) {
        int? time = event.summary?.time?.inMilliseconds;
        if (time != null) {
          serversUpdated[i].ping = time;
          serversUpdated[i].availability = true;
          if (time != 0) {
            available = true;
          }
          if (time < pingMin && time != 0) {
            pingMin = time;
            serverFound = serversUpdated[i];
          }
        } else {
          serversUpdated[i].ping = -1;
          serversUpdated[i].availability = false;
        }
      });
      if (available) {
        serversUpdated[i].availability = true;
      }
    }
    _servers = serversUpdated;
    return serversUpdated;
  }

  Future<Server> findBestServer(List<Server> servers) async {
    int pingMin = 100000000000;
    Server serverFound = servers[0];
    List<Server> serversUpdated = servers;
    for (int i = 0; i < serversUpdated.length; i++) {
      final ping = Ping(serversUpdated[i].ip, count: 2, timeout: 5);
      ping.stream.listen((event) {
        int? time = event.summary?.time?.inMilliseconds;
        if (time != null) {
          if (time < pingMin && time != 0) {
            pingMin = time;
            serverFound = serversUpdated[i];
            _serverBest = serverFound;
          }
        }
      });
    }
    _serverBest = serverFound;
    return serverFound;
  }

  Future<List<Server>> checkServers(List<Server> servers) async {
    List<Server> serversUpdated = [];
    for (int i = 0; i < servers.length; i++) {
      
    }
    _servers = serversUpdated;
    return serversUpdated;
  }

  Future<void> selectServer(int id) async {
    _server = servers.firstWhere((element) => element.id == id);
    _serverDataProvider.setServer(id);
  }

  Future<void> deleteServer() async {
    _serverDataProvider.deleteServer();
  }
}
