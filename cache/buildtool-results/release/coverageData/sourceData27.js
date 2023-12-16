var sourceData27 = {"FileName":"C:\\local\\github-issacito12\\fork-bev\\Components\\BatteryHighVoltage\\BatteryHV_refsub_SystemTable_params.m","RawFileContents":["%% Model parameters for high voltage battery component\r","% This script contains parameters required by the following model only.\r","% - System-level battery model, table-based\r","%\r","% If you edit this file, make sure to run this to update variables\r","% in the base workspace before running simulation.\r","\r","% Copyright 2023 The MathWorks, Inc.\r","\r","%% Bus definitions\r","\r","defineBus_HighVoltage\r","\r","%% Battery parameters\r","\r","% === High voltage battery pack ===\r","% System-level specifications\r","\r","batteryHV.nominalVoltage_V = 340;\r","\r","batteryHV.nominalCapacity_kWh = 60;\r","\r","batteryHV.nominalCharge_Ahr = ...\r","  BatteryHV_getAmpereHourRating( ...\r","    Voltage_V = batteryHV.nominalVoltage_V, ...\r","    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...\r","    StateOfCharge_pct = 100 );\r","\r","% Table-based battery has terminal resistance parameter as a lookup table,\r","% but this is used to approximately compute the I-squared R loss.\r","batteryHV.internalResistance_Ohm = 0.01;\r","\r","batteryHV.NumCellsInSeries = 106;\r","batteryHV.NumStringsInParallel = 1;\r","\r","batteryHV.NumTotalCells = batteryHV.NumCellsInSeries * batteryHV.NumStringsInParallel;\r","\r","% --- Tabled-Based Battery block ---\r","% Parameters for a battery cell block, representing the whole battery pack.\r","\r","% State of charge ... independent variable 1\r","batteryHV.SOC_pct = 0 : 100;\r","batteryHV.SOC_normalized = 0 : 0.01 : 1;\r","\r","% Temperature ... independent variable 2\r","batteryHV.Temperatures_degC = [0 25 60];\r","\r","% Open-circuit voltage (cell voltage) as a function of SOC and temperature.\r","% This data must represent a cell.\r","% This should be multiplied by Voltage-Controlled Voltage Source block in the model.\r","batteryHV.OpenCircuitVoltage_V = ...\r","  BatteryHV_buildOpenCircuitVoltageData( ...\r","     0, [ 0 2.8; 10 3.0; 15 3.1; 25 3.3; 75 3.4; 90 3.5; 100 3.6 ], ...\r","    25, [ 0 2.9; 10 3.1; 15 3.2; 25 3.4; 75 3.5; 90 3.6; 100 3.9 ], ...\r","    60, [ 0 3.0; 10 3.3; 15 3.4; 25 3.6; 75 3.7; 90 3.8; 100 4.15 ]);\r","% degC, [ SOC_1, OCV_1; SOC_2, OCV_2; ... ]\r","\r","% Terminal resistance as a function of SOC and temperature.\r","% This data must represent a cell.\r","batteryHV.TerminalResistance_Ohm = ...\r","  BatteryHV_buildTerminalResistanceData( ...\r","     0, [ 0 0.47 ; 5 0.45  ; 15 0.218 ; 40 0.101 ; 80 0.086 ; 100 0.1   ], ...\r","    25, [ 0 0.17 ; 5 0.12  ; 15 0.072 ; 40 0.053 ; 80 0.044 ; 100 0.033 ], ...\r","    60, [ 0 0.13 ; 5 0.005 ; 15 0.04  ; 40 0.037 ; 80 0.03  ; 100 0.024 ]);\r","% degC, [ SOC_1, TR_1; SOC_2, TR_2; ... ]\r","\r","% Ampere-hour rating.\r","% This must be the total charge, rather than a single cell,\r","% thus this is determined from battery pack specifications.\r","batteryHV.CellCharge_Ahr = batteryHV.nominalCharge_Ahr;\r","\r","batteryHV.ThermalMassOfSingleCell_J_per_K = 100;\r","batteryHV.ThermalMassOfAllCells_J_per_K = ...\r","  batteryHV.ThermalMassOfSingleCell_J_per_K * batteryHV.NumTotalCells;\r","\r","% --- Voltage-Controlled Voltage Source ---\r","batteryHV.VoltageGain = -1 * batteryHV.NumCellsInSeries;\r","\r","% --- Current-Controlled Current Source ---\r","batteryHV.CurrentGain = (-1 * batteryHV.NumStringsInParallel) + 1;\r","\r","% === Ambient parameters ===\r","% Included in the battery component for thermal simulation\r","\r","batteryHV.ambientMass_t = 10000;\r","batteryHV.ambientSpecificHeat_J_per_Kkg = 1000;\r","batteryHV.ambientTemp_K = 273.15 + 20;\r","\r","batteryHV.RadiationArea_m2 = 1;\r","batteryHV.RadiationCoeff_W_per_K4m2 = 5e-10;\r","\r","%% Initial conditions\r","\r","initial.hvBattery_SOC_pct = 70;\r","initial.hvBattery_SOC_normalized = initial.hvBattery_SOC_pct / 100;\r","\r","initial.hvBattery_Charge_Ahr = ...\r","  BatteryHV_getAmpereHourRating( ...\r","    Voltage_V = batteryHV.nominalVoltage_V, ...\r","    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...\r","    StateOfCharge_pct = initial.hvBattery_SOC_pct );\r","\r","initial.hvBattery_Temperature_K = batteryHV.ambientTemp_K;\r","\r","initial.ambientTemp_K = batteryHV.ambientTemp_K;\r",""],"CoverageDisplayDataPerLine":{"Function":[],"Statement":[{"LineNumber":12,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":21,"ContinuedLine":false},{"LineNumber":19,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":33,"ContinuedLine":false},{"LineNumber":21,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":35,"ContinuedLine":false},{"LineNumber":23,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":29,"ContinuedLine":false},{"LineNumber":24,"Hits":6,"StartColumnNumbers":2,"EndColumnNumbers":32,"ContinuedLine":true},{"LineNumber":25,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":42,"ContinuedLine":true},{"LineNumber":26,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":48,"ContinuedLine":true},{"LineNumber":27,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":30,"ContinuedLine":true},{"LineNumber":31,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":40,"ContinuedLine":false},{"LineNumber":33,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":33,"ContinuedLine":false},{"LineNumber":34,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":35,"ContinuedLine":false},{"LineNumber":36,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":86,"ContinuedLine":false},{"LineNumber":42,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":28,"ContinuedLine":false},{"LineNumber":43,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":40,"ContinuedLine":false},{"LineNumber":46,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":40,"ContinuedLine":false},{"LineNumber":51,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":32,"ContinuedLine":false},{"LineNumber":52,"Hits":6,"StartColumnNumbers":2,"EndColumnNumbers":40,"ContinuedLine":true},{"LineNumber":53,"Hits":6,"StartColumnNumbers":5,"EndColumnNumbers":66,"ContinuedLine":true},{"LineNumber":54,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":66,"ContinuedLine":true},{"LineNumber":55,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":69,"ContinuedLine":true},{"LineNumber":60,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":34,"ContinuedLine":false},{"LineNumber":61,"Hits":6,"StartColumnNumbers":2,"EndColumnNumbers":40,"ContinuedLine":true},{"LineNumber":62,"Hits":6,"StartColumnNumbers":5,"EndColumnNumbers":73,"ContinuedLine":true},{"LineNumber":63,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":73,"ContinuedLine":true},{"LineNumber":64,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":75,"ContinuedLine":true},{"LineNumber":70,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":55,"ContinuedLine":false},{"LineNumber":72,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":48,"ContinuedLine":false},{"LineNumber":73,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":41,"ContinuedLine":false},{"LineNumber":74,"Hits":6,"StartColumnNumbers":2,"EndColumnNumbers":70,"ContinuedLine":true},{"LineNumber":77,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":56,"ContinuedLine":false},{"LineNumber":80,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":66,"ContinuedLine":false},{"LineNumber":85,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":32,"ContinuedLine":false},{"LineNumber":86,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":47,"ContinuedLine":false},{"LineNumber":87,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":38,"ContinuedLine":false},{"LineNumber":89,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":31,"ContinuedLine":false},{"LineNumber":90,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":44,"ContinuedLine":false},{"LineNumber":94,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":31,"ContinuedLine":false},{"LineNumber":95,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":67,"ContinuedLine":false},{"LineNumber":97,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":30,"ContinuedLine":false},{"LineNumber":98,"Hits":6,"StartColumnNumbers":2,"EndColumnNumbers":32,"ContinuedLine":true},{"LineNumber":99,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":42,"ContinuedLine":true},{"LineNumber":100,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":48,"ContinuedLine":true},{"LineNumber":101,"Hits":6,"StartColumnNumbers":4,"EndColumnNumbers":52,"ContinuedLine":true},{"LineNumber":103,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":58,"ContinuedLine":false},{"LineNumber":105,"Hits":6,"StartColumnNumbers":0,"EndColumnNumbers":48,"ContinuedLine":false}]}}