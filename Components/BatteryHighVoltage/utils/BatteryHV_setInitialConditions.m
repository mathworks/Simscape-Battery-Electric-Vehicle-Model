function BatteryHV_setInitialConditions(nvpairs)
%% Computes and sets initial conditions

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.TerminalVoltage_V (1,1) {mustBePositive} = 350
  nvpairs.NominalCapacity_kWh (1,1) {mustBePositive} = 40
  nvpairs.InitialSOC_pct (1,1) {mustBeInRange(nvpairs.InitialSOC_pct, 0, 100)} = 70
  nvpairs.InitialBatteryTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.DisplayMessage (1,1) logical = true
end

dispMsg = nvpairs.DisplayMessage;

if dispMsg
  disp("Setting initial conditions...")
end

V = nvpairs.TerminalVoltage_V;

kWh = nvpairs.NominalCapacity_kWh;

Initial_SOC_pct = nvpairs.InitialSOC_pct;
setValue("initial.hvBattery_SOC_pct", Initial_SOC_pct, dispMsg)

charge_Ahr = BatteryHV_getAmpereHourRating( ...
  Voltage_V = V, ...
  Capacity_kWh = kWh, ...
  StateOfCharge_pct = Initial_SOC_pct );
setValue("initial.hvBattery_Charge_Ahr", charge_Ahr, dispMsg)

Initial_BattTemp_K = nvpairs.InitialBatteryTemperature_K;
setValue("initial.hvBattery_Temperature_K", Initial_BattTemp_K, dispMsg)

end  % function

function setValue(workspaceVarName, value, displayMessage)
arguments
  workspaceVarName {mustBeTextScalar} = "var1"
  value (1,1) double = 1.0
  displayMessage (1,1) logical = true
end
if displayMessage
  disp(workspaceVarName + " = " + value)
end
evalin("base", workspaceVarName + " = " + value + ";");
end  % function
