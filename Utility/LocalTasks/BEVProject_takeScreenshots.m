%% Take screenshots of models

% Taking screenshot with `screenshotSimulink` uses `print` function.
% `print` is not supported in `-nodisplay` option for MATLAB.
% `-nodisplay` option is used in CI.
% Thus, running this in CI causes failure in CI process.

% Copyright 2023 The MathWorks ,Inc.

%%

open_system("BEV_system_model")

% Update the model before taking a screenshot.
set_param("BEV_system_model", SimulationCommand = "update")

screenshotSimulink( ...
  SimulinkModelName = "BEV_system_model", ...
  SaveFolder = currentProject().RootFolder + "/BEV/images", ...
  OutputImageWidth_px = 700 );

img = imread(currentProject().RootFolder + "/BEV/images/image_BEV_system_model.png");

imshow(img)
