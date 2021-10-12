import 'package:evereactor/eve_sde.dart';
import 'constants.dart';
import 'blueprint.dart';
import 'item.dart';

class CompositeReactionItemsAndBPs {
  final EveSDE _sde;

  bool _isInitialized = false;

  final Map<int, Item> _id2item = {};
  final Map<int, Blueprint> _id2blueprint = {};

  CompositeReactionItemsAndBPs(this._sde);

  List<int> _getAdvancedMoonMaterialsTypeIDs() {
    final query = _sde.typesTb.select(['typeID'], 'marketGroupID=$ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID');
    return query.map((e) => e['typeID'] as int).toList();
  }

  void _initialize() {
    final ids = _getAdvancedMoonMaterialsTypeIDs();
    for (var id in ids) {
      _cacheItemAndBP(id);
    }
  }

  Map<int, Item> getItems() {
    if (!_isInitialized) {
      _initialize();
      _isInitialized = true;
    }
    return _id2item;
  }

  Map<int, Blueprint> getBlueprints() {
    if (!_isInitialized) {
      _initialize();
      _isInitialized = true;
    }
    return _id2blueprint;
  }

  void _cacheItemAndBP(int typeID) {
    if (_id2item.containsKey(typeID) || _id2blueprint.containsKey(typeID)) {
      return;
    }
    _id2item[typeID] = Item.from(typeID, _sde);
    if (!isItemBuildable(typeID) || isItemFuelBlock(typeID)) {
      return;
    }
    final blueprint = Blueprint.from(typeID, _sde);
    _id2blueprint[typeID] = blueprint;
    for (var inputTypeID in blueprint.inputTypeIDs) {
      _cacheItemAndBP(inputTypeID);
    }
  }

  bool isItemBuildable(int typeID) {
    return _sde.bpProductTb.select(['*'], 'productTypeID=$typeID').isNotEmpty;
  }

  bool isItemFuelBlock(int typeID) {
    return _sde.typesTb.select(['marketGroupID'], 'typeID=$typeID').last['marketGroupID'] == FUEL_BLOCK_MARKET_GROUP_ID;
  }
}
