function info = getVehicle1DDrivelineBlockInfo(blk_gcbh)
% Collects block parameter values from longitudinal Vehicle block.
% To use this function, make sure to select the block in Simulink canvas and
% then pass gcbh to this function.

% Copyright 2021-2022 The MathWorks, Inc.

getp = @(p) evalin('base', get_param(blk_gcbh, p));

info.M_e_kg = getp('M_vehicle');
info.R_tire_m = getp('R_tireroll');
info.A_rl_N = getp('A_rl');
info.B_rl_N_per_kph = getp('B_rl');
info.C_rl_N_per_kph2 = getp('C_rl');
info.grav_m_per_s2 = getp('g');

end
