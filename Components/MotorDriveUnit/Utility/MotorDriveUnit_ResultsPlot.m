function MotorDriveUnit_ResultsPlot(NameValuePair)
%% Make the plots of key signals from a simulation run.

% Copyright 2021-2025 The MathWorks, Inc.

arguments (Input)

  % Timetable takes a simulation result in timetable which you can generate
  % with the extractTimetable command from simulation output.
  NameValuePair.Timetable timetable

  NameValuePair.PlotHeight (1,1) {mustBePositive} = 300

end  % arguments

% These names are used to collect signals from simulation in the harness model.
% See the MotorDriveUnit_TestModel > Measurement subsystem.
signal_names = [
  "Motor torque command"
  "Axle clutch switch"
  "Axle speed input"
  "Axle torque input"
  "Motor power rate"
  "Motor speed"
  "Motor temperature"
  "Battery power"
  "Battery current"
  "Battery voltage"
  ];

for i = 1 : numel(signal_names)

  TimetableSingleSignalPlot( ...
    Timetable = NameValuePair.Timetable, ...
    SignalName = signal_names(i), ...
    PlotHeight = NameValuePair.PlotHeight );

end  % for
end  % function
