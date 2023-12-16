function Vehicle1D_resetHarnessModel(modelName)
%% Resets harness model

% Copyright 2022-2023 The MathWorks, Inc.

arguments
  modelName {mustBeTextScalar} = "Vehicle1D_harness_model"
end

disp("Resetting the model: " + modelName)

if not(bdIsLoaded(modelName))
  load_system(modelName)
end

Vehicle1D_harness_setup

Vehicle1D_loadSimulationCase_Accelerate

end  % function
