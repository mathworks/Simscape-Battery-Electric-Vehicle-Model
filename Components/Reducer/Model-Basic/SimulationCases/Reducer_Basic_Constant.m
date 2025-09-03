%[text] # Reducer Basic model - simulation case
model_name = "HarnessModel_Reducer";
load_system(model_name);

Reducer_Basic_params

sim_in = Simulink.SimulationInput(model_name);

sim_in = setBlockParameter(sim_in, model_name + "/Axle inputs", ReferencedSubsystem = "Inputs_Reducer_AxleSide_Constant_refsub");
sim_in = setBlockParameter(sim_in, model_name + "/Motor inputs", ReferencedSubsystem = "Inputs_Reducer_MotorSide_Constant_refsub");

sim_in = setModelParameter(sim_in, StopTime = "2000");
%[text] Run simulaiton.
sim_out = sim(sim_in);

% Signal logging for Simulink blocks is configured in the Measurement subsystem of the harness model.
% Signal logging for Simscape blocks is configured in the setupLogging_*.m files.
signals = SignalTool3.getTimetableFromLoggedSignal(sim_out.logsout);
%[text] Visually inspect the simulation result.
varnames = string(signals.Properties.VariableNames);
for ii = 1 : numel(varnames) %[output:group:4a47ba04]
  SignalTool3.plotTimedData(TimedData=signals, SignalName=varnames(ii), FigureHeight=150); %[output:29195d3c] %[output:78b26ab8] %[output:5f294f22] %[output:3396f8dc] %[output:32d79418] %[output:9c672938] %[output:3a2f6309]
end  % for %[output:group:4a47ba04]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:29195d3c]
%   data: {"dataType":"image","outputData":{"height":150,"width":700}}
%---
%[output:78b26ab8]
%   data: {"dataType":"image","outputData":{"height":150,"width":700}}
%---
%[output:5f294f22]
%   data: {"dataType":"image","outputData":{"height":150,"width":700}}
%---
%[output:3396f8dc]
%   data: {"dataType":"image","outputData":{"height":150,"width":700}}
%---
%[output:32d79418]
%   data: {"dataType":"image","outputData":{"height":150,"width":700}}
%---
%[output:9c672938]
%   data: {"dataType":"image","outputData":{"height":150,"width":700}}
%---
%[output:3a2f6309]
%   data: {"dataType":"image","outputData":{"height":150,"width":700}}
%---
