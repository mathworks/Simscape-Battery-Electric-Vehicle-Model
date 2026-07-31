%[text] # Elevation Profile
%[text] Given road grade in percent $G${"editStyle":"visual"}, road inclination angle $\\theta${"editStyle":"visual"} is computed as follows.
%[text]{"align":"center"} $\\theta =\\mathrm{atan}\\left(\\frac{G}{100}\\right)${"editStyle":"visual"}
%[text] Given curvilinear position $s$, horizontal position $x$ and elevation $E$ are computed as follows.
%[text]{"align":"center"} $x=s\\;\\cos \\left(\\theta \\right)${"editStyle":"visual"}
%[text]{"align":"center"} $E=s\\;\\sin \\left(\\theta \\right)${"editStyle":"visual"}
%[text] For example, 100 unit distance (e.g., in meters or feet) in the curvilinear distance $s$ corresponds to the following distances for various road grades.
% Curvilinear distance
s = 100;
GradePercent = [0 1 2 3 5 7 10 15 20 30 40]';
InclineAngleRadians = atan(GradePercent/100);
InclineAngleDegrees = rad2deg(InclineAngleRadians);
HorizontalPosition = s*cos(InclineAngleRadians);
Elevation = s*sin(InclineAngleRadians);
result = table(GradePercent, InclineAngleDegrees, HorizontalPosition, Elevation, ...
  VariableNames=["Grade (%)", "Incline angle (deg)", "Horizontal position, x", "Elevation, E"]);
disp(result) %[output:266efe3a]

%[text] *Copyright 2026 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:266efe3a]
%   data: {"dataType":"text","outputData":{"text":"    <strong>Grade (%)<\/strong>    <strong>Incline angle (deg)<\/strong>    <strong>Horizontal position, x<\/strong>    <strong>Elevation, E<\/strong>\n    <strong>_________<\/strong>    <strong>___________________<\/strong>    <strong>______________________<\/strong>    <strong>____________<\/strong>\n\n        0                    0                     100                    0   \n        1              0.57294                  99.995              0.99995   \n        2               1.1458                   99.98               1.9996   \n        3               1.7184                  99.955               2.9987   \n        5               2.8624                  99.875               4.9938   \n        7               4.0042                  99.756               6.9829   \n       10               5.7106                  99.504               9.9504   \n       15               8.5308                  98.894               14.834   \n       20                11.31                  98.058               19.612   \n       30               16.699                  95.783               28.735   \n       40               21.801                  92.848               37.139   \n\n","truncated":false}}
%---
