%% Parameters for the vehicle speed reference harness model
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2026 The MathWorks, Inc.

loadLUTData_VehSpdRef_Simple

if not(bdIsLoaded("HarnessModel_VehSpdRef"))
  load_system("HarnessModel_VehSpdRef")
else
  assert(gcs == "HarnessModel_VehSpdRef")
end  % if

set_param(gcs, StopTime = "100")
set_param(gcs + "/Vehicle speed reference", ReferencedSubsystem = "VehSpdRef_LookupTable_refsub")
