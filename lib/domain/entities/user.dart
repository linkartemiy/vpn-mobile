class User {
  int id;
  String login;
  String password;
  int subscriptionId;
  DateTime expirationDate;
  bool activated;
  String email;
  int discountId;
  bool trialAvailable;
  DateTime trialExpirationDate;
  String token;
  DateTime registrationDate;
  String lastLoginIP;

  User(this.id, this.login, this.password, this.subscriptionId, this.expirationDate, this.activated, this.email, this.discountId, this.trialAvailable, this.trialExpirationDate, this.token, this.registrationDate, this.lastLoginIP);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        login = json['login'],
        password = json['password'],
        subscriptionId = json['subscription_id'],
        expirationDate = DateTime.parse(json['expiration_date']),
        activated = json['activated'] == 1 ? true : false,
        email = json['email'],
        discountId = json['discount_id'],
        trialAvailable = json['trial_available'] == 1 ? true : false,
        trialExpirationDate = DateTime.parse(json['trial_expiration_date']),
        token = json['token'],
        registrationDate = DateTime.parse(json['registration_date']),
        lastLoginIP = json['last_login_ip'];

  Map toJson() => {
    'id': id,
    'login': login,
    'password': password,
    'subscription_id': subscriptionId,
    'expiration_date': expirationDate,
    'activated': activated,
    'email': email,
    'discount_id': discountId,
    'trial_available': trialAvailable,
    'trial_expiration_date': trialExpirationDate,
    'token': token,
    'registration_date': registrationDate,
    'last_login_ip': lastLoginIP,
  };

  static User userDefault = User(-1, 'Unknown user', '', -1, DateTime.now(), false, '', -1, false, DateTime.now(), '',
      DateTime.now(), '');
}