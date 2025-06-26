function VehSpdRef_loadCase(NameValuePair)
%% Sets up simulation
% This function sets up the followings:
% - Simulation stop time
% - Input signals
%
% Model must be loaded for this function to work.

% Copyright 2023-2024 The MathWorks, Inc.

arguments
  NameValuePair.CaseName {mustBeTextScalar} = "Default"

  NameValuePair.ModelName {mustBeTextScalar} = "VehSpdRef_harness_model"
  NameValuePair.TargetSubsystemPath {mustBeTextScalar} = "/Vehicle speed reference"

  NameValuePair.CaseNumber (1,1) {mustBeMember(NameValuePair.CaseNumber, 1:5)} = 1
  NameValuePair.StopTime (1,1) {mustBePositive} = 100

  NameValuePair.DisplayMessage (1,1) logical = true
end

dispMsg = NameValuePair.DisplayMessage;

if dispMsg
  disp("Setting up simulation...")
  disp("Simulation case: " + NameValuePair.CaseName)
end

mdl = NameValuePair.ModelName;

t_end = NameValuePair.StopTime;

if dispMsg
  disp("Setting simulation stop time to " + t_end + " sec.")
end

set_param(mdl, StopTime = num2str(t_end));

caseNumStr = num2str(NameValuePair.CaseNumber);
if dispMsg
  disp("Selecting simulation case " + caseNumStr + ".")
end

sysPath = mdl + NameValuePair.TargetSubsystemPath;

set_param( sysPath + "/Simulation Case", ...
  Value = caseNumStr)

end  % function
