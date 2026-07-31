classdef unittest_Elevation_RoadGradeProfile_Utility < matlab.unittest.TestCase
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

    function PassingTest_1(~)
      buildElevationProfileFromRoadGradeProfileData
    end  % function

    function PassingTest_2(~)
      model_name = "HarnessModel_CustomRoadGradeProfile";
      load_system(model_name)
      buildElevationProfileFromRoadGradeProfileBlock(model_name + "/Road")  % !test-target
    end  % function

    function PassingTest_3_1(~)
      evalin("base", "CheckPlot_buildElevationProfileFromRoadGradeProfileData")
    end  % function

    function PassingTest_3_2(~)
      evalin("base", "CheckPlot_buildElevationProfileFromRoadGradeProfileData_2")
    end  % function

    function PassingTest_3_3(~)
      evalin("base", "CheckPlot_buildElevationProfileFromRoadGradeProfileBlock")
    end  % function

    function PassingTest_3_4(~)
      evalin("base", "CheckPlot_plotRoadGradeProfileBlock")
    end  % function

    function PassingTest_4(~)
      findInitialElevationFromRoadGradeProfile
    end  % function

    function PassingTest_5_1(~)
      model_name = "HarnessModel_CustomRoadGradeProfile";
      load_system(model_name)
      plotRoadGradeProfileBlock(model_name + "/Road")  % !test-target
    end  % function

    function PassingTest_5_2(~)
      model_name = "HarnessModel_CustomRoadGradeProfile";
      load_system(model_name)
      fig = plotRoadGradeProfileBlock(model_name + "/Road");  % !test-target
      fig.Name = "Test";
    end  % function

    function PassingTest_5_3(~)
      evalin("base", "setParams_HarnessModel_CustomRoadGradeProfile_2")
      model_name = "HarnessModel_CustomRoadGradeProfile";
      load_system(model_name)
      fig = plotRoadGradeProfileBlock(model_name + "/Road");  % !test-target
      fig.Name = "Test";
    end  % function

    function PassingTest_6(~)
      model_name = "HarnessModel_CustomRoadGradeProfile";
      sim(model_name);
    end  % function

    function PassingTest_7_1(~)
      plotElevationAndRoadGradeProfiles
    end  % function

    function PassingTest_7_2(~)
      fig = figure;
      plotElevationAndRoadGradeProfiles(ParentAxes=axes(fig))
    end  % function

    %% Errors

    function error_1_1(testcase)
      verifyError(testcase, @test_target, "getGradeFromElevation:VectorLengthMismatch")
      function test_target
        getGradeProfileFromElevationProfile([1 2], [1 2 3], 1)
      end  % nested function
    end  % function

    function error_1_2(testcase)
      verifyError(testcase, @test_target, "getGradeFromElevation:InvalidIntervalLength")
      function test_target
        getGradeProfileFromElevationProfile([1 2 3], [0 0 0], 3)
      end  % nested function
    end  % function

    function error_2_1(testcase)
      verifyError(testcase, @test_target, "buildElevationProfileFromRoadGradeProfileData:InvalidHorizontalDistance")
      function test_target
        buildElevationProfileFromRoadGradeProfileData([1 2])
      end  % nested function
    end  % function

    function error_2_2(testcase)
      verifyError(testcase, @test_target, "buildElevationProfileFromRoadGradeProfileData:InvalidRoadGradePercent")
      function test_target
        buildElevationProfileFromRoadGradeProfileData([0 1 2], [0 0])
      end  % nested function
    end  % function

    function error_2_3(testcase)
      verifyError(testcase, @test_target, "buildElevationProfileFromRoadGradeProfileData:VectorLengthMismatch")
      function test_target
        buildElevationProfileFromRoadGradeProfileData([0 1 2], [0 0 0 0])
      end  % nested function
    end  % function

    function error_3_1(testcase)
      verifyError(testcase, @test_target, "plotRoadGradeProfileBlock:InvalidBlockPath")
      function test_target
        plotRoadGradeProfileBlock()
      end  % nested function
    end  % function

    function error_4_1(testcase)
      verifyError(testcase, @test_target, "buildElevationProfileFromRoadGradeProfileBlock:InvalidBlockPath")
      function test_target
        buildElevationProfileFromRoadGradeProfileBlock()
      end  % nested function
    end  % function

    %% Validation

    function Validation_1_1(testcase)
      %%
      % Run the target with all defaults.
      result = buildElevationProfileFromRoadGradeProfileData;

      verifyEqual(testcase, height(result), 101)

      verifyEqual(testcase, result.x(end), 100, AbsTol=1e-6)
      verifyEqual(testcase, result.z(end), -1, AbsTol=1e-6)
      verifyEqual(testcase, result.grade(end), -1, AbsTol=1e-6)
    end  % function

    function Validation_2_1(testcase)
      %%
      % Run the target with options.
      x = [0 50 100];
      grade_pct = [1 1 1];
      left_z = 1;
      dx = 2;
      result = buildElevationProfileFromRoadGradeProfileData(x, grade_pct, "linear", left_z, dx);

      verifyEqual(testcase, height(result), 51)

      verifyEqual(testcase, result.x(end), 100, AbsTol=1e-6)
      verifyEqual(testcase, result.z(end), 2, AbsTol=1e-6)
      verifyEqual(testcase, result.grade(end), 1, AbsTol=1e-6)
    end  % function

    function Validation_2_2(testcase)
      %%
      % Run the target with options.
      x = [-100 0 100];
      grade_pct = [-1.5 -1.5 -1.5];
      left_z = 1.5;
      dx = 10;
      result = buildElevationProfileFromRoadGradeProfileData(x, grade_pct, "linear", left_z, dx);

      verifyEqual(testcase, height(result), 21)

      verifyEqual(testcase, result.x(end), 100, AbsTol=1e-6)
      verifyEqual(testcase, result.z(end), -1.5, AbsTol=1e-6)
      verifyEqual(testcase, result.grade(end), -1.5, AbsTol=1e-6)
    end  % function

    function Validation_3_1(testcase)
      %%
      % Run the target with options.
      x = [ 0 10 20,  30 40 50,  60 70 80,  90 100 110,  120 130 140 ];
      grade_pct = [ 0 0 0, 10 10 10, 0 0 0, -5 -5 -5, 0 0 0 ];
      left_z = 0;
      dx = 0.2;
      result = buildElevationProfileFromRoadGradeProfileData(x, grade_pct, "linear", left_z, dx);

      verifyEqual(testcase, height(result), 701)

      verifyEqual(testcase, result.x(end), 140, AbsTol=1e-6)
      verifyEqual(testcase, result.z(end), 1.5, AbsTol=1e-6)
      verifyEqual(testcase, result.grade(end), 0, AbsTol=1e-6)
    end  % function

    function Validation_4_1(testcase)
      %%
      % Block

      % This script loads the target model and resets the block parameters.
      % evalin("base", "resetParams_HarnessModel_CustomRoadGradeProfile")
      evalin("base", "resetParams_HarnessModel_RoadGradeProfile")

      result = buildElevationProfileFromRoadGradeProfileBlock(gcs + "/Road");

      verifyEqual(testcase, value(result.HorizontalDistance(end), "m"), 1, AbsTol=1e-6)
      verifyEqual(testcase, value(result.Elevation(end), "m"), 0, AbsTol=1e-6)
      verifyEqual(testcase, result.GradePercent(end), 0, AbsTol=1e-6)
    end  % function

    function Validation_5_1(testcase)
      %%
      el = findInitialElevationFromRoadGradeProfile;

      verifyEqual(testcase, el, 0, AbsTol=1e-6)
    end  % function

    function Validation_5_2(testcase)
      %%
      x = [ 0, 50, 100 ];
      grade_pct = [ 2 2 2 ];
      interp_method = int32(1);  % 1 for linear, 2 for smooth
      left_z = 0;
      inipos = 50;
      dx = 0.1;
      el = findInitialElevationFromRoadGradeProfile(x, grade_pct, interp_method, left_z, inipos, dx);

      verifyEqual(testcase, el, 1, AbsTol=1e-6)
    end  % function

    function Validation_5_3(testcase)
      %%
      x =         [ 0 50 100, 200 250 300, 400 450 500 ];
      grade_pct = [ 0 0 0,    1 1 1,       0 0 0 ];
      interp_method = int32(2);  % 1 for linear, 2 for smooth
      left_z = 3;
      inipos = 250;
      dx = 0.05;
      el = findInitialElevationFromRoadGradeProfile(x, grade_pct, interp_method, left_z, inipos, dx);

      verifyEqual(testcase, el, 4, AbsTol=1e-3)
    end  % function

    function Validation_6(testcase)
      %%
      x = [ 0 1 2, 3 4 5 ];
      z = [ 0 0 0, 1 1 1 ];
      dx = 0.01;

      result = getGradeProfileFromElevationProfile(x, z, dx);  % !test-target

      x_refined = result.RefinedHorizontalDistance;
      grade = result.GradePercent;
      z_refined = result.RefinedElevation;

      expected_height = (x(end) - x(1)) / dx + 1;
      verifyEqual(testcase, height(result), expected_height)

      verifyEqual(testcase, x_refined(end), 5, AbsTol=1e-6)
      verifyEqual(testcase, grade(end), 0, AbsTol=1e-6)
      verifyEqual(testcase, z_refined(end), 1, AbsTol=1e-6)
    end  % function

  end  % methods
end  % classdef
