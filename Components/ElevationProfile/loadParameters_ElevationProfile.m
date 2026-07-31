% Copyright 2026 The MathWorks, Inc.

HorizontalDistance = [0 50 100,  200 250 300,  400 450 500,  600 650 700,  800 850 900];
Elevation = [0 0 0, 1 1 1, 3 3 3, 6 6 6, 2 2 2];
Interval = 0.5;

RoadSurface = getGradeProfileFromElevationProfile(HorizontalDistance, Elevation, Interval);
