% This script is automatically run when the MATLAB Project is opened.
% To chagne the automatic execution setting, select the Project window, and in
% the PROJECT toolstrip, click Startup Shutdown button.
%
% Copyright 2020 The MathWorks, Inc.

v = ver('matlab');
if not(v.Version == "9.8")
  release = "R2020a";
  disp("!!!")
  disp("!!! This project is being developed in " + release + ",")
  disp("!!! but you are opening the project in " + v.Release(2:end-1) + ".")
  disp("!!!")
  clear release
end
clear v
