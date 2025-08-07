classdef test_VehSpdRef < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser (testBrowser)
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions in this section always run before each test defined in the Test section runs.

    function test_method_setup_1(testcase)
      function closeAll
        close all
        bdclose all
      end  % nested function
      closeAll
      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAll)
    end  % function

  end  % methods

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      VehSpdRef_setRefsub
    end  % function

    function PassingTest_2(~)
      VehSpdRef_setRefsub_Basic
    end  % function

    function PassingTest_3(~)
      VehSpdRef_setRefsub_Constant
    end  % function

    function PassingTest_4(~)
      VehSpdRef_setRefsub_FTP75
    end  % function

    function PassingTest_5(~)
      VehSpdRef_setRefsub_HighSpeed
    end  % function

    function PassingTest_6(~)
      VehSpdRef_setRefsub_Simple
    end  % function

    function PassingTest_7(~)
      % Test that the model opens and runs.
      mdl = "VehSpdRef_TestModel";
      load_system(mdl)
      sim(mdl);
    end  % function

  end  % methods

end  % classdef
