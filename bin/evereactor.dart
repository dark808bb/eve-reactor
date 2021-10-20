import 'package:evereactor/eve_sde.dart';
import 'package:evereactor/market.dart';
import 'package:evereactor/load_sql_lib.dart' as evereactor;
import 'package:evereactor/composite_reaction_items_and_bps.dart';

import 'package:sqlite3/sqlite3.dart';
import 'package:colorize/colorize.dart';

void main() {
  evereactor.loadSqlLib();

  final sde = EveSDE(sqlite3.open('C:/Users/gazin/downloads/sqlite-latest.sqlite'));

  final bpsAndItems = CompositeReactionItemsAndBPs(sde);
  final blueprints = bpsAndItems.getBlueprints();
  final items = bpsAndItems.getItems();

  List<int> typeIDsOfInterest = [];
  for (var item in items.keys) {
    typeIDsOfInterest.add(item);
  }

  final market = Market.fromMarketLogs(typeIDsOfInterest);

  sde.dispose();
}
