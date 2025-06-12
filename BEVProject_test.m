classdef BEVProject_test < matlab.unittest.TestCase
  %% Class implementation of unit test
  % This is class-based unit test implementation.
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  %
  % Documentation
  %
  % - Author Class-Based Unit Tests in MATLAB
  %   https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % - matlab.unittest.TestCase Class
  %   https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % - Test Browser
  %   https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    %% Minimum quality check (MQC)
    % Check that models, scripts, functions, and classes run right out of the box.

    function MQC_Description_1(testcase)
      % The source of the description page is a MATLAB script.
      % Check that it runs cleanly.
      verifyWarningFree(testcase, @() test_target())
      function test_target()
        BEVProjectDescription  % !test-target
      end  % nested function
    end  % function

    %% Other tests

    function test_Description_html_1(testcase)
      % Check that the project has the HTML version of the description page.
      all_project_files = [currentProject().Files.Path]';
      logical_index = endsWith(all_project_files, "BEVProjectDescription.html");  % !test-target
      verifyEqual(testcase, nnz(logical_index), 1)
    end  % function

  end  % methods

end  % classdef
