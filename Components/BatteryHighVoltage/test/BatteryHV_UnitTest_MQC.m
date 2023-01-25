classdef BatteryHV_UnitTest_MQC < matlab.unittest.TestCase
%% Class implementation of unit test

% Copyright 2021-2023 The MathWorks, Inc.

properties (TestParameter)

  useRefSubFunction = {
    @BatteryHV_useRefsub_Basic
    @BatteryHV_useRefsub_SystemLevelSimple
    @BatteryHV_useRefsub_SystemLevel
    @BatteryHV_useRefsub_SystemLevelTableBased
    }

  selectSimulationCaseFunction = {
    @BatteryHV_selectSimulationCase_Constant
    @BatteryHV_selectSimulationCase_Charge
    @BatteryHV_selectSimulationCase_Discharge
    @BatteryHV_selectSimulationCase_Random
    }

end  % properties

methods (Test)

function MQC_run_harness_model(~, useRefSubFunction, selectSimulationCaseFunction)
  close all
  bdclose all
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  useRefSubFunction()
  selectSimulationCaseFunction()
  sim(mdl);
  close all
  bdclose all
end  % function

function MQC_run_harness_model_1b(~)
  close all
  bdclose all
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_selectSimulationCase_Charge( ...
    CRate = -1, ...  Negative value for charge
    StateOfCharge_pct = 0 );
  sim(mdl);
  close all
  bdclose all
end  % function

function MQC_run_harness_model_1c(~)
  close all
  bdclose all
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_selectSimulationCase_Discharge( ...
    CRate = 1, ...  Positive value for discharge
    StateOfCharge_pct = 100 );
  sim(mdl);
  close all
  bdclose all
end  % function

function MQC_run_harness_model_1d(~)
  close all
  bdclose all
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_selectSimulationCase_Random( ...
    RandomSeed = 124, ...
    NumTransitions = 10, ...
    InitialSOC_pct = 60 );
  sim(mdl);
  close all
  bdclose all
end  % function

%% Testcases folder

function run_testcase_1(~)
  close all
  bdclose all
  BatteryHV_testcase_Charge
  close all
  bdclose all
end

function run_testcase_2(~)
  close all
  bdclose all
  BatteryHV_testcase_Constant
  close all
  bdclose all
end

function run_testcase_3(~)
  close all
  bdclose all
  BatteryHV_testcase_Discharge
  close all
  bdclose all
end

function run_testcase_4(~)
  close all
  bdclose all
  BatteryHV_testcase_Random
  close all
  bdclose all
end

%% Top folder

function run_main_script(~)
  close all
  bdclose all
  BatteryHV_main_script
  close all
  bdclose all
end

%% Other tests

%{
function run_takeScreenshots(~)
  close all
  bdclose all
  BatteryHV_takeScreenshots
  close all
  bdclose all
end
%}

end  % methods (Test)
end  % classdef
