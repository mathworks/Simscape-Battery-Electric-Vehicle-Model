resetParams_HarnessModel_RoadGradeProfileofile < matlab.unittest.TestCase
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
      evalin("base", "resetParams_HarnessModel_CustomRoadGradeProfile")
    end  % function

    function PassingTest_Script_2(~)
      evalin("base", "setParams_HarnessModel_CustomRoadGradeProfile_1")
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
      evalin("base", "CheckPlot_RoadGradeProfile_1")
    end  % function

    function PassingTest_LiveScript_2(~)
      evalin("base", "CheckPlot_RoadGradeProfile_2")
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
      plotRoadGradeProfileBlock(model_name + "/Road Grade Profile")  % !test-target
    end  % function

    function PassingTest_HarnessModel_4(~)
      model_name = "HarnessModel_CustomRoadGradeProfile";
      load_system(model_name)
      callback_text = get_param(model_name + "/Plot elevation and grade profiles", "ClickFcn");  % !test-target
      eval(callback_text)
    end  % function

    %% Validations

%{
    function Test_1(testcase)
      evalin("base", "resetParams_HarnessModel_CustomRoadGradeProfile")
      result = sim("HarnessModel_CustomRoadGradeProfile");



    end  % function
%}

  end  % methods
end  % classdef
