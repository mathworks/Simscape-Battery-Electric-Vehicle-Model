function elevation = findInitialElevationFromRoadGradeProfile(x_vec, grade_pct_vec, interp_method, left_z, inipos, dx)
% Find initial elevation from road grade profile and initial horizontal position.
% This function first builds elevation profile from the specified road profile data,
% then finds the initial elevation corresponding to the specified initial horizontal position,
% and returns it.
%
% Road Grade Profile block uses this function to initialize the elevation.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)

  % Horizontal distance
  x_vec (1,:) double {bevutil1.CodeUtil.mustBeStrictAscend} = [-100, 0, 100]

  % Road grade percent
  grade_pct_vec (1,:) double = [ -1 -1 -1 ]

  % Interpolation method
  %   1 is linear.
  %   2 is smooth.
  % These are defined in the simscape.enum namespace:
  %   matlabroot > toolbox > physmod > simscape > library > m > +simscape > +enum > interpolation.m
  interp_method (1,1) int32 {mustBeInteger} = int32(1)

  % Elevation at the left most horizontal position
  left_z (1,1) double = 1

  % Initial horizontal position
  inipos (1,1) double = 0

  % Interpolation interval for visualization
  % Default is nan, and the default interval value is used.
  dx (1,1) double = 0.1

end  % arguments

arguments (Output)
  elevation (1,:) double
end  % arguments

if interp_method == int32(1)  % linear
  interp_type = "linear";
else
  interp_type = "smooth";
end  % if
result = buildElevationProfileFromRoadGradeProfileData(x_vec, grade_pct_vec, interp_type, left_z, dx);

% A scalar value at the last argument of interp1 sets the extrapolation to "Nearest".
elevation = interp1(result.x, result.z, inipos, "makima", grade_pct_vec(end));

end  % function
