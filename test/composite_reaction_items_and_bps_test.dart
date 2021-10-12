import 'package:sqlite3/sqlite3.dart';

import 'package:evereactor/eve_sde.dart';
import 'package:evereactor/constants.dart';
import 'package:evereactor/composite_reaction_items_and_bps.dart';

import 'package:test/test.dart';

void main() {
  test('An empty database results in empty EveStaticData fields', () {
    final sde = EveSDE(sqlite3.openInMemory());
    sde.setupForTesting();

    final eveSD = CompositeReactionItemsAndBPs(sde);
    final blueprints = eveSD.getBlueprints();
    final items = eveSD.getItems();

    expect(blueprints.length, 0);
    expect(items.length, 0);

    sde.dispose();
  });

  test('All items and blueprints are replicated in memory', () {
    final sde = EveSDE(sqlite3.openInMemory());
    sde.setupForTesting();

    sde.typesTb.insert(1, 'test', .42, ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.typesTb.insert(999, 'test bp', .01, 33, 10);
    sde.typesTb.insert(770, 'titan', .01, 0, 10);
    sde.typesTb.insert(771, 'mexall', .01, 0, 10);
    sde.typesTb.insert(772, 'pyery', .01, 0, 10);

    sde.bpProductTb.insert(999, 1, 42);
    sde.bpMaterialsTb.insert(999, 770, 6);
    sde.bpMaterialsTb.insert(999, 771, 6);
    sde.bpMaterialsTb.insert(999, 772, 6);
    sde.bpTimeTb.insert(999, 3600);

    final eveSD = CompositeReactionItemsAndBPs(sde);
    final blueprints = eveSD.getBlueprints();
    final items = eveSD.getItems();

    expect(blueprints.length, 1);
    expect(items.length, 4);

    sde.dispose();
  });

  test('Fuel blocks are not built', () {
    final sde = EveSDE(sqlite3.openInMemory());
    sde.setupForTesting();

    sde.typesTb.insert(1, 'test', .42, ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.typesTb.insert(999, 'test bp', .01, 33, 10);
    sde.typesTb.insert(998, 'fuelblk bp', .01, 33, 10);
    sde.typesTb.insert(770, 'fuel blc', 5, FUEL_BLOCK_MARKET_GROUP_ID, 10);
    sde.typesTb.insert(771, 'mexall', .01, 0, 10);
    sde.typesTb.insert(772, 'pyery', .01, 0, 10);

    sde.bpProductTb.insert(999, 1, 42);
    sde.bpProductTb.insert(998, 770, 42);
    sde.bpMaterialsTb.insert(999, 770, 6);
    sde.bpMaterialsTb.insert(999, 771, 6);
    sde.bpMaterialsTb.insert(999, 772, 6);
    sde.bpMaterialsTb.insert(998, 771, 6);
    sde.bpTimeTb.insert(999, 3600);
    sde.bpTimeTb.insert(998, 3600);

    final eveSD = CompositeReactionItemsAndBPs(sde);
    final blueprints = eveSD.getBlueprints();
    final items = eveSD.getItems();

    expect(blueprints.length, 1);
    expect(items.length, 4);
    // expect(blueprints[1]?.typeName, 'test');

    sde.dispose();
  });

  test('Fuel blocks are built when wrong market group is used', () {
    final sde = EveSDE(sqlite3.openInMemory());
    sde.setupForTesting();

    sde.typesTb.insert(1, 'test', .42, ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.typesTb.insert(999, 'test bp', .01, 33, 10);
    sde.typesTb.insert(998, 'fuelblk bp', .01, 33, 10);
    sde.typesTb.insert(770, 'fuel blk', 5, 8, 10);
    sde.typesTb.insert(771, 'mexall', .01, 0, 10);
    sde.typesTb.insert(772, 'pyery', .01, 0, 10);

    sde.bpProductTb.insert(999, 1, 42);
    sde.bpProductTb.insert(998, 770, 42);
    sde.bpMaterialsTb.insert(999, 770, 6);
    sde.bpMaterialsTb.insert(999, 771, 6);
    sde.bpMaterialsTb.insert(999, 772, 6);
    sde.bpMaterialsTb.insert(998, 771, 6);
    sde.bpTimeTb.insert(999, 3600);
    sde.bpTimeTb.insert(998, 3600);

    final eveSD = CompositeReactionItemsAndBPs(sde);
    final blueprints = eveSD.getBlueprints();
    final items = eveSD.getItems();

    expect(blueprints.length, 2);
    expect(items.length, 4);

    sde.dispose();
  });

  test('isItemBuildable returns true because item has a blueprint', () {
    final sde = EveSDE(sqlite3.openInMemory());
    sde.setupForTesting();

    sde.typesTb.insert(1, 'test', .42, ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.bpProductTb.insert(999, 1, 42);

    final eveSD = CompositeReactionItemsAndBPs(sde);

    expect(eveSD.isItemBuildable(1), true);

    sde.dispose();
  });

  test('isItemBuildable returns false because item does not have a blueprint', () {
    final sde = EveSDE(sqlite3.openInMemory());
    sde.setupForTesting();

    sde.typesTb.insert(1, 'test', .42, ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID, 9);
    sde.bpProductTb.insert(999, 2, 42);

    final eveSD = CompositeReactionItemsAndBPs(sde);

    expect(eveSD.isItemBuildable(1), false);

    sde.dispose();
  });

  test('isItemFuelBlock returns true', () {
    final sde = EveSDE(sqlite3.openInMemory());
    sde.setupForTesting();

    sde.typesTb.insert(1, 'fuel blk', .42, FUEL_BLOCK_MARKET_GROUP_ID, 9);

    final eveSD = CompositeReactionItemsAndBPs(sde);

    expect(eveSD.isItemFuelBlock(1), true);

    sde.dispose();
  });

  test('isItemFuelBlock returns false', () {
    final sde = EveSDE(sqlite3.openInMemory());
    sde.setupForTesting();

    sde.typesTb.insert(1, 'fuel blk', .42, FUEL_BLOCK_MARKET_GROUP_ID + 1, 9);

    final eveSD = CompositeReactionItemsAndBPs(sde);

    expect(eveSD.isItemFuelBlock(1), false);

    sde.dispose();
  });
}
