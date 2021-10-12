import 'dart:io';

import 'package:evereactor/market.dart';

class Markets {
  // A map from typeID -> (regionID -> Market)
  Map<int, Map<int, Market>> markets = {};

  Markets() {
    Map<String, List<dynamic>> mostUpToDateMarketFiles = {};
    final directory = Directory('C:/Users/gazin/Documents/EVE/logs/Marketlogs');
    for (var fileSystemEntity in directory.listSync()) {
      if (fileSystemEntity is File) {
        final filename = fileSystemEntity.uri.pathSegments.last;
        final nameComponents = filename.substring(0, filename.length - 4).split('-');
        final region = nameComponents[0];
        final item = nameComponents[1];
        final key = region + item;
        final date = fileSystemEntity.lastModifiedSync();
        if (mostUpToDateMarketFiles.containsKey(key)) {
          var dateOfExistingFile = mostUpToDateMarketFiles[key]?.first;
          if (date.isAfter(dateOfExistingFile)) {
            mostUpToDateMarketFiles[key] = [date, fileSystemEntity];
          }
        } else {
          mostUpToDateMarketFiles[key] = [date, fileSystemEntity];
        }
      }
    }

    for (var dateAndFile in mostUpToDateMarketFiles.values) {
      final file = dateAndFile[1];
      final market = Market(file);
      if (market.exists()) {
        final typeID = market.getTypeID();
        final regionID = market.getRegionID();
        if (!markets.containsKey(typeID)) {
          markets[typeID] = {};
        }
        markets[typeID]![regionID] = market;
      }
    }
  }
}
