import 'package:sqlite3/sqlite3.dart';
import 'package:evereactor/tables/table.dart';

import 'table.dart';

class IndustryActivityProductsTable extends Table {
  @override
  IndustryActivityProductsTable(Database db) : super(db);

  @override
  String getTableName() {
    return 'industryActivityProducts';
  }

  @override
  List<String> getColumnNames() {
    return ['typeID', 'productTypeID', 'quantity'];
  }

  @override
  List<String> getTypeNames() {
    return ['INTEGER', 'INTEGER', 'INTEGER'];
  }

  void insert(int typeID, int productTypeID, int quantity) {
    db.execute(getInsertStatement([typeID, productTypeID, quantity]));
  }
}
