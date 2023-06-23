function refsubName = BatteryHV_getReferencedSubsystemFilename(nvpairs)
%% Finds the referenced system filename of High Voltage Battery block
% Model must be loaded before calling this function.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.ModelName (1,1) {mustBeTextScalar} = "BatteryHV_harness_model"
  nvpairs.ReferencedSubsystemPrefix (1,1) {mustBeTextScalar} = "BatteryHV_refsub_"
end

% if not(bdIsLoaded(nvpairs.ModelName))
%   load_system(nvpairs.ModelName)
% end

% Find the referenced subsystem filename of High Voltage Battery block.
% Returned data can contain multiple elements.
refsubName = Simulink.SubsystemReference.getAllReferencedSubsystemBlockDiagrams(nvpairs.ModelName);
refsubName = string(refsubName);

% logical index
lix = startsWith(refsubName, nvpairs.ReferencedSubsystemPrefix);

% Get the intended name only.
refsubName = refsubName(lix);

assert(refsubName ~= "", ...
  "Referenced subsystem filename was not found.")

end  % function
