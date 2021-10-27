%% Set up for for High Voltage Battery
% This script is executed by the PreLoadFcn callback in the test harness model.
% Running this script in PreLoadFcn makes sure that the model opens noramlly,
% and the model is ready for simulation.

% Copyright 2020-2021 The MathWorks, Inc.

%% Inputs

[InSig_BatteryHighV, InBus_BatteryHighV, opts] = BatteryHighVoltageBasic_Input().AllZero;

InputPatternName = opts.InputPatternName;

t_end = opts.StopTime_s;

%% Main parameters

batteryHighVoltage.nominalCapacity_kWh = 4;
batteryHighVoltage.voltagePerCell_V = 3.7;  % Open Circuit Voltage. 3.5V to 3.7V assuming Lithium-ion
batteryHighVoltage.nominalCharge_Ah = ...
  batteryHighVoltage.nominalCapacity_kWh / batteryHighVoltage.voltagePerCell_V * 1000;

batteryHighVoltage.packVoltage_V = 200;
batteryHighVoltage.internal_R_Ohm = 0.1;

%% Main initial conditions

initial.hvBatterySOC_pct = 70;
initial.hvBatteryCharge_Ah = batteryHighVoltage.nominalCharge_Ah * initial.hvBatterySOC_pct/100;
