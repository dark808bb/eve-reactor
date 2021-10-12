import 'eve_sde.dart';

class Item {
  final int typeID;
  final String typeName;
  final double volume;
  final int iconID;

  Item(
    this.typeID,
    this.typeName,
    this.volume,
    this.iconID,
  );

  static from(int typeID, EveSDE _sde) {
    final query = _sde.types.select(['*'], 'typeID=$typeID').last;
    return Item(query['typeID'], query['typeName'], query['volume'], query['iconID']);
  }

  @override
  String toString() {
    return {'typeID': typeID, 'typeName': typeName, 'volume': volume, 'iconID': iconID}.toString();
  }
}
