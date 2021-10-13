import 'package:evereactor/tables/industry_blueprints_table.dart';
import 'package:sqlite3/sqlite3.dart';

import 'package:evereactor/tables/industry_activity_materials_table.dart';
import 'package:evereactor/tables/industry_activity_products_table.dart';
import 'package:evereactor/tables/industry_activity_table.dart';
import 'package:evereactor/tables/inv_types_table.dart';

class EveSDE {
  final Database db;

  final InvTypesTable types;
  final IndustryActivityProductsTable bpProduct;
  final IndustryActivityMaterialsTable bpMaterials;
  final IndustryActivityTable bpTime;
  final IndustryBlueprintMaxRunTable bpMaxRuns;

  EveSDE(this.db)
      : types = InvTypesTable(db),
        bpProduct = IndustryActivityProductsTable(db),
        bpMaterials = IndustryActivityMaterialsTable(db),
        bpTime = IndustryActivityTable(db),
        bpMaxRuns = IndustryBlueprintMaxRunTable(db);

  void setupForTesting() {
    types.create();
    bpProduct.create();
    bpMaterials.create();
    bpTime.create();
  }

  void dispose() {
    db.dispose();
  }
}
