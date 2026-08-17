function RefinedData = buildElevationAndRoadGradeTable(NameValuePair)
% Build a table containing refined elevation and road grade profiles data from base data.
%
% This function takes unrefined data representing road grade profile as a function of
% horizontal position, refines the base data, and builds refined elevation profile data.
% The options of this function correspond to the parameters of the Road Grade Profile block
% except for the interpolation interval for visualization purpose.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)

  NameValuePair.BaseHorizontalDistance (1,:) simscape.Value = simscape.Value([-1 0 1], "m")

  NameValuePair.BaseGradePercent (1,:) double = [-1 -1 -1]

  NameValuePair.InterpolationMethod string {mustBeMember(NameValuePair.InterpolationMethod, ["smooth" "linear"])} ...
    = "linear"

  % Interpolation interval to build refined data
  NameValuePair.InterpolationInterval (1,1) simscape.Value {bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan} ...
    = simscape.Value(nan)

  NameValuePair.LeftElevation (1,1) simscape.Value = simscape.Value(0, "m")

end  % arguments

arguments (Output)
  RefinedData table
end  % arguments

unit_of_length = "m";

if isnan(NameValuePair.InterpolationInterval)
  dx = nan;
else
  dx = value(NameValuePair.InterpolationInterval, unit_of_length);
end

% buildElevationProfileFromRoadGradeProfileData takes values as double.
% Make sure to use the same unit of length for horizontal distance,
% left elevation, and interpolation interval.
refined_data_m = buildElevationProfileFromRoadGradeProfileData( ...
  value(NameValuePair.BaseHorizontalDistance, unit_of_length), ... horizontal distance
  NameValuePair.BaseGradePercent, ...
  NameValuePair.InterpolationMethod, ...
  value(NameValuePair.LeftElevation, unit_of_length), ... left elevation
  dx );  % interpolation interval

RefinedData = table( ...
  convert(simscape.Value(refined_data_m.x, unit_of_length), string(unit(NameValuePair.BaseHorizontalDistance))), ...
  convert(simscape.Value(refined_data_m.z, unit_of_length), string(unit(NameValuePair.LeftElevation))), ...
  refined_data_m.grade, ... The unit of grade is always percent, which is dimensionless.
  VariableNames=["HorizontalDistance", "Elevation", "GradePercent"] );

end  % function
