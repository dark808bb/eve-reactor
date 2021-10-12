import 'package:sqlite3/sqlite3.dart';
import 'package:evereactor/tables/table.dart';

import 'table.dart';

class IndustryActivityMaterialsTable extends Table {
  @override
  IndustryActivityMaterialsTable(Database db) : super(db);

  @override
  String getTableName() {
    return 'industryActivityMaterials';
  }

  @override
  List<String> getColumnNames() {
    return ['typeID', 'materialTypeID', 'quantity'];
  }

  @override
  List<String> getTypeNames() {
    return ['INTEGER', 'INTEGER', 'INTEGER'];
  }

  void insert(int typeID, int materialTypeID, int quantity) {
    db.execute(getInsertStatement(['typeID', 'materialTypeID', 'quantity'], [typeID, materialTypeID, quantity]));
  }
}
