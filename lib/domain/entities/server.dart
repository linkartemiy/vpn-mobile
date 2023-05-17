class Server {
  int id;
  String country;
  String city;
  String code;
  String ip;
  int port;
  int ping;
  String config;
  bool availability;

  Server(
      {required this.id,
      required this.country,
      required this.city,
      required this.code,
      required this.ip,
      required this.port,
      required this.ping,
      required this.config,
      required this.availability});

  factory Server.fromJson(Map<dynamic, dynamic> json) {
    return Server(
      id: json['id'],
      country: json['country'],
      city: json['city'],
      code: json['code'],
      ip: json['ip'],
      port: json['port'],
      ping: -1,
      config: json['config'],
      availability: true,
    );
  }
}
