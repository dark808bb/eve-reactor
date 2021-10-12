import 'package:evereactor/eve_sde.dart';
import 'package:evereactor/market.dart';
import 'package:evereactor/load_sql_lib.dart' as evereactor;
import 'package:evereactor/composite_reaction_items_and_bps.dart';

import 'package:sqlite3/sqlite3.dart';

void main() {
  // Market m = Market();

  evereactor.loadSqlLib();

  final sde = EveSDE(sqlite3.open('C:/Users/gazin/downloads/sqlite-latest.sqlite'));

  var bpsAndItems = CompositeReactionItemsAndBPs(sde);
  var blueprints = bpsAndItems.getBlueprints();
  var items = bpsAndItems.getItems();

  for (var blueprint in blueprints.values) print(blueprint);
  for (var item in items.values) print(item);

  sde.dispose();
}
