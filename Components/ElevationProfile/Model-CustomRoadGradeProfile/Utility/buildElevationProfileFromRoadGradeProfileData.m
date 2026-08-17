function result = buildElevationProfileFromRoadGradeProfileData(x_vec, grade_pct_vec, interp_method, left_z, dx)
% Build a table of refined elevation profile from road grade profile base data.
%
% This function does not use the named arguments (name-value pair) because
% the Road Grade Profile component calls this function in the private variables
% section which does not support calling functions with named arguments.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)

  % Horizontal distance. Unrefined base data.
  x_vec (1,:) double {bevutil1.CodeUtil.mustBeStrictAscend} = [ -100, 0, 100 ]

  % Road grade percent. Unrefined base data.
  grade_pct_vec (1,:) double = [ -1 -1 -1 ]

  % Interpolation method
  interp_method (1,1) string {mustBeMember(interp_method, ["linear", "smooth"])} = "linear"

  % Elevation at the left most horizontal position
  left_z (1,1) double = 1

  % Interpolation interval
  % Default is nan, and the default interval value is used.
  dx (1,1) double = nan

end  % arguments

arguments (Output)
  result table
end  % arguments

errorID = "buildElevationProfileFromRoadGradeProfileData:";

if numel(x_vec) <= 2
  id = errorID + "InvalidHorizontalDistance";
  msg = bevutil1.CodeUtil.i18n("Horizontal distance needs at least 3 elements.");

  throw(MException(id, msg))

end  % if

if numel(grade_pct_vec) <= 2
  id = errorID + "InvalidRoadGradePercent";
  msg = bevutil1.CodeUtil.i18n("Road grade needs at least 3 elements.");

  throw(MException(id, msg))

end  % if
if numel(x_vec) ~= numel(grade_pct_vec)
  id = errorID + "VectorLengthMismatch";
  msg = bevutil1.CodeUtil.i18n("Horizontal distance and road grade must be the same length.");

  throw(MException(id, msg))

end  % if

if isnan(dx)
  dx = (x_vec(end) - x_vec(1)) / 100;
end  % if

% Refined horizontal distance
refined_x_vec = x_vec(1) : dx : x_vec(end);

if interp_method == "smooth"

  % A scalar value at the last argument of interp1 sets the extrapolation to "Nearest".
  refined_grade_pct_vec = interp1(x_vec, grade_pct_vec, refined_x_vec, "makima", grade_pct_vec(end));

else
  % "linear"

  % A scalar value at the last argument of interp1 sets the extrapolation to "Nearest".
  refined_grade_pct_vec = interp1(x_vec, grade_pct_vec, refined_x_vec, "linear", grade_pct_vec(end));

end  % if

vertical_change_vec = dx * refined_grade_pct_vec / 100;

vertical_accum = cumsum(vertical_change_vec);
% The first element must be subtracted.
vertical_accum = vertical_accum - vertical_accum(1);

% Refined elevation
z = left_z + vertical_accum;

result = table(refined_x_vec', z', refined_grade_pct_vec', VariableNames=["x", "z", "grade"]);

end  % function
