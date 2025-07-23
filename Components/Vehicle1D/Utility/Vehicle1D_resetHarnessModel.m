function Vehicle1D_resetHarnessModel(modelName)
%% Resets harness model

% Copyright 2022-2023 The MathWorks, Inc.

arguments
  modelName {mustBeTextScalar} = "Vehicle1D_TestModel"
end

disp("Resetting the model: " + modelName)

if not(bdIsLoaded(modelName))
  load_system(modelName)
end

Vehicle1D_TestModelSetup

Vehicle1D_setSimCase_Accelerate

end  % function
