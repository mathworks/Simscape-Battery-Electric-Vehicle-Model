%[text] # Elevation Profile
%[text] Let $\\gamma \\;${"editStyle":"visual"} be normalized road grade value, which is computed from road grade $G${"editStyle":"visual"} (in percent) as
%[text]{"align":"center"} $\\gamma \\;=\\frac{G}{100}${"editStyle":"visual"}
%[text] Then, road incline angle $\\theta${"editStyle":"visual"} is computed as
%[text]{"align":"center"} $\\theta =\\mathrm{a}\\mathrm{t}\\mathrm{a}\\mathrm{n}\\left(\\gamma \\right)${"editStyle":"visual"}
%[text] Let $s${"editStyle":"visual"} be curvilinear coordinate which is parallel to the longitudinal direction of a vehicle. Then, horizontal position $x$ and elevation $E$ are computed as
%[text]{"align":"center"} $x=s\\;\\cos \\left(\\theta \\right)${"editStyle":"visual"}
%[text]{"align":"center"} $E=s\\;\\sin \\left(\\theta \\right)${"editStyle":"visual"}
%[text] For example, 100 unit distance (e.g., in meters or feet) on the curvilinear coordinate $s$ corresponds to the following distances for various road grades.
% Position on the curvilinear coordinate
s = 100;

GradePercent = [0 1 2 3 5 7 10 15 20 30 40]';
InclineAngleRadians = atan(GradePercent/100);
InclineAngleDegrees = rad2deg(InclineAngleRadians);
HorizontalPosition = s*cos(InclineAngleRadians);
Elevation = s*sin(InclineAngleRadians);

% Validation
Hypotenuse = hypot(HorizontalPosition, Elevation);

result = table(GradePercent, InclineAngleDegrees, HorizontalPosition, Elevation, Hypotenuse, ...
  VariableNames=["Grade (%)", "Incline angle (deg)", "Horizontal distance, x", "Elevation, E", "Curvilinear distance"]);

disp(result) %[output:266efe3a]
%[text] *Copyright 2026 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:266efe3a]
%   data: {"dataType":"text","outputData":{"text":"    <strong>Grade (%)<\/strong>    <strong>Incline angle (deg)<\/strong>    <strong>Horizontal distance, x<\/strong>    <strong>Elevation, E<\/strong>    <strong>Curvilinear distance<\/strong>\n    <strong>_________<\/strong>    <strong>___________________<\/strong>    <strong>______________________<\/strong>    <strong>____________<\/strong>    <strong>____________________<\/strong>\n\n        0                    0                     100                    0               100         \n        1              0.57294                  99.995              0.99995               100         \n        2               1.1458                   99.98               1.9996               100         \n        3               1.7184                  99.955               2.9987               100         \n        5               2.8624                  99.875               4.9938               100         \n        7               4.0042                  99.756               6.9829               100         \n       10               5.7106                  99.504               9.9504               100         \n       15               8.5308                  98.894               14.834               100         \n       20                11.31                  98.058               19.612               100         \n       30               16.699                  95.783               28.735               100         \n       40               21.801                  92.848               37.139               100         \n\n","truncated":false}}
%---
