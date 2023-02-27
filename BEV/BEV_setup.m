%% Model Parameters for Battery Electric Vehicle System Model
% This is automatically run in the PostLoadFcn callback of BEV_system_model
% and sets referenced subsystems.
% Note that the callback is not PreLoadFcn but PostLoadFcn
% because the model needs to be loaded before setting referenced subsystems.
%
% Informational messages from disp are turned off to prevent
% the warnings/diagnostics from appearing when the model is opened.

% Copyright 2020-2023 The MathWorks, Inc.

BEV_useComponents_Basic(DisplayMessage = false)
% BEV_useComponents_Thermal(DisplayMessage = false)
