import 'package:evereactor/eve_sde.dart';

import 'constants.dart';

class Blueprint {
  final int typeID;
  final String typeName;
  final int productTypeID;
  final int iconID;
  final List<int> inputTypeIDs;
  final List<int> inputQuantities;
  final int timeInSeconds;

  Blueprint(
    this.typeID,
    this.typeName,
    this.productTypeID,
    this.iconID,
    this.inputTypeIDs,
    this.inputQuantities,
    this.timeInSeconds,
  );

  static int _getBlueprintTypeID(int typeID, EveSDE sde) {
    final query = sde.bpProductTb.select(['typeID'], 'productTypeID=$typeID and typeID<>$TEST_REACTION_BP_TYPE_ID');
    return query.last['typeID'];
  }

  static Blueprint from(int productTypeID, EveSDE sde) {
    final blueprintID = _getBlueprintTypeID(productTypeID, sde);
    final time = sde.bpTimeTb.select(['time'], 'typeID=$blueprintID').last;
    final type = sde.typesTb.select(['typeName', 'iconID'], 'typeID=$blueprintID').last;
    final mats = sde.bpMaterialsTb.select(['materialTypeID', 'quantity'], 'typeID=$blueprintID');
    final inputTypeIDs = mats.map((e) => e['materialTypeID'] as int).toList();
    final inputQuantities = mats.map((e) => e['quantity'] as int).toList();
    return Blueprint(blueprintID, type['typeName'], productTypeID, type['iconID'], inputTypeIDs, inputQuantities, time['time']);
  }

  @override
  String toString() {
    return {
      'typeID': typeID,
      'typeName': typeName,
      'productTypeID': productTypeID,
      'iconID': iconID,
      'inputTypeIDs': inputTypeIDs,
      'inputQuantities': inputQuantities,
      'timeInSeconds': timeInSeconds
    }.toString();
  }
}
