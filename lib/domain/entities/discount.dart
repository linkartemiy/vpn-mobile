class Discount {
  int id;
  String name;
  String code;
  int percent;
  bool active;

  Discount(this.id, this.name, this.code, this.percent, this.active);

  Discount.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        code = json['code'],
        percent = json['percent'],
        active = json['active'] == 1 ? true : false;

  Map toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'percent': percent,
    'active': active,
  };

  static Discount discountDefault = Discount(-1, '', '', -1, false);
}