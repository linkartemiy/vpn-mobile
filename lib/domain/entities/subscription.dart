class Subscription {
  int id;
  String name;
  int price;
  int amount;
  String measure;

  Subscription(this.id, this.name, this.price, this.amount, this.measure);

  Subscription.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        amount = json['amount'],
        measure = json['measure'];

  Map toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'amount': amount,
    'measure': measure,
  };

  static Subscription subscriptionDefault = Subscription(0, 'default', 2, 0, 'month');
}