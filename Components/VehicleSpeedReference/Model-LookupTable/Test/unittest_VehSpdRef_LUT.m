classdef unittest_VehSpdRef_LUT < matlab.unittest.TestCase
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

    function PassingTest_Utility_1(~)
      BuildData_VehSpdRef_HighSpeed;
    end  % function

    function PassingTest_Utility_2(~)
      createPlot_VehSpdRef
    end  % function

    function PassingTest_Utility_3(~)
      VisualizeData_VehSpdRef
    end  % function

    function PassingTest_1_1(~)
      loadLUTData_VehSpdRef_zero
    end  % function

    function PassingTest_1_2(~)
      loadLUTData_VehSpdRef_Simple
    end  % function

    function PassingTest_1_3(~)
      loadLUTData_VehSpdRef_HighSpeed
    end  % function

    function PassingTest_2_1(~)
      model_name = "VehSpdRef_LookupTable_refsub";
      load_system(model_name)  % !test-target
    end  % function

    function PassingTest_2_2(~)
      model_name = "VehSpdRef_LookupTable_refsub";
      load_system(model_name)
      ClickFcnText = get_param(model_name+"/Load LUT data 1", "ClickFcn");  %!test-target
      evalin("base", ClickFcnText)
    end  % function

    function PassingTest_2_3(~)
      model_name = "VehSpdRef_LookupTable_refsub";
      load_system(model_name)
      ClickFcnText = get_param(model_name+"/Load LUT data 2", "ClickFcn");  %!test-target
      evalin("base", ClickFcnText)
    end  % function

    function PassingTest_2_4(~)
      model_name = "VehSpdRef_LookupTable_refsub";
      load_system(model_name)
      ClickFcnText = get_param(model_name+"/Load LUT data 3", "ClickFcn");  %!test-target
      evalin("base", ClickFcnText)
    end  % function

    function PassingTest_2_5(~)
      evalin("base", "loadLUTData_VehSpdRef_Simple")

      model_name = "VehSpdRef_LookupTable_refsub";
      load_system(model_name)
      ClickFcnText = get_param(model_name+"/Plot vehicle speed reference", "ClickFcn");  %!test-target
      evalin("base", ClickFcnText)
    end  % function

  end  % methods
end  % classdef
