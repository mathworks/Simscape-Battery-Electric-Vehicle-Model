classdef unittest_BEVController_settings < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2025 The MathWorks, Inc.

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

    %% Solver settings

    function solver_settings(testcase)
      load_system("HarnessModel_BEVController")

      s = string(get_param(gcs, "SolverType"));
      verifyEqual(testcase, s, "Variable-step")

      s = string(get_param(gcs, "SolverName"));
      verifyEqual(testcase, s, "daessc")
    end  % function

    %% Parameter settings

    function preload_parameters(testcase)
      % Check that the model loads parameters in the callback.
      parameter_filename = "HarnessSetup_BEVController";  % without ".m"
      load_system("HarnessModel_BEVController")
      callback_text = string(get_param(gcs, "PreLoadFcn"));
      verifyTrue(testcase, contains(callback_text, lineBoundary("start") + parameter_filename + alphanumericBoundary))
    end  % function

    %% Subsystem Reference block settings

    function subsystem_reference_block_settings(testcase)
      % Check the settings of the Subsystem Reference blocks in the specified model.

      model_name = "HarnessModel_BEVController";

      load_system(model_name)
      block_paths = string(getfullname(Simulink.findBlocksOfType(bdroot, "SubSystem", "ReferencedSubsystem", ".", ...
        Simulink.FindOptions("RegExp", 1))));
      num_blocks = numel(block_paths);
      if num_blocks == 0

        return

      end  % if
      for ii = 1 : num_blocks
        target_block_path = block_paths(ii);
        disp("Checking: " + target_block_path)

        % The OpenFcn callback has to have the following code.
        %   open_system(gcb, "force")
        openFcn_text = string(get_param(target_block_path, "OpenFcn"));
        target_text = lineBoundary("start") + "open_system(gcb, ""force"")";
        verifyTrue(testcase, contains(openFcn_text, target_text));

        % IO port labels must be visible, i.e.,
        % the Icon Transparency must be "Opaque with Ports". (Default is "Opaque".)
        actual = string(get_param(target_block_path, "MaskIconOpaque"));
        verifyEqual(testcase, actual, "opaque-with-ports")

      end  % for
    end  % function

    %% Button callback settings

    function Button_callback_set_referenced_subsystems_1(testcase)
      % A callback in a Button block sets referenced subsystems.
      %
      % Check if the callback uses the set_param command with ReferencedSubsystem:
      %   set_param(block_path, ReferencedSubsystem="target_refsub")
      % If yes, check that the target_refsub exists.
      %
      % One callback can be setting multiple referenced subsystems.

      model_name = "HarnessModel_BEVController";
      expected_num_blocks = 2;

      result = ModelTool2.checkRefSubInCallbackButton(model_name);
      logical_index = result.Found;
      verifyEqual(testcase, nnz(logical_index), expected_num_blocks)
      target_blocks = result(logical_index, :);
      verifyTrue(testcase, all(target_blocks.IsRefSub))
    end  % function

  end  % methods

end  % classdef
