classdef test_Vehicle1D < matlab.unittest.TestCase
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

    %% Minimum Quality Check (MQC)
    % Check that scripts, functions, classes, and models run right out of the box.

    function PassingTest_1(~)
      Vehicle1D_TestModelSetup
    end  % function

    %% Up-to-date tests

    function description_html_is_uptodate(testcase)
      % Make sure the description HTML file is up to date.

      source_fullpath = FileTool1.getFileFullPath("Vehicle1D_Description.m");
      destination_fullpath = FileTool1.getFileFullPath("Vehicle1D_Description.html");

      % This test uses a conditional branch as a special case because it is practical.
      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        % The export command saves the generated file in the current working folder (pwd).
        % When this test runs, pwd is the folder where this test code file exists.
        actual_path = string(export(source_fullpath, Run=true, Format="html", HideCode=true));
        expected_path = destination_fullpath;
        verifyEqual(testcase, actual_path, expected_path)
      end  % if

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath, DisplayInfo=true);
      verifyFalse(testcase, newer)

    end  % function

  end  % methods

end  % classdef
