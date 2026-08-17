function result = buildElevationProfileFromRoadGradeProfileBlock(BlockPath, NameValuePair)

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string = ""

  % Interpolation interval to build refined data
  NameValuePair.InterpolationInterval (1,1) simscape.Value {bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan} ...
    = simscape.Value(nan)

end  % arguments

arguments (Output)
  result table
end  % arguments

errorID = "buildElevationProfileFromRoadGradeProfileBlock:";

if BlockPath == ""
  id = errorID + "InvalidBlockPath";
  msg = bevutil1.CodeUtil.i18n("Block path must be specified.");

  throw(MException(id, msg))

end  % if

% !todo: check strict ascend
base_x_vec_value = get_param(BlockPath, "value@x_vector");
base_x_vec_unit = get_param(BlockPath, "x_vector_unit");
base_x_vec_ssc = simscape.Value(base_x_vec_value, base_x_vec_unit);

base_grade_pct_vec = get_param(BlockPath, "value@grade_vector");

interp_method = get_param(BlockPath, "profile_interp_method");
if interp_method == "simscape.enum.interpolation.linear"
  interp_type = "linear";
else
  interp_type = "smooth";
end  % if

left_z_value = get_param(BlockPath, "value@left_elevation");
left_z_unit = get_param(BlockPath, "left_elevation_unit");
left_z_ssc = simscape.Value(left_z_value, left_z_unit);

inipos_value = get_param(BlockPath, "value@initial_position");
inipos_unit = get_param(BlockPath, "initial_position_unit");

if isnan(NameValuePair.InterpolationInterval)
  dx = nan;
else
  dx = value(NameValuePair.InterpolationInterval, "m");
end

% buildElevationProfileFromRoadGradeProfile takes values as double.
% Make sure to use the same unit of length in the relevant arguments.
refined_data_m = buildElevationProfileFromRoadGradeProfileData( ...
  value(base_x_vec_ssc, "m"), ...
  base_grade_pct_vec, ...
  interp_type, ...
  value(left_z_ssc, "m"), ...
  dx );

% Build columns for horizontal distance and elevation using
% the unit of length specified in the block, rather than meters.
result = table( ...
  convert(simscape.Value(refined_data_m.x, "m"), base_x_vec_unit), ...
  convert(simscape.Value(refined_data_m.z, "m"), left_z_unit), ...
  refined_data_m.grade, ...
  VariableNames=["HorizontalDistance", "Elevation", "GradePercent"] );

custom_props = [
  "HorizontalDistance_value"
  "HorizontalDistance_unit"
  "RoadGradePercent"
  "InterpolationMethod"
  "LeftElevation_value"
  "LeftElevation_unit"
  "InitialHorizontalPosition_value"
  "InitialHorizontalPosition_unit"
  "InterpolationInterval"
  ];

result = addprop(result, custom_props, repmat("table", 1, numel(custom_props)));
result.Properties.CustomProperties.HorizontalDistance_value = base_x_vec_value;
result.Properties.CustomProperties.HorizontalDistance_unit = base_x_vec_unit;
result.Properties.CustomProperties.RoadGradePercent = base_grade_pct_vec;
result.Properties.CustomProperties.InterpolationMethod = interp_method;
result.Properties.CustomProperties.LeftElevation_value = left_z_value;
result.Properties.CustomProperties.LeftElevation_unit = left_z_unit;
result.Properties.CustomProperties.InitialHorizontalPosition_value = inipos_value;
result.Properties.CustomProperties.InitialHorizontalPosition_unit = inipos_unit;
result.Properties.CustomProperties.InterpolationInterval = dx;

end  % function
