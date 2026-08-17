classdef unittest_VehSpdRef_FTP75 < matlab.unittest.TestCase
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
    % Before each function in this section runs, functions defined in the TestMethodSetup section run.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      block_path = "HarnessModel_VehSpdRef/Vehicle speed reference";

      model_name = extractBefore(block_path, "/");
      load_system(model_name)

      sim_in = Simulink.SimulationInput(model_name);
      % Test only for the first 100 seconds. The full drive cycle is tested elsewhere.
      sim_in = setModelParameter(sim_in, StopTime="100");  % !test-target
      sim_in = setBlockParameter(sim_in, block_path, ReferencedSubsystem = "VehSpdRef_FTP75_refsub");  % !test-target

      sim(sim_in);  % !test-target
    end  % function

    function PassingTest_2(~)
      VisualizeData_VehSpdRef_FTP75
    end  % function

  end  % methods

end  % classdef
