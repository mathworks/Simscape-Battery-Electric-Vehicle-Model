function BevDriveCycle_setSimulationTime(t_dur)
%% Load a SimulationTime duration object to the base workspace.
% FTP-75 drive cycle: 2474 seconds

% Copyright 2022 The MathWorks, Inc.

arguments
  t_dur (1,1) duration = seconds(30)
end

t_s = seconds(t_dur);
t_ch = num2str(t_s);

assignin('base', 'SimulationTime_dur', t_dur)
assignin('base', 'SimulationTime_s', t_s);
assignin('base', 'SimulationTime_char', t_ch);

end
