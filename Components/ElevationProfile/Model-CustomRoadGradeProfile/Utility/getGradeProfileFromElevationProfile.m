function Result = getGradeProfileFromElevationProfile(x_vec, z_vec, dx)
% Compute road grade profile from road elevation profile.
% This function takes a road elevation vector and returns a tabulated road grade vector.
% Elevation vector is defined as a function of the horizontal distance and
% refined using the modified Akima (makima) spline with the specified interpolation interval.
% Grade is then computed on the refined horizontal points and returned.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)

  % Horizontal distance
  x_vec (:,1) double {mustBeReal, bevutil1.CodeUtil.mustBeStrictAscend}

  % Elevation
  z_vec (:,1) double {mustBeBetween(z_vec, -100, 100, "closed")}

  % Interpolation interval
  dx (1,1) double {mustBeReal}

end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "getGradeFromElevation:";

if length(x_vec) ~= length(z_vec)
  id = errorID + "VectorLengthMismatch";
  msg = bevutil1.CodeUtil.i18n("HorizontalDistance and Elevation must be the same length.");

  throw(MException(id, msg))

end  % if

if dx > (x_vec(end) - x_vec(1))/2
  id = errorID + "InvalidIntervalLength";
  msg = bevutil1.CodeUtil.i18n("Interpolation interval is too large.");

  throw(MException(id, msg))

end  % if

x_refined = 0 : dx : x_vec(end);

% A scalar value at the last argument of interp1 sets the extrapolation to "Nearest".
z_refined = interp1(x_vec, z_vec, x_refined, "makima", z_vec(end));

dzdx = gradient(z_refined, dx);

grade = 100 * tan(dzdx);

Result = table( x_refined', grade', z_refined' , ...
  VariableNames=["RefinedHorizontalDistance", "GradePercent", "RefinedElevation"]);

end  % function
