class Order {
  final double price;
  final int volRemaining;
  final int typeID;
  final int stationID;
  final int regionID;
  final bool isBuy;

  Order(this.price, this.volRemaining, this.typeID, this.stationID, this.regionID, this.isBuy);
}
