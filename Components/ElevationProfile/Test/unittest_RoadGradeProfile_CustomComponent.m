classdef unittest_RoadGradeProfile_CustomComponent < matlab.unittest.TestCase
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

    function PassingTest_1(testcase)
      %%
      target_name = "HarnessModel_RoadGradeProfile_CustomComponent";  % !test-target
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      load_system(target_name)  % !test-target
    end  % function

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

      verifyTrue(testcase, all(sim_result.("Curvilinear speed") == 1))
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

      verifyTrue(testcase, all(sim_result.("Curvilinear speed") == 1))
      verifyTrue(testcase, all(sim_result.("Grade percent") == 1))  %!test-target

      N = height(sim_result);
      verifyEqual(testcase, sim_result.("Incline angle"), 0.5729*ones(N,1), RelTol=1e-4)

      elevation = sim_result.("Elevation");
      verifyEqual(testcase, elevation(end), 99.995, RelTol=1e-4)

      hpos = sim_result.("Horizontal position");
      verifyEqual(testcase, hpos(end), 9999.5, RelTol=1e-4)

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

      verifyTrue(testcase, all(sim_result.("Curvilinear speed") == 1))
      verifyTrue(testcase, all(sim_result.("Grade percent") == 2))  %!test-target

      N = height(sim_result);
      verifyEqual(testcase, sim_result.("Incline angle"), 1.1458*ones(N,1), RelTol=1e-4)

      elevation = sim_result.("Elevation");
      verifyEqual(testcase, elevation(end), 199.96, RelTol=1e-4)

      hpos = sim_result.("Horizontal position");
      verifyEqual(testcase, hpos(end), 9998, RelTol=1e-4)

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

      verifyTrue(testcase, all(sim_result.("Curvilinear speed") == 1))
      verifyTrue(testcase, all(sim_result.("Grade percent") == 40))  %!test-target

      N = height(sim_result);
      verifyEqual(testcase, sim_result.("Incline angle"), 21.801*ones(N,1), RelTol=1e-4)

      elevation = sim_result.("Elevation");
      verifyEqual(testcase, elevation(end), 3713.9, RelTol=1e-4)

      hpos = sim_result.("Horizontal position");
      verifyEqual(testcase, hpos(end), 9284.8, RelTol=1e-4)

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
      bspace_all = matlab.lang.Workspace.baseWorkspace;
      bspace_result = variables(bspace_all, "result");
      verifyEqual(testcase, bspace_result.Class, "timetable")

      sim_result = evalin("base", "result");

      verifyTrue(testcase, all(sim_result.("Curvilinear speed") == 1))
      verifyTrue(testcase, all(sim_result.("Grade percent") == -3))  %!test-target

      N = height(sim_result);
      verifyEqual(testcase, sim_result.("Incline angle"), -1.7184*ones(N,1), RelTol=1e-4)

      elevation = sim_result.("Elevation");
      de = elevation(end) - elevation(1);
      verifyEqual(testcase, de, -299.87, RelTol=1e-4)

      hpos = sim_result.("Horizontal position");
      dx = hpos(end) - hpos(1);
      verifyEqual(testcase, dx, 9995.5, RelTol=1e-4)

    end  % function



  end  % methods
end  % classdef
