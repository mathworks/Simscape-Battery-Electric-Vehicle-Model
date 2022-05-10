%% Model Parameters for BEV Drive Cycle Basic Model

% Copyright 2020-2022 The MathWorks, Inc.

BevDriveCycle_params_Common

%% High Voltage Battery

% clear batteryHV

batteryHV.nominalVoltage_V = 350;

batteryHV.internalResistance_Ohm = 0.01;

batteryHV.nominalCapacity_kWh = 4;

batteryHV.voltagePerCell_V = 3.7;  % Open Circuit Voltage. 3.5V to 3.7V assuming Lithium-ion

batteryHV.nominalCharge_Ahr = ...
  batteryHV.nominalCapacity_kWh / batteryHV.nominalVoltage_V * 1000;

initial.hvBattery_SOC_pct = 70;

initial.hvBattery_Charge_Ahr = batteryHV.nominalCharge_Ahr * initial.hvBattery_SOC_pct/100;
