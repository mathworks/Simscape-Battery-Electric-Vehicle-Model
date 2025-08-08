%% Parameters for testing inputs

% Copyright 2025 The MathWorks, Inc.

% Negative value for charing.
testParam.CRate = -0.1;

testParam.LoadCurrent = simscape.Value(0, "A");


testParam.NominalCapacity = simscape.Value(60, "kWh");

testParam.NominalVoltage = simscape.Value(340, "V");

testParam.NominalCharge = HighVoltageBatteryTool1.getAmpereHourRating( ...
  Capacity = testParam.NominalCapacity, ...
  Voltage = testParam.NominalVoltage, ...
  StateOfCharge = 1.0 );  % SOC=1 to get the nominal value.

batteryHV.nominalCharge_Ahr = value(testParam.NominalCharge, "Ah");
