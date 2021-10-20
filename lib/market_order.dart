class Order {
  final double price;
  final int volRemaining;
  final int stationID;
  final int systemID;
  final bool isBuy;

  Order(this.price, this.volRemaining, this.stationID, this.systemID, this.isBuy);

  @override
  String toString() {
    return {'price': price, 'volRemaining': volRemaining, 'stationID': stationID, 'systemID': systemID, 'isBuy': isBuy}.toString();
  }
}
