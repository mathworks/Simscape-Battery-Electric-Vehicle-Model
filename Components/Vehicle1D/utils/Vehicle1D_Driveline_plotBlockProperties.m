function Vehicle1D_Driveline_plotBlockProperties(blk_handle)
%% Plots vehicle properties.

% Copyright 2022 The MathWorks, Inc.

arguments
  blk_handle (1,1) double = gcbh
end

block_info = Vehicle1DUtility.getVehicle1DDrivelineBlockInfo(blk_handle);

fig = Vehicle1DUtility.plotRoadLoad( ...
  VehicleMass_kg = block_info.M_e_kg, ...
  RoadLoadA_N = block_info.A_rl_N, ...
  RoadLoadB_N_per_kph = block_info.B_rl_N_per_kph, ...
  RoadLoadC_N_per_kph2 = block_info.C_rl_N_per_kph2, ...
  GravitationalAcceleration_m_per_s2 = block_info.grav_m_per_s2, ...
  VehicleSpeedVector_kph = linspace(0, 160, 200), ...
  RoadGradeVector_pct = [30, 15, 0] );

newFigureHeight = 600;

fig.Position = adjustFigureHeightAndWindowYPosition(fig, newFigureHeight);

end  % function
