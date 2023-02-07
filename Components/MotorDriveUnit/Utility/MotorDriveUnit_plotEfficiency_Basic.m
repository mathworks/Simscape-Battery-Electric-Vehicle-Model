function fig = MotorDriveUnit_plotEfficiency_Basic(nvpairs)

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.MaxTorque_Nm (1,1) double {mustBePositive} = 420;
  nvpairs.MaxSpeed_rpm (1,1) double {mustBePositive} = 15000;
  nvpairs.MaxPower_kW (1,1) double {mustBePositive} = 220;

  nvpairs.Efficiency_pct (1,1) double {mustBePositive} = 95;
  nvpairs.SpeedAtEfficiencyMeasurement_rpm (1,1) double {mustBeNonnegative} = 2000;
  nvpairs.TorqueAtEfficiencyMeasurement_Nm (1,1) double {mustBeNonnegative} = 50;

  % Contour levels need 3 or more points for lower bound, upper bound,
  % and one or more points in between.
  nvpairs.ContourLevels_pct (1,:) double {mustBeNonnegative} = [1 60 80 90 92 94 96 97 98 99];

  nvpairs.PlotResolution (1,1) {mustBeInteger, mustBePositive} = 500;
end

% In Motor & Drive block from Siomscape Driveline,
% iron loss, constant electrical loss, and rotor friction are not modelled,
% i.e., they are 0. 
fig = MotorDriveUnit_plotEfficiency( ...
  MaxTorque_Nm = nvpairs.MaxTorque_Nm, ...
  MaxSpeed_rpm = nvpairs.MaxSpeed_rpm, ...
  MaxPower_kW = nvpairs.MaxPower_kW, ...
  Efficiency_pct = nvpairs.Efficiency_pct, ...
  SpeedAtEfficiencyMeasurement_rpm = nvpairs.SpeedAtEfficiencyMeasurement_rpm, ...
  TorqueAtEfficiencyMeasurement_Nm = nvpairs.TorqueAtEfficiencyMeasurement_Nm, ...
  IronLossToNominalLossRatio = 0, ...
  ConstantElectricalLoss_W = 0, ...
  RotorDamp_Nm_per_radps = 0, ...
  ContourLevels_pct = nvpairs.ContourLevels_pct, ...
  PlotResolution = nvpairs.PlotResolution );

end
