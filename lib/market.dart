import 'dart:io';
import 'market_order.dart';

class Market {
  final int typeID;

  List<Order> buys = [];
  List<Order> sells = [];

  Market(this.typeID) {
    var dir = Directory('C:/Users/gazin/Documents/EVE/logs/Marketlogs');
    List<List<String>> xxx = [];
    for (var fse in dir.listSync()) {
      var v = File(fse.path);
      xxx.add(v.readAsLinesSync());
      print(xxx.last);
      print('\n');
      print('\n');
      print('\n');
    }
  }
}
