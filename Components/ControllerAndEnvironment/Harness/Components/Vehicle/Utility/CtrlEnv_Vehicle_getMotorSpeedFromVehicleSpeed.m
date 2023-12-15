function motorSpd_rpm = CtrlEnv_Vehicle_getMotorSpeedFromVehicleSpeed(nvpairs)
%% Computes motor speed from vehicle longitudinal speed

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.VehicleSpeed_kph (1,1) double {mustBeNonnegative} = 0
  nvpairs.TireRollingRadius_m (1,1) double {mustBePositive} = 0.35
  nvpairs.GearRatio (1,1) double {mustBePositive} = 9.1
end

vehSpd_kph = nvpairs.VehicleSpeed_kph;
tireRaidus_m = nvpairs.TireRollingRadius_m;
gearRatio = nvpairs.GearRatio;

circTire_m = 2*pi*tireRaidus_m;

vehSpd_m_per_min = vehSpd_kph*1000/60;

tireSpd_rpm = vehSpd_m_per_min / circTire_m;

motorSpd_rpm = tireSpd_rpm * gearRatio;

end  % function
