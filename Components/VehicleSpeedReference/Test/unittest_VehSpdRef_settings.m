classdef unittest_VehSpdRef_settings < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2025-2026 The MathWorks, Inc.

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

    %% Solver settings

    function solver_settings(testcase)
      load_system("HarnessModel_VehSpdRef")
      verifyTrue(testcase, get_param(gcs, "SolverType") == "Variable-step")
      verifyTrue(testcase, get_param(gcs, "SolverName") == "daessc")
    end  % function

    %% Parameter settings

    function postload_callback(testcase)
      % Check that the model calls the post-load callback (PostLoadFcn) to set up the model.
      % The callback must be post-load, not preload, because it uses gcs.
      parameter_filename = "setupHarness_VehSpdRef";  % without ".m"
      load_system("HarnessModel_VehSpdRef")
      callback_text = string(get_param(gcs, "PostLoadFcn"));
      verifyTrue(testcase, contains(callback_text, lineBoundary("start") + parameter_filename + alphanumericBoundary))
    end  % function

    %% Subsystem Reference block

    function subsystem_reference_block_settings(testcase)
      % Check the settings of the Subsystem Reference block in the specified model.

      model_name = "HarnessModel_VehSpdRef";

      load_system(model_name)

      % Unless modified, the model should have the following block as a referenced subsystem.
      %   HarnessModel_VehSpdRef/Vehicle speed reference
      refsub_blockpaths = string( getfullname( Simulink.findBlocksOfType( bdroot, ...
        "SubSystem", "ReferencedSubsystem", ".", Simulink.FindOptions("RegExp", 1))));
      num_refsub_blocks = numel(refsub_blockpaths);
      if num_refsub_blocks == 0

        return

      end  % if
      for k = 1 : num_refsub_blocks
        target_block_path = refsub_blockpaths(k);
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

    function Click_callback_1(testcase)
      model_name = "HarnessModel_VehSpdRef";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Set reference 1", "ClickFcn");

      % The callback loads the VehicleSpeedRef table in the base workspace,
      % changes the simulation stop time, and sets the referenced subsystem.
      eval(ClickFcn)  % !test-target

      % VehicleSpeedRef must exist in the base workspace and be a table.
      workspace_vars = struct2table(whos);
      logical_index = workspace_vars.name == "VehicleSpeedRef";
      verifyTrue(testcase, any(logical_index))
      verifyTrue(testcase, workspace_vars.class(logical_index) == "table")

      verifyTrue(testcase, contains(ClickFcn, "StopTime"))

      mask = Simulink.Mask.get(model_name + "/Vehicle speed reference");
      icon_code = mask.Display;

      % Check that the expected referenced subsystem was selected by the callback.
      verifyTrue(testcase, contains(icon_code, """Lookup Table"""))

      % Make sure simulation runs with the selected referenced subsystem.
      sim(model_name);
    end  % function

    function Click_callback_2(testcase)
      model_name = "HarnessModel_VehSpdRef";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Set reference 2", "ClickFcn");

      % The callback loads the VehicleSpeedRef table in the base workspace,
      % changes the simulation stop time, and sets the referenced subsystem.
      eval(ClickFcn)  % !test-target

      % VehicleSpeedRef must exist in the base workspace and be a table.
      workspace_vars = struct2table(whos);
      logical_index = workspace_vars.name == "VehicleSpeedRef";
      verifyTrue(testcase, any(logical_index))
      verifyTrue(testcase, workspace_vars.class(logical_index) == "table")

      verifyTrue(testcase, contains(ClickFcn, "StopTime"))

      mask = Simulink.Mask.get(model_name + "/Vehicle speed reference");
      icon_code = mask.Display;

      % Check that the expected referenced subsystem was selected by the callback.
      verifyTrue(testcase, contains(icon_code, """Lookup Table"""))

      % Make sure simulation runs with the selected referenced subsystem.
      sim(model_name);
    end  % function

    function Click_callback_3(testcase)
      model_name = "HarnessModel_VehSpdRef";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Set reference 3", "ClickFcn");

      % The callback loads the VehicleSpeedRef table in the base workspace,
      % changes the simulation stop time, and sets the referenced subsystem.
      eval(ClickFcn)  % !test-target

      % VehicleSpeedRef must exist in the base workspace and be a table.
      workspace_vars = struct2table(whos);
      logical_index = workspace_vars.name == "VehicleSpeedRef";
      verifyTrue(testcase, any(logical_index))
      verifyTrue(testcase, workspace_vars.class(logical_index) == "table")

      verifyTrue(testcase, contains(ClickFcn, "StopTime"))

      mask = Simulink.Mask.get(model_name + "/Vehicle speed reference");
      icon_code = mask.Display;

      % Check that the expected referenced subsystem was selected by the callback.
      verifyTrue(testcase, contains(icon_code, """Lookup Table"""))

      % Make sure simulation runs with the selected referenced subsystem.
      sim(model_name);
    end  % function

    function Click_callback_4(testcase)
      model_name = "HarnessModel_VehSpdRef";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Set reference 4", "ClickFcn");

      % The callback changes the simulation stop time, and sets the referenced subsystem.
      eval(ClickFcn)  % !test-target

      verifyTrue(testcase, contains(ClickFcn, "StopTime"))

      mask = Simulink.Mask.get(model_name + "/Vehicle speed reference");
      icon_code = mask.Display;

      % Check that the expected referenced subsystem was selected by the callback.
      verifyTrue(testcase, contains(icon_code, """FTP75"""))

      % Make sure simulation runs with the selected referenced subsystem.
      sim(model_name);
    end  % function

  end  % methods
end  % classdef
