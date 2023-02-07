function info = Vehicle1D_getLongitudinalVehicleInfo(targetBlockName)
% Collects block parameter values from Longitudinal Vehicle block.
% To use this function, make sure to select the block in Simulink canvas and
% then pass block handle to this function.

% Copyright 2021-2022 The MathWorks, Inc.

arguments
  targetBlockName {mustBeTextScalar} = "Longitudinal Vehicle"
end

blockPaths = getfullname(Simulink.findBlocksOfType( gcs, ...
  "SimscapeBlock", ...
  Simulink.FindOptions( SearchDepth = 1 )));

% logical index
lix = endsWith(blockPaths, targetBlockName);

% Block name in a subsystem is guaranteed to be unique.
% Target block should be found, and the number of match is required to be 1.
assert(nnz(lix) == 1, ...
  "Block was not found: " + targetBlockName)

fullpathToBlock = gcs + "/" + targetBlockName(lix);
% block_handle = getSimulinkBlockHandle(block_path);

% Collect mask workspace variables.
% They have been evaluated.
% See the documentation for Simulink.VariableUsage.
maskVars = get_param(fullpathToBlock, "MaskWSVariables");
varNames = string({maskVars.Name});
varValues = {maskVars.Value};

getPar = @(varName) varValues{varNames == varName};

% Block parameters can have physical units.
% To use correct units, first get the value and unit of a parameter
% and build a Simscape value object using getSscVal defined here:
getSscVal = @(varName) simscape.Value(getPar(varName), getPar(varName + "_unit"));
% Then obtain the value in the expected unit using the value function.

% ================
% Block parameters

info.ParameterizationType = getPar("vehParamType");
vehparamType = info.ParameterizationType;

switch vehparamType
case sdl.enum.VehicleParameterizationType.RoadLoad
  M = getSscVal('M_vehicle');
  R = getSscVal('R_tireroll');
  A = getSscVal('A_rl');
  B = getSscVal('B_rl');
  C = getSscVal('C_rl');
  info.VehicleMass = M;
  info.TireRadius = R;
  info.RoadLoadA = A;
  info.RoadLoadB = B;
  info.RoadLoadC = C;

case sdl.enum.VehicleParameterizationType.Regular
  M = getSscVal('M_vehicle');
  R = getSscVal('R_tireroll');
  Cr = getSscVal('C_tireroll');
  Cd = getSscVal('C_airdrag');
  Af = getSscVal('A_front');
  air_density = getSscVal('air_density');

case sdl.enum.VehicleParameterizationType.Small
  M = simscape.Value(1100, 'kg');
  R = simscape.Value(0.3, 'm');
  Cr = simscape.Value(0.0130, '1');
  Cd = simscape.Value(0.30, '1');
  Af = 0.9*simscape.Value(1.65, 'm')*simscape.Value(1.45, 'm');
  air_density = simscape.Value(1.184, 'kg/m^3');

case sdl.enum.VehicleParameterizationType.Medium
  M = simscape.Value(1800, 'kg');
  R = simscape.Value(0.3, 'm');
  Cr = simscape.Value(0.0136, '1');
  Cd = simscape.Value(0.31, '1');
  Af = 0.9*simscape.Value(1.75, 'm')*simscape.Value(1.5, 'm');
  air_density = simscape.Value(1.184, 'kg/m^3');

case sdl.enum.VehicleParameterizationType.Large
  M = simscape.Value(2600, 'kg');
  R = simscape.Value(0.4, 'm');
  Cr = simscape.Value(0.014, '1');
  Cd = simscape.Value(0.36, '1');
  Af = 0.9*simscape.Value(1.88, 'm')*simscape.Value(1.85, 'm');
  air_density = simscape.Value(1.184, 'kg/m^3');

end

g = getSscVal('g');

if vehparamType ~= sdl.enum.VehicleParameterizationType.RoadLoad
  A = Cr*M*g;
  B = simscape.Value(0, 'N/(m/s)');
  C = 0.5*Cd*Af*air_density;
  info.VehicleMass = M;
  info.TireRadius = R;
  info.RollingCoefficient = Cr;
  info.AirDragCoefficient = Cd;
  info.FrontalArea = Af;
  info.AirDensity = air_density;
  info.RoadLoadA = A;
  info.RoadLoadB = B;
  info.RoadLoadC = C;
end

info.GravitationalAcceleration = g;
info.VehicleSpeedThreshold = getSscVal('V_1');
info.AxleSpeedThreshold = getSscVal('w_1');

end
