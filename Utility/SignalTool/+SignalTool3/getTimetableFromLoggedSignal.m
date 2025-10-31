function result = getTimetableFromLoggedSignal(logsout)
% Get a timetable for logged signals.
%
% This function supports both Simscape selective data logging and Simulink signal logging.
% extractTimetable works with Simulink signal logging only.
%
% Example
%
%   sim_out = sim("mymodel1");  % Single simulation output is used (by default.)
%   tt = SignalTool3.getTimetableFromLoggedSignal(sim_out.logsout);
%   % extractTimetable(sim_out.logsout) works with Simulink signal logging only.
%
% tt is a timetable containing logged signals recorded in both Simscape blocks and Simulink signals.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  % Dataset is the default data format for signal logging.
  logsout (1,1) Simulink.SimulationData.Dataset
end  % arguments

arguments (Output)
  result timetable
end  % arguments

num_sigs = numElements(logsout);

result_signals(1:num_sigs) = struct("Data", timetable.empty);

unit_texts = strings(1, num_sigs);

for ii = 1 : num_sigs

  % Applying timeseries2timetable for each signal works for both Simscape and Simulink.
  result_signals(ii).Data = timeseries2timetable(logsout{ii}.Values);

  if isempty(result_signals(ii).Data.Properties.VariableUnits)
    unit_texts(ii) = "";
  else
    unit_texts(ii) = result_signals(ii).Data.Properties.VariableUnits;
  end  % if
end  % for

% synchronize makes sure consistent time points including events.
result = synchronize(result_signals(:).Data);
result.Properties.VariableUnits = unit_texts;

end  % function
