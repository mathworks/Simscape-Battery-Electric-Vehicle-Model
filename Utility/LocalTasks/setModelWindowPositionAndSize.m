function setModelWindowPositionAndSize(ModelFilename)
%% Sets the window position and size of Simulink model
%
% To get the window position and size of a Simulink model,
% open the model and run the following command.
%
%   get_param(bdroot, "location")
%
% Some common screen resolutions
%   1920 x 1080
%   1366 x  768
%   1440 x  900
%   1536 x  864
%   2560 x 1440
% Minimum width and height
%   1366, 768

% Copyright 2023 The MathWorks, inc.

arguments
  % .mdl or .slx file
  ModelFilename {mustBeText} = gcs
end

set_param(ModelFilename, location=[60 60 1200 700])

% set_param(ModelFilename, location=[80 40 1300 780])

end  % function
