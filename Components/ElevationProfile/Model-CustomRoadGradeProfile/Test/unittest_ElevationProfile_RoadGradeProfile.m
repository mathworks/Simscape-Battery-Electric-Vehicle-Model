classdef unittest_ElevationProfile_RoadGradeProfile < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2026 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

    function test_method_setup_1(testcase)
      %%
      % Close all before test
      close all
      bdclose all
      evalin("base", "clearvars")

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAllAfterTest)
      function closeAllAfterTest
        % Close/delete all figure windows. This closes/deletes not only the test targets but also
        % all the other figure windows too to provide clean state for the next test.
        figs = findall(0, Type="Figure");
        if not(any(isempty(figs)))
          disp("Deleting figures (" + numel(figs) + ")")
          delete(figs)
        end  % if

        bdclose all

        % Do not clear variables in the base workspace at the end of a test
        % to make it easy to debug after test if necessary.

      end  % nested function
    end  % function

  end  % methods

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before each function in this section runs, functions defined in the TestMethodSetup section run.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_Script_1(~)
      evalin("base", "resetParams_HarnessModel_RoadGradeProfile")
    end  % function

    function PassingTest_Script_2(~)
      evalin("base", "setParams_HarnessModel_RoadGradeProfile_1")
    end  % function

    function PassingTest_Script_3(~)
      evalin("base", "setParams_HarnessModel_CustomRoadGradeProfile_2")
    end  % function

    function PassingTest_Script_4(~)
      evalin("base", "setParams_HarnessModel_CustomRoadGradeProfile_3")
    end  % function

    function PassingTest_Script_5(~)
      evalin("base", "setParams_HarnessModel_CustomRoadGradeProfile_4")
    end  % function

    function PassingTest_LiveScript_1(~)
      evalin("base", "CheckPlot_RoadGradeProfile_0")
    end  % function

    function PassingTest_LiveScript_2(~)
      evalin("base", "CheckPlot_RoadGradeProfile_ResetScript")
    end  % function

    function PassingTest_LiveScript_3(~)
      evalin("base", "CheckPlot_RoadGradeProfile_Script1")
    end  % function

    function PassingTest_LiveScript_4(~)
      evalin("base", "CheckPlot_RoadGradeProfile_Script2")
    end  % function

    function PassingTest_LiveScript_5(~)
      evalin("base", "CheckPlot_RoadGradeProfile_Script3")
    end  % function

    function PassingTest_LiveScript_6(~)
      evalin("base", "CheckPlot_RoadGradeProfile_Script4")
    end  % function

    function PassingTest_LiveScript_7(~)
      evalin("base", "CheckSimulation_RoadGradeProfileBlock_1")
    end  % function

    % -------------------------------------------------------------------------

    function PassingTest_HarnessModel_1(~)
      load_system("HarnessModel_CustomRoadGradeProfile")
    end  % function

    function PassingTest_HarnessModel_2(~)
      sim("HarnessModel_CustomRoadGradeProfile");
    end  % function

    function PassingTest_HarnessModel_3(~)
      model_name = "HarnessModel_CustomRoadGradeProfile";
      load_system(model_name)
      plotRoadGradeProfileBlock(model_name + "/Road")  % !test-target
    end  % function

    function PassingTest_HarnessModel_4(~)
      model_name = "HarnessModel_CustomRoadGradeProfile";
      load_system(model_name)
      callback_text = get_param(model_name + "/Plot elevation and grade profiles", "ClickFcn");  % !test-target
      eval(callback_text)
    end  % function

    % -------------------------------------------------------------------------
    % Simulation cases

    function PassingTest_SimulationCase_1(~)
      evalin("base", "Elevation_RoadGrade_1_Constant")
    end  % function

    function PassingTest_SimulationCase_2(~)
      evalin("base", "Elevation_RoadGrade_2")
    end  % function

    % =========================================================================

    %% Validation

    function Validation_1_1(testcase)
      %%
      target_name = "Validation_RoadGradeProfile_1_1";  % !test-target
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      % Running the target script loads variables in the base workspace.
      evalin("base", target_name)

      % Check that the expected timetable variable "result" is in the base workspace.
      % variables and matlab.lang.Workspace.baseWorkspace were released in R2025a.
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.baseworkspace.html
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.variables.html
      bspace_all = matlab.lang.Workspace.baseWorkspace;
      bspace_result = variables(bspace_all, "result");
      verifyEqual(testcase, bspace_result.Class, "timetable")

      sim_result = evalin("base", "result");

      verifyTrue(testcase, all(sim_result.("Vehicle speed") == 1))
      verifyTrue(testcase, all(sim_result.("Elevation") == 0))
      verifyTrue(testcase, all(sim_result.("Grade percent") == 0))
      verifyTrue(testcase, all(sim_result.("Incline angle") == 0))

      x = sim_result.("Horizontal position");
      verifyEqual(testcase, x(end), 100, AbsTol=1e-6)

    end  % function

    function Validation_1_2(testcase)
      %%
      target_name = "Validation_RoadGradeProfile_1_2";  % !test-target
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      % Running the target script loads variables in the base workspace.
      evalin("base", target_name)

      % Check that the expected timetable variable "result" is in the base workspace.
      % variables and matlab.lang.Workspace.baseWorkspace were released in R2025a.
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.baseworkspace.html
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.variables.html
      bspace_all = matlab.lang.Workspace.baseWorkspace;
      bspace_result = variables(bspace_all, "result");
      verifyEqual(testcase, bspace_result.Class, "timetable")

      sim_result = evalin("base", "result");

      verifyTrue(testcase, all(sim_result.("Vehicle speed") == 1))
      verifyTrue(testcase, all(sim_result.("Grade percent") == 1))  %!test-target

      % Constant road grade throughout the simulation.
      N = height(sim_result);
      verifyEqual(testcase, sim_result.("Incline angle"), rad2deg(atan(0.01))*ones(N,1), RelTol=1e-4)

      % Travel distance on a straight slope.
      elevation = sim_result.("Elevation");
      hpos = sim_result.("Horizontal position");
      verifyEqual(testcase, hypot(elevation(end), hpos(end)), 10000, RelTol=1e-6)

    end  % function

    function Validation_1_3(testcase)
      %%
      target_name = "Validation_RoadGradeProfile_1_3";  % !test-target
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      % Running the target script loads variables in the base workspace.
      evalin("base", target_name)

      % Check that the expected timetable variable "result" is in the base workspace.
      % variables and matlab.lang.Workspace.baseWorkspace were released in R2025a.
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.baseworkspace.html
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.variables.html
      bspace_all = matlab.lang.Workspace.baseWorkspace;
      bspace_result = variables(bspace_all, "result");
      verifyEqual(testcase, bspace_result.Class, "timetable")

      sim_result = evalin("base", "result");

      verifyTrue(testcase, all(sim_result.("Vehicle speed") == 1))
      verifyTrue(testcase, all(sim_result.("Grade percent") == 2))  %!test-target

      % Constant road grade throughout the simulation.
      N = height(sim_result);
      verifyEqual(testcase, sim_result.("Incline angle"), rad2deg(atan(0.02))*ones(N,1), RelTol=1e-4)

      % Travel distance on a straight slope.
      elevation = sim_result.("Elevation");
      hpos = sim_result.("Horizontal position");
      verifyEqual(testcase, hypot(elevation(end), hpos(end)), 10000, RelTol=1e-6)

    end  % function

    function Validation_1_4(testcase)
      %%
      target_name = "Validation_RoadGradeProfile_1_4";  % !test-target
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      % Running the target script loads variables in the base workspace.
      evalin("base", target_name)

      % Check that the expected timetable variable "result" is in the base workspace.
      % variables and matlab.lang.Workspace.baseWorkspace were released in R2025a.
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.baseworkspace.html
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.variables.html
      bspace_all = matlab.lang.Workspace.baseWorkspace;
      bspace_result = variables(bspace_all, "result");
      verifyEqual(testcase, bspace_result.Class, "timetable")

      sim_result = evalin("base", "result");

      verifyTrue(testcase, all(sim_result.("Vehicle speed") == 1))
      verifyTrue(testcase, all(sim_result.("Grade percent") == 40))  %!test-target

      % Constant road grade throughout the simulation.
      N = height(sim_result);
      verifyEqual(testcase, sim_result.("Incline angle"), rad2deg(atan(0.4))*ones(N,1), RelTol=1e-4)

      % Travel distance on a straight slope.
      elevation = sim_result.("Elevation");
      hpos = sim_result.("Horizontal position");
      % Relative tolerance needs to be relaxed from 1e-6 when the grade is as high as 40%.
      verifyEqual(testcase, hypot(elevation(end), hpos(end)), 10000, RelTol=1e-4)

    end  % function

    function Validation_2_1(testcase)
      %%
      target_name = "Validation_RoadGradeProfile_2_1";  % !test-target
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      % Running the target script loads variables in the base workspace.
      evalin("base", target_name)

      % Check that the expected timetable variable "result" is in the base workspace.
      % variables and matlab.lang.Workspace.baseWorkspace were released in R2025a.
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.baseworkspace.html
      % https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.variables.html
      base_workspace_vars = matlab.lang.Workspace.baseWorkspace;
      bspace_result = variables(base_workspace_vars, "result");
      verifyEqual(testcase, bspace_result.Class, "timetable")

      sim_result = evalin("base", "result");

      verifyTrue(testcase, all(sim_result.("Vehicle speed") == 1))
      verifyTrue(testcase, all(sim_result.("Grade percent") == -3))  %!test-target

      % Constant road grade throughout the simulation.
      N = height(sim_result);
      verifyEqual(testcase, sim_result.("Incline angle"), rad2deg(atan(-0.03))*ones(N,1), RelTol=1e-4)

      % Travel distance.
      % Use the base workspace variables that were created in the target Live Script.
      actual = evalin("base", "actual_travel_distance_ft");
      expected = evalin("base", "expected_travel_distance_ft");
      % Relative tolerance needs to be relaxed.
      verifyEqual(testcase, actual, expected, RelTol=0.05)

    end  % function

  end  % methods
end  % classdef
