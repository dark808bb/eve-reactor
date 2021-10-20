import 'dart:io';
import 'market_order.dart';

class Market {
  int _typeID = -1;
  int _regionID = -1;

  final List<Order> buys = [];
  final List<Order> sells = [];

  Market(File marketFile) {
    var lines = marketFile.readAsLinesSync();
    // discard header
    lines = lines.sublist(1);
    for (var line in lines) {
      final cols = line.substring(0, line.length - 1).split(',');
      if (!exists()) {
        _typeID = int.parse(cols[2]);
        _regionID = int.parse(cols[11]);
      }

      final price = double.parse(cols[0]);
      final volumeRemaining = double.parse(cols[1]).toInt();
      final isBuy = cols[7] == 'True';
      final stationID = int.parse(cols[10]);
      final systemID = int.parse(cols[12]);
      final order = Order(price, volumeRemaining, stationID, systemID, isBuy);
      if (isBuy) {
        buys.add(order);
      } else {
        sells.add(order);
      }
    }
  }

  bool exists() {
    return _typeID != -1;
  }

  int getTypeID() {
    assert(exists());
    return _typeID;
  }

  int getRegionID() {
    assert(exists());
    return _regionID;
  }

  @override
  String toString() {
    return buys.toString() + '\n' + sells.toString();
  }
}
