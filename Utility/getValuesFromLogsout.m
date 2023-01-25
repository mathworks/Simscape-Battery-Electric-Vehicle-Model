function vals = getValuesFromLogsout(loggedData, nvpairs)
%% Obtains the Values data from Simuilnk logged signals

% Copyright 2022 The MathWorks, Inc.

%% Description
% In a Simulink model, there can be multiple signal lines that are logged
% with the logging same name.
%
% x=logsout.get("Foo") returns a single Signal object
% if there is only one logged signal.
% You can write x.Time and x.Data to access the data.
%
% logsout.get("Foo") returns a Dataset object containing multiple Signals
% if there are two or more signals logged as "Foo".
% In this case, you must write x{1}.Time, x{1}.Data to access the first element,
% x{2}.Time, x{2}.Data for the second element, and so on.
%
% This function always returns one Signal object to simplify this situation.
%
% For example, suppose Simulink signals are stored in logsout.
% Then you can use this function as follows to make sure
% you can always access Time and Data.
%
%   vals = getValuesFromLogsout(logsout.get("Torque"));
%   t = vals.Time;
%   y = vals.Data;
%
% If there are multiple signals logged with the same name,
% the first signal is selected by default.
% Use the Index option to select a specific Signal element.
%
%   vals = getValuesFromLogsout(logsout.get("Torque"), "Index",2);
%
% However, you must know the index number upfront to use this option.

%% Code

arguments
  loggedData  % A thing returned from logsout.get("Foo")
  nvpairs.Index (1,1) {mustBeInteger, mustBePositive} = 1
end

if isa(loggedData, 'Simulink.SimulationData.Dataset')
  % There are multiple signals logged with the same name.

  % Use numElement function to count the number of Dataset elements.
  % Note that numel always returns 1 for Dataset.
  assert( nvpairs.Index <= numElements(loggedData) )

  % Use the first element in the Dataset.
  vals = loggedData{nvpairs.Index}.Values;

elseif  isa(loggedData, 'Simulink.SimulationData.Signal')
  % There is only one logged signal.

  vals = loggedData.Values;

else
  error("Invalid data type.")
end

end  % function
