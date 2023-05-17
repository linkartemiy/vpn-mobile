import 'dart:convert';

import 'package:ViewPN/domain/entities/server.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServerDataProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<List<Server>> getServers() async {
    final response = await http
        .post(Uri.parse('http://5.252.22.128:3000/api/servers'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Server> servers = <Server>[];
      for (int i = 0; i < data.length; i++) {
        Server server = Server(id: data[i]['id'], country: data[i]['country'], city: data[i]['city'], code: data[i]['code'], ip: data[i]['ip'], port: data[i]['port'], ping: data[i]['ping'], availability: data[i]['availability'], config: data[i]['config']);
        servers.add(server);
      }
      return servers;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    return [];
  }

  Future<int?> getServer() async {
    return (await _sharedPreferences).getInt('serverId');
  }

  Future<void> setServer(int id) async {
    (await _sharedPreferences).setInt('serverId', id);
  }

  Future<void> deleteServer() async {
    (await _sharedPreferences).remove('serverId');
  }
}
