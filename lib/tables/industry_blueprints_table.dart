import 'package:sqlite3/sqlite3.dart';
import 'package:evereactor/tables/table.dart';

import 'table.dart';

class IndustryBlueprintMaxRunTable extends Table {
  @override
  IndustryBlueprintMaxRunTable(Database db) : super(db);

  @override
  String getTableName() {
    return 'industryBlueprints';
  }

  @override
  List<String> getColumnNames() {
    return ['typeID', 'maxProductionLimit'];
  }

  @override
  List<String> getTypeNames() {
    return ['INTEGER', 'INTEGER'];
  }

  void insert(int typeID, int maxProductionLimit) {
    db.execute(getInsertStatement([typeID, maxProductionLimit]));
  }
}
