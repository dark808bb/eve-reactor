import 'package:evereactor/sde_tables/map_regions.dart';
import 'package:evereactor/sde_tables/map_solar_systems.dart';
import 'package:evereactor/sde_tables/market_groups.dart';
import 'package:evereactor/sde_tables/inv_types_table.dart';

class Constants {
  final MapSolarSystemsTable systemsTable;
  final MapRegionsTable regionsTable;
  final InvTypesTable typesTable;
  final InvMarketGroupsTable marketGroupsTable;

  // This class acts a bit differently when in a testing environment
  final bool isTesting;
  static const int X = 100000;

  Constants(db, this.isTesting)
      : systemsTable = MapSolarSystemsTable(db),
        regionsTable = MapRegionsTable(db),
        typesTable = InvTypesTable(db),
        marketGroupsTable = InvMarketGroupsTable(db) {
    if (isTesting) {
      // There is no information about id's in testing databases
      // So just assign random IDs
      return;
    }

    ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID = getMarketGroupID('Advanced Moon Materials');
    PROCESSED_MOON_MATERIAL_MARKET_GROUP_ID = getMarketGroupID('Processed Moon Materials');
    RAW_MOON_MATERIAL_MARKET_GROUP_ID = getMarketGroupID('Raw Moon Materials');

    THE_FORGE_REGION_ID = getRegionID('The Forge');
    DOMAIN_REGION_ID = getRegionID('Domain');
    SINQ_LAISON_REGION_ID = getRegionID('Sinq Laison');
    METROPOLIS_REGION_ID = getRegionID('Metropolis');
    HEIMATAR_REGION_ID = getRegionID('Heimatar');

    AMARR_SYSTEM_ID = getSystemID('Amarr');
    ASHAB_SYSTEM_ID = getSystemID('Ashab');
    JITA_SYSTEM_ID = getSystemID('Jita');
    PERIMETER_SYSTEM_ID = getSystemID('Perimeter');
    DODIXIE_SYSTEM_ID = getSystemID('Dodixie');
    BOTANE_SYSTEM_ID = getSystemID('Botane');
    RENS_SYSTEM_ID = getSystemID('Rens');
    FRARN_SYSTEM_ID = getSystemID('Frarn');
    HEK_SYSTEM_ID = getSystemID('Hek');

    TEST_REACTION_BP_TYPE_ID = getTypeID('Test Reaction Blueprint');
  }

  int getMarketGroupID(String name) {
    name = "'" + name + "'";
    return marketGroupsTable.select(['marketGroupID'], 'marketGroupName=$name').last['marketGroupID'];
  }

  int getRegionID(String region) {
    region = "'" + region + "'";
    return regionsTable.select(['regionID'], 'regionName=$region').last['regionID'];
  }

  int getSystemID(String system) {
    system = "'" + system + "'";
    return systemsTable.select(['solarSystemID'], 'solarSystemName=$system').last['solarSystemID'];
  }

  int getTypeID(String item) {
    item = "'" + item + "'";
    return typesTable.select(['typeID'], 'typeName=$item').last['typeID'];
  }

  int ADVANCED_MOON_MATERIAL_MARKET_GROUP_ID = X;
  int PROCESSED_MOON_MATERIAL_MARKET_GROUP_ID = X + 1;
  int RAW_MOON_MATERIAL_MARKET_GROUP_ID = X + 2;

  // I do not look this up because there are two market groups named 'Fuel Blocks'
  int FUEL_BLOCK_MARKET_GROUP_ID = 1870;

  // This item is included in some queries related to reactions so it needs to be ignored
  int TEST_REACTION_BP_TYPE_ID = X + 3;

  int THE_FORGE_REGION_ID = X + 4;
  int DOMAIN_REGION_ID = X + 5;
  int SINQ_LAISON_REGION_ID = X + 6;
  int METROPOLIS_REGION_ID = X + 7;
  int HEIMATAR_REGION_ID = X + 8;

  int AMARR_SYSTEM_ID = X + 9;
  int ASHAB_SYSTEM_ID = X + 10;
  int JITA_SYSTEM_ID = X + 11;
  int PERIMETER_SYSTEM_ID = X + 12;
  int DODIXIE_SYSTEM_ID = X + 13;
  int BOTANE_SYSTEM_ID = X + 14;
  int RENS_SYSTEM_ID = X + 15;
  int FRARN_SYSTEM_ID = X + 16;
  int HEK_SYSTEM_ID = X + 17;
}
