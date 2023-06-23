function VehSpdRef_loadSimulationCase(nvpairs)
%% Sets up simulation
% This function sets up the followings:
% - Simulation stop time
% - Input signals
%
% Model must be loaded for this function to work.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.CaseName {mustBeTextScalar} = "Default"

  nvpairs.ModelName {mustBeTextScalar} = "VehSpdRef_harness_model"
  nvpairs.TargetSubsystemPath {mustBeTextScalar} = "/Vehicle speed reference"

  nvpairs.CaseNumber (1,1) {mustBeMember(nvpairs.CaseNumber, 1:5)} = 1
  nvpairs.StopTime (1,1) {mustBePositive} = 100

  nvpairs.DisplayMessage (1,1) logical = true
end

dispMsg = nvpairs.DisplayMessage;

if dispMsg
  disp("Setting up simulation...")
  disp("Simulation case: " + nvpairs.CaseName)
end

mdl = nvpairs.ModelName;

t_end = nvpairs.StopTime;

if dispMsg
  disp("Setting simulation stop time to " + t_end + " sec.")
end

set_param(mdl, StopTime = num2str(t_end));

caseNumStr = num2str(nvpairs.CaseNumber);
if dispMsg
  disp("Selecting simulation case " + caseNumStr + ".")
end

sysPath = mdl + nvpairs.TargetSubsystemPath;

set_param( sysPath + "/Simulation Case", ...
  Value = caseNumStr)

end  % function
