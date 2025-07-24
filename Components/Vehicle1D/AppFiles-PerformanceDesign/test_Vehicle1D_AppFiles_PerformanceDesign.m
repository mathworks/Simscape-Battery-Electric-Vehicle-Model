classdef test_Vehicle1D_AppFiles_PerformanceDesign < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
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
    % Check that scripts, functions, classes, and models run right out of the box.

    function PassingTest_1(~)
      Vehicle1DPerformancePlot
    end  % function

    function PassingTest_2(~)
      Vehicle1DPerformanceParameters
    end  % function

    function PassingTest_3(~)
      Vehicle1DPerformanceParameters_sample_script
    end  % function

    function PassingTest_4(~)
      Vehicle1DPerformanceParameterPresets
    end  % function

    %% Up-to-date tests

    function markdown_is_uptodate(testcase)
      % Make sure that all Live Scripts have been converted to markdown files.
      n = FileTool1.batchGenerateMarkdowns( ...
        LiveScriptFolderNames = pwd, ...
        MarkdownFolderPath = "markdown");

      if n > 0
        n = FileTool1.batchGenerateMarkdowns( ...
          LiveScriptFolderNames = pwd, ...
          MarkdownFolderPath = "markdown", DisplayInfo = true);
      end  % if

      verifyEqual(testcase, n, 0)

    end  % function

    function plot_screenshot_is_uptodate(testcase)

      target_function = @Vehicle1DPerformancePlot;
      source_fullpath = FileTool1.getFileFullPath("Vehicle1DPerformancePlot.m");
      destination_fullpath = FileTool1.getFileFullPath("screenshot-Vehicle1D-performance-plot.png");

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        disp("Update the plot image file.")

        fig = figure;
        fig.Position(3) = 600;  % width
        fig.Position(4) = 500;  % height
        fig.Theme = "light";

        target_function(ParentAxes=axes(fig));

        exportgraphics(fig, destination_fullpath)
        delete(fig)
      end  % if

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, newer)
    end  % function

  end  % methods

end  % classdef
