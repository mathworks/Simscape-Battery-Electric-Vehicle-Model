classdef unittest_BEVProject_Utility < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2023-2025 The MathWorks, Inc.

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

    %% Minimum quality check
    % Make sure that scripts, functions, classes, and models run right out of the box.

    function PassingTest_1(~)
      atProjectStartUp
    end  % function

    function PassingTest_2(~)
      BEVProject_CheckProject
    end  % function

    function PassingTest_3(~)
      ProjectStats
    end  % function

    %% Project's initial Live Script

    function project_initial_live_script_1(testcase)
      target_file = "BEVProject_Description.m";

      % Make sure that the target file is not open. Close it if it is.
      docs_in_editor = matlab.desktop.editor.getAll;
      logical_index = endsWith(string({docs_in_editor.Filename}'), target_file);
      if nnz(logical_index) == 1
        close(docs_in_editor(logical_index))
      end  % if
      verifyTrue(testcase, nnz(logical_index) == 0)

      % This must open the intended Live Script in the Editor.
      openInProject

      % Find the target Live Script in the Editor and close it.
      docs_in_editor = matlab.desktop.editor.getAll;
      logical_index = endsWith(string({docs_in_editor.Filename}'), target_file);
      verifyTrue(testcase, nnz(logical_index) == 1)
      close(docs_in_editor(logical_index))
    end  % function

  end  % methods

end  % classdef
