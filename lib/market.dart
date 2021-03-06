import 'dart:io';

import 'market_order.dart';
import 'order_filter.dart';

class Market {
  // A map from typeIDs to orders
  final Map<int, List<Order>> _market = {};

  OrderFilter _filter = OrderFilter();
  Map<int, List<Order>> _filteredMarket = {};

  Market.fromMarketLogs(List<int> restrictToTypeIDs) {
    Map<String, List<dynamic>> mostUpToDateMarketLog = {};
    final directory = Directory('C:/Users/gazin/Documents/EVE/logs/Marketlogs');
    for (var fileSystemEntity in directory.listSync()) {
      if (fileSystemEntity is File) {
        final filename = fileSystemEntity.uri.pathSegments.last;
        final filenameNoExtension = filename.substring(0, filename.length - 4);
        final nameComponents = filenameNoExtension.split('-');
        final region = nameComponents[0];
        final item = nameComponents[1];
        final key = region + item;
        final date = fileSystemEntity.lastModifiedSync();
        if (mostUpToDateMarketLog.containsKey(key)) {
          var dateOfExistingFile = mostUpToDateMarketLog[key]?.first;
          if (date.isAfter(dateOfExistingFile)) {
            mostUpToDateMarketLog[key] = [date, fileSystemEntity];
          }
        } else {
          mostUpToDateMarketLog[key] = [date, fileSystemEntity];
        }
      }
    }

    for (var dateAndFile in mostUpToDateMarketLog.values) {
      var lines = dateAndFile[1].readAsLinesSync();
      // discard header which is always the first line
      lines = lines.sublist(1);

      // What typeID and regionID does this file contain orders for
      int _typeID = -1;
      int _regionID = -1;

      for (var line in lines) {
        final cols = line.substring(0, line.length - 1).split(',');
        if (_typeID == -1) {
          _typeID = int.parse(cols[2]);
          _regionID = int.parse(cols[11]);
          // We do not care about types that are not in restrictToTypeIDs
          if (!restrictToTypeIDs.contains(_typeID)) {
            break;
          }
          if (!_market.containsKey(_typeID)) {
            _market[_typeID] = [];
          }
        }

        // TODO handle parsing errors
        final price = double.parse(cols[0]);
        final volumeRemaining = double.parse(cols[1]).toInt();
        final isBuy = cols[7] == 'True';
        final systemID = int.parse(cols[12]);
        final order = Order(_typeID, systemID, _regionID, isBuy, price, volumeRemaining);
        _market[_typeID]!.add(order);
      }
    }

    // Make sure that _market does not contain any null values
    for (var typeID in restrictToTypeIDs) {
      if (!_market.containsKey(typeID)) {
        // TODO show warning that no orders were found for typeID in market logs
        _market[typeID] = [];
      }
    }

    _filterMarket();
  }

  void _filterMarket() {
    _filteredMarket = {};
    for (var id in _market.keys) {
      _filteredMarket[id] = _market[id]!.where((order) => _filter.filter(order)).toList();
    }
  }

  void setMarketFilter(filter) {
    _filter = filter;
    _filterMarket();
  }
}
