class Order {
  final double price;
  final int volRemaining;
  final int stationID;
  final bool isBuy;

  Order(this.price, this.volRemaining, this.stationID, this.isBuy);

  @override
  String toString() {
    return {'price': price, 'volRemaining': volRemaining, 'stationID': stationID, 'isBuy': isBuy}.toString();
  }
}
