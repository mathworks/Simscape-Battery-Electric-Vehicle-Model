% Copyright 2020-2022 The MathWorks, Inc.

batteryHV_alldata = BatteryHVDetailed_getParamsMultiModule( ...
  NumParallelCellsInString = 2, ...
  NumSeriesStrings = 18 );

batteryHV_multi_pack1 = batteryHV_alldata.pack1;
batteryHV_multi_pack2 = batteryHV_alldata.pack2;
batteryHV_multi_other = batteryHV_alldata.other;
