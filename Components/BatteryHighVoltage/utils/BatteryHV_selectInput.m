function BatteryHV_selectInput(nvpairs)
%% Selects external input signal pattern

% Copyright 2022 The MathWorks, Inc.

arguments
  nvpairs.InputPattern {mustBeTextScalar, mustBeMember(nvpairs.InputPattern, ...
    ["Constant", "Charge", "Discharge", "LoadCurrentStep3"])} ...
    = "Constant"
  nvpairs.DisplayMessage (1,1) logical = false
  nvpairs.DisplayPlot (1,1) logical = false
end

inputPattern = nvpairs.InputPattern;
dispMsg = nvpairs.DisplayMessage;
dispPlot = nvpairs.DisplayPlot;

%%
if dispMsg
  disp("Selecting input: " + inputPattern)
end

inSigBuilder = BatteryHV_InputSignalBuilder;
inSigBuilder.Plot_tf = dispPlot;

inpData = feval(char(inputPattern), inSigBuilder);

assignin("base", "batteryHV_InputSignals", inpData.Signals)
assignin("base", "batteryHV_InputBus", inpData.Bus)

% Simulation time
t_end = inpData.Options.StopTime_s;
assignin("base", "t_end", t_end)

if dispMsg
  disp("Setting initial conditions...")
end
evalin("base", "initial.hvBattery_SOC_pct = " + inpData.Options.InitialSOC_pct + ";");
evalin("base", "initial.hvBattery_Charge_Ahr = " + inpData.Options.InitialCharge_Ahr + ";");

evalin("base", "initial.hvBattery_Temperature_K = 273.15 + " ...
                  + inpData.Options.InitialTemperature_degC + ";");

end  % function
