function Charge_Ah = BatteryHV_getAmpereHourRating(nvpairs)
%% Computes ampere-hour rating

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.Voltage_V (1,1) double {mustBePositive} = 350
  nvpairs.Capacity_kWh (1,1) double {mustBePositive} = 4
  nvpairs.StateOfCharge_pct (1,1) double {mustBeInRange(nvpairs.StateOfCharge_pct, 0, 100)} = 70
end

Voltage_V = nvpairs.Voltage_V;
Capacity_kWh = nvpairs.Capacity_kWh;
SOC_percent = nvpairs.StateOfCharge_pct;

SOC_normalized = SOC_percent/100;

Charge_Ah = Capacity_kWh*1000 / Voltage_V;

Charge_Ah = Charge_Ah * SOC_normalized;

end  % function
