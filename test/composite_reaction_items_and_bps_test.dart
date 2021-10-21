import 'package:sqlite3/sqlite3.dart';

import 'package:evereactor/eve_sde.dart';
import 'package:evereactor/constants.dart';
import 'package:evereactor/composite_reaction_items_and_bps.dart';

import 'package:test/test.dart';

// TODO maybe I should use the real eve SDE database instead of an empty database?

void main() {
  test('An empty database results in empty EveStaticData fields', () {
    final sde = EveSDE(sqlite3.openInMemory(), isTesting: true);

    final eveSD = CompositeReactionItemsAndBPs(sde);
    final blueprints = eveSD.getBlueprints();
    final items = eveSD.getItems();

    expect(blueprints.length, 0);
    expect(items.length, 0);

    sde.dispose();
  });

  test('All items and blueprints are replicated in memory', () {
    final sde = EveSDE(sqlite3.openInMemory(), isTesting: true);

    sde.types.insert(1, 'test', .42, sde.constants.ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.types.insert(999, 'test bp', .01, 33, 10);
    sde.types.insert(770, 'titan', .01, 0, 10);
    sde.types.insert(771, 'mexall', .01, 0, 10);
    sde.types.insert(772, 'pyery', .01, 0, 10);

    sde.bpProduct.insert(999, 1, 42);
    sde.bpMaterials.insert(999, 770, 6);
    sde.bpMaterials.insert(999, 771, 6);
    sde.bpMaterials.insert(999, 772, 6);
    sde.bpTime.insert(999, 3600);

    final eveSD = CompositeReactionItemsAndBPs(sde);
    final blueprints = eveSD.getBlueprints();
    final items = eveSD.getItems();

    expect(blueprints.length, 1);
    expect(items.length, 4);

    sde.dispose();
  });

  test('Fuel blocks are not built', () {
    final sde = EveSDE(sqlite3.openInMemory(), isTesting: true);

    sde.types.insert(1, 'test', .42, sde.constants.ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.types.insert(999, 'test bp', .01, 33, 10);
    sde.types.insert(998, 'fuelblk bp', .01, 33, 10);
    sde.types.insert(770, 'fuel blc', 5, sde.constants.FUEL_BLOCK_MARKET_GROUP_ID, 10);
    sde.types.insert(771, 'mexall', .01, 0, 10);
    sde.types.insert(772, 'pyery', .01, 0, 10);

    sde.bpProduct.insert(999, 1, 42);
    sde.bpProduct.insert(998, 770, 42);
    sde.bpMaterials.insert(999, 770, 6);
    sde.bpMaterials.insert(999, 771, 6);
    sde.bpMaterials.insert(999, 772, 6);
    sde.bpMaterials.insert(998, 771, 6);
    sde.bpTime.insert(999, 3600);
    sde.bpTime.insert(998, 3600);

    final eveSD = CompositeReactionItemsAndBPs(sde);
    final blueprints = eveSD.getBlueprints();
    final items = eveSD.getItems();

    expect(blueprints.length, 1);
    expect(items.length, 4);

    sde.dispose();
  });

  test('Fuel blocks are built when wrong market group is used', () {
    final sde = EveSDE(sqlite3.openInMemory(), isTesting: true);

    sde.types.insert(1, 'test', .42, sde.constants.ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.types.insert(999, 'test bp', .01, 33, 10);
    sde.types.insert(998, 'fuelblk bp', .01, 33, 10);
    sde.types.insert(770, 'fuel blk', 5, 8, 10);
    sde.types.insert(771, 'mexall', .01, 0, 10);
    sde.types.insert(772, 'pyery', .01, 0, 10);

    sde.bpProduct.insert(999, 1, 42);
    sde.bpProduct.insert(998, 770, 42);
    sde.bpMaterials.insert(999, 770, 6);
    sde.bpMaterials.insert(999, 771, 6);
    sde.bpMaterials.insert(999, 772, 6);
    sde.bpMaterials.insert(998, 771, 6);
    sde.bpTime.insert(999, 3600);
    sde.bpTime.insert(998, 3600);

    final eveSD = CompositeReactionItemsAndBPs(sde);
    final blueprints = eveSD.getBlueprints();
    final items = eveSD.getItems();

    expect(blueprints.length, 2);
    expect(items.length, 4);

    sde.dispose();
  });

  test('isItemBuildable returns true because item has a blueprint', () {
    final sde = EveSDE(sqlite3.openInMemory(), isTesting: true);

    sde.types.insert(1, 'test', .42, sde.constants.ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.bpProduct.insert(999, 1, 42);

    final eveSD = CompositeReactionItemsAndBPs(sde);

    expect(eveSD.isItemBuildable(1), true);

    sde.dispose();
  });

  test('isItemBuildable returns false because item does not have a blueprint', () {
    final sde = EveSDE(sqlite3.openInMemory(), isTesting: true);

    sde.types.insert(1, 'test', .42, sde.constants.ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.bpProduct.insert(999, 2, 42);

    final eveSD = CompositeReactionItemsAndBPs(sde);

    expect(eveSD.isItemBuildable(1), false);

    sde.dispose();
  });

  test('isItemFuelBlock returns true', () {
    final sde = EveSDE(sqlite3.openInMemory(), isTesting: true);

    sde.types.insert(1, 'fuel blk', .42, sde.constants.FUEL_BLOCK_MARKET_GROUP_ID, 9);

    final eveSD = CompositeReactionItemsAndBPs(sde);

    expect(eveSD.isItemFuelBlock(1), true);

    sde.dispose();
  });

  test('isItemFuelBlock returns false', () {
    final sde = EveSDE(sqlite3.openInMemory(), isTesting: true);

    sde.types.insert(1, 'fuel blk', .42, sde.constants.FUEL_BLOCK_MARKET_GROUP_ID + 1, 9);

    final eveSD = CompositeReactionItemsAndBPs(sde);

    expect(eveSD.isItemFuelBlock(1), false);

    sde.dispose();
  });
}
