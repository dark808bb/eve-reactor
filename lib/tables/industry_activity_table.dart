import 'package:sqlite3/sqlite3.dart';
import 'package:evereactor/tables/table.dart';

import 'table.dart';

class IndustryActivityTable extends Table {
  @override
  IndustryActivityTable(Database db) : super(db);

  @override
  String getTableName() {
    return 'industryActivity';
  }

  @override
  List<String> getColumnNames() {
    return ['typeID', 'time'];
  }

  @override
  List<String> getTypeNames() {
    return ['INTEGER', 'INTEGER'];
  }

  void insert(int typeID, int time) {
    db.execute(getInsertStatement(['typeID', 'time'], [typeID, time]));
  }
}
