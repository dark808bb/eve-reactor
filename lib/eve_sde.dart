import 'package:sqlite3/sqlite3.dart';

import 'package:evereactor/tables/industry_activity_materials_table.dart';
import 'package:evereactor/tables/industry_activity_products_table.dart';
import 'package:evereactor/tables/industry_activity_table.dart';
import 'package:evereactor/tables/inv_types_table.dart';

class EveSDE {
  final Database db;

  final InvTypesTable typesTb;
  final IndustryActivityProductsTable bpProductTb;
  final IndustryActivityMaterialsTable bpMaterialsTb;
  final IndustryActivityTable bpTimeTb;

  EveSDE(this.db)
      : typesTb = InvTypesTable(db),
        bpProductTb = IndustryActivityProductsTable(db),
        bpMaterialsTb = IndustryActivityMaterialsTable(db),
        bpTimeTb = IndustryActivityTable(db);

  void setupForTesting() {
    typesTb.create();
    bpProductTb.create();
    bpMaterialsTb.create();
    bpTimeTb.create();
  }

  void dispose() {
    db.dispose();
  }
}
