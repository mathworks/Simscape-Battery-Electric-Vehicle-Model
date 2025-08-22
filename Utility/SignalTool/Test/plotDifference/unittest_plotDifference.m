classdef unittest_plotDifference < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2024-2025 The MathWorks, Inc.

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
      SignalTool2.plotDifference
    end  % function

    function PassingTest_2(~)
      data = [0, 0.1, 0.2, 0.2222, 0.223, 0.24, 0.3, 0.4, 0.5];
      SignalTool2.plotDifference(data, Title="Title", XLabel="X", XUnitText="x unit", YLabel="Y", YUnitText="y unit")
    end  % function

    function PassingTest_3(~)
      data = [0, 0.1, 0.2, 0.2222, 0.223, 0.24, 0.3, 0.4, 0.5];
      ax = axes(figure);
      SignalTool2.plotDifference(data, ParentAxes=ax)
    end  % function

    function PassingTest_4(~)
      data = [0, 0.1, 0.2, 0.2222, 0.223, 0.24, 0.3, 0.4, 0.5];
      uifig = uifigure(Name = "uifigure");
      g = uigridlayout(uifig, [1, 1]);
      p = uipanel(g);
      ax = axes(p);
      % If NewFigure=true is passed, ParentAxes option should be ignored.
      % The uifigure window must have an empty axes while the plot must be rendered in the Figures window.
      SignalTool2.plotDifference(data, ParentAxes=ax, NewFigure=true)
      delete(uifig)
    end  % function

    function PassingTest_5(~)
      data = [0, 0.1, 0.2, 0.2222, 0.223, 0.24, 0.3, 0.4, 0.5];
      uifig = uifigure(Name = "uifigure");
      g = uigridlayout(uifig, [1, 1]);
      p = uipanel(g);
      ax = axes(p);
      % If NewFigure=false is passed, ParentAxes should be used.
      SignalTool2.plotDifference(data, ParentAxes=ax, NewFigure=false)
      delete(uifig)
    end  % function

  end  % methods

end  % classdef
