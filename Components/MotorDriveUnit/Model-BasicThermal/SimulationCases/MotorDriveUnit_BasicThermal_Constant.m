%[text] # Motor Drive Unit - Simulation Case
%[text] ## Constant input signals
%[text] Check that the model runs out of the box.
mdl = "MotorDriveUnit_TestModel";
load_system(mdl)
MotorDriveUnit_TestModelSetup
%[text] Select model to use.
MotorDriveUnit_setRefsub_BasicThermal %[output:17bbdfbc]
%[text] Load simulation case.
MotorDriveUnit_setSimCase_Constant %[output:53e99511]
%[text] Run simulation.
simOut = sim(mdl);
%[text] Visually inspect the result.
simData = extractTimetable(simOut.logsout);
MotorDriveUnit_ResultsPlot(Timetable=simData, PlotHeight=100);
%[text] *Copyright 2021-2025 The Mathworks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:17bbdfbc]
%   data: {"dataType":"text","outputData":{"text":"Model: MotorDriveUnit_TestModel\nSetting up referenced subsystem: MotorDriveUnit_BasicThermal_refsub\n","truncated":false}}
%---
%[output:53e99511]
%   data: {"dataType":"text","outputData":{"text":"Setting up simulation...\nSimulation case: Constant inputs\nSetting simulation stop time to 1000 sec.\nSetting block parameters...\nbatteryHV.nominalVoltage_V = 340\nbatteryHV.internalResistance_Ohm = 0.01\nSetting initial conditions...\ninitial.loadInertiaSpd_rpm = 0\ninitial.motorSpd_rpm = 0\ninitial.motorDriveUnit_Temperature_K = 293.15\ninitial.ambientTemp_K = 293.15\n","truncated":false}}
%---
