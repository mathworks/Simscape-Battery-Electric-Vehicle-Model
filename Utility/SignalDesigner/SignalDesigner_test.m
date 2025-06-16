classdef SignalDesigner_test < matlab.unittest.TestCase
  %% Class-based unit test implementation
  % https://www.mathworks.com/help/matlab/matlab_prog/class-based-unit-tests.html
  %
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2025 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

    function TestSetup(testcase)
      function close_all
        close all
        bdclose all
      end  % nested function

      close_all

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @close_all)
    end  % function

  end  % methods

  methods (Test)

    %% Minimum quality check (MQC)
    % Make sure that scripts, functions, classes, and models run right out of the box.

    function MQC_buildTrace_1(~)
      SignalDesignUtility.buildTrace
    end

    function MQC_buildXYData_2(~)
      SignalDesignUtility.buildXYData
    end

    function MQC_SignalDesigner_1(~)
      SignalDesigner
    end

    function MQC_SignalDesigner_example_1(~)
      SignalDesigner_example
    end

    %% Test with models

    function MQC_SignalDesigner_3(~)
      mdl = "SignalSourceBlocks_example";
      load_system(mdl)
      SignalSourceBlockCallback.plotContinuous(mdl + "/Continuous")
      SignalSourceBlockCallback.plotContinuousMultiStep(mdl + "/Continuous Multi-Step")
      SignalSourceBlockCallback.plotPieceWiseConstant(mdl + "/Piece-Wise Constant")
      SignalSourceBlockCallback.plotTraceGenerator(mdl + "/Trace Generator")
    end

  end  % methods

end  % classdef
