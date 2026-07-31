%% Setup script for Elevation Profile harness model
% If you edit this file, make sure to run this to update variables
% in the base workspace before simulation.

% Copyright 2026 The MathWorks, Inc.

% -----------------------------------------------------------------------------
% Road grade profile

RoadSurface.HorizontalDistance = simscape.Value([0 10 20, 30 40 50, 60 70 80, 90 100 110, 120 130 140], "m");
RoadSurface.GradePercent = [0 0 0 3 3 3 0 0 0 -5 -5 -5 0 0 0];
RoadSurface.LeftElevation = simscape.Value(0, "m");

initial.HorizontalPosition = simscape.Value(0, "m");

% -----------------------------------------------------------------------------
% Speed reference input

InputLUT.SpeedReference.Time = simscape.Value([0 1 2, 7 9 10], "s");
InputLUT.SpeedReference.Speed = simscape.Value([0 0 0, 40 40 40], "km/hr");
