function fig = plotRoadLoad(nvpairs)
% Plots the road-load resisting force and power.

% Copyright 2021-2022 The MathWorks, Inc.

arguments
  % Block parameters
  nvpairs.VehicleMass_kg (1,1) double {mustBePositive} = 1800
  nvpairs.RoadLoadA_N (1,1) double {mustBePositive} = 100
  nvpairs.RoadLoadB_N_per_kph (1,1) double {mustBeNonnegative} = 0
  nvpairs.RoadLoadC_N_per_kph2 (1,1) double {mustBePositive} = 0.035
  nvpairs.GravitationalAcceleration_m_per_s2 (1,1) double {mustBePositive} = 9.81

  % x-axis, vehicle speed in km/hr
  nvpairs.VehicleSpeedVector_kph (:,1) double = linspace(0, 150, 400)'

  nvpairs.RoadGradeVector_pct (1,:) double ...
    { mustBeGreaterThan(nvpairs.RoadGradeVector_pct, -100), ...
      mustBeLessThan(nvpairs.RoadGradeVector_pct, 100)} = [40, 20, 0]
end

M_e_kg = nvpairs.VehicleMass_kg;
A_rl = nvpairs.RoadLoadA_N;
B_rl = nvpairs.RoadLoadB_N_per_kph;
C_rl = nvpairs.RoadLoadC_N_per_kph2;
grav = nvpairs.GravitationalAcceleration_m_per_s2;

v_kph_colvec = nvpairs.VehicleSpeedVector_kph;
grade_pct_rowvec = nvpairs.RoadGradeVector_pct;

%% Calculation
% Wind speed is ignored.

v_threshold_kph = 0.1;
v_norm_kph = 0.5;

incline_angle_rad_rowvec = atan(grade_pct_rowvec/100);
incline_angle_deg = round(incline_angle_rad_rowvec/pi*180, 1);  % for plotting

numGrades = length(grade_pct_rowvec);
incline_angle_rad = repmat(incline_angle_rad_rowvec, numel(v_kph_colvec), 1);

v_kph = repmat(v_kph_colvec/3.6, 1, numGrades);

legendStr = string(grade_pct_rowvec' + " % (" + incline_angle_deg' + " deg)");

F_roll_colvec = A_rl + B_rl*v_kph_colvec.*tanh(v_kph_colvec./v_threshold_kph);
F_roll = repmat(F_roll_colvec, 1, numGrades);

F_airdrag_colvec = C_rl*v_kph_colvec.^2;
F_airdrag = repmat(F_airdrag_colvec, 1, numGrades);

F_resist_flat = tanh(v_kph_colvec/v_norm_kph).*(F_roll + F_airdrag);

F_resist_N = F_resist_flat + M_e_kg*grav*sin(incline_angle_rad);
Power_resist_kW = v_kph .* F_resist_N/1000;

%% Plot

fig = figure;  hold on;  grid on
fig.Position(3:4) = [400 500];  % width height

tl = tiledlayout(fig, 2, 1);
tl.Padding = 'tight';

nexttile

for i = 1 : numGrades
  plot(v_kph_colvec, F_resist_N(:,i), "LineWidth",2)
  hold on
end
grid on
xlim([0 v_kph_colvec(end)])
lgd = legend(legendStr, "Location","northeast");  title(lgd, "Road grade")
xlabel("Vehicle Speed (km/hr)")
ylabel("Resisting Force (N)")

nexttile

for i = 1 : numGrades
  plot(v_kph_colvec, Power_resist_kW(:,i), "LineWidth",2)
  hold on
end
grid on
xlim([0 v_kph_colvec(end)])
lgd = legend(legendStr, "Location","northwest");  title(lgd, "Road grade")
xlabel("Vehicle Speed (km/hr)")
ylabel("Resisting Power (kW)")

end  % function
