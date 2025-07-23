signal_names = ["Duration", "Distance"];
unit_texts = ["hr", "km"];
%[text] 
dataset = Simulink.SimulationData.Dataset;

signal_1 = Simulink.SimulationData.Signal;
% signal_1.Name = signal_names(1);  % No effect
signal_1.Values = timeseries([1 0 -1]', [0 1 2]', "Name", signal_names(1));
signal_1.Values.DataInfo.Units = unit_texts(1);
dataset = addElement(dataset, signal_1, signal_names(1));

signal_2 = Simulink.SimulationData.Signal;
% signal_2.Name = signal_names(2);  % No effect
signal_2.Values = timeseries([5 2 4]', [0 1 2]', "Name", signal_names(2));
signal_2.Values.DataInfo.Units = unit_texts(2);
dataset = addElement(dataset, signal_2, signal_names(2));
%[text] 
logsout = dataset;
%[text] 
num_sigs = numElements(logsout);
result_signals(1:num_sigs) = struct("Data", timetable.empty);
unit_texts = strings(1, num_sigs);
for idx = 1 : num_sigs

  result_signals(idx).Data = timeseries2timetable(logsout{idx}.Values);
  % result_signals(idx).Data.Properties.VariableNames = {logsout{idx}.Name};  % This is necessary

  if isempty(result_signals(idx).Data.Properties.VariableUnits)
    unit_texts(idx) = "";
  else
    unit_texts(idx) = result_signals(idx).Data.Properties.VariableUnits;
  end
end
result = synchronize(result_signals(:).Data);
result.Properties.VariableUnits = unit_texts;

disp(result.Properties) %[output:24db6cca]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:24db6cca]
%   data: {"dataType":"text","outputData":{"text":"  <a href=\"matlab:helpPopup('matlab.tabular.TimetableProperties')\" style=\"font-weight:bold\">TimetableProperties<\/a> with properties:\n\n             Description: ''\n                UserData: []\n          DimensionNames: {'Time'  'Variables'}\n           VariableNames: {'Duration'  'Distance'}\n           VariableTypes: [\"double\"    \"double\"]\n    VariableDescriptions: {}\n           VariableUnits: {'hr'  'km'}\n      VariableContinuity: [continuous    continuous]\n                RowTimes: [3×1 duration]\n               StartTime: 0 sec\n              SampleRate: 1\n                TimeStep: 1 sec\n                  Events: []\n        CustomProperties: No custom properties are set.\n      Use <a href=\"matlab:helpPopup timetable\/addprop\">addprop<\/a> and <a href=\"matlab:helpPopup timetable\/rmprop\">rmprop<\/a> to modify CustomProperties.\n\n","truncated":false}}
%---
