classdef uitest_Reducer_Inputs < matlab.uitest.TestCase
  %% Class-based unit test for app
  % This uitest class is the App.m file.
  % There is another uitest class for the AppMain.m file and the related files.

  % Overview of App Testing Framework
  % https://www.mathworks.com/help/matlab/matlab_prog/overview-of-app-testing-framework.html
  %
  % Table of Verifications, Assertions, and Other Qualifications
  % https://www.mathworks.com/help/matlab/matlab_prog/types-of-qualifications.html

  % Copyright 2024-2025 The MathWorks, Inc.

  properties

    % Do not specify the class name for a property to hold a handle to an app.
    % For class-based test apps, the class name is the app name, making
    % it difficult to use a common teardown if the class name is specified here.
    App (1,1)

  end  % properties

  methods (TestMethodSetup)
    % Functions in the TestMethodSetup section always run before
    % each test defined in the Test section runs.

    function test_method_setup(testcase)
      %%
      function closeAll
        % Delete the app's figure object from memory.
        if class(testcase.App) ~= "double"
          if isstruct(testcase.App)
            % Function-based app
            if not(isfield(testcase.App, "Window"))
              % There is no window to close.

              return

            end  % if
            % App.Window is a struct field which does not trigger destructor.
            % Delete the figure directly.
            delete(testcase.App.Window.MainFigure)
          else
            % Class-based app
            % App.Window's destructor deletes the figure.
            delete(testcase.App.Window)
          end  % if
        end  % if
        close all
        bdclose all
      end  % nested function

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAll)

      close all
      bdclose all
    end  % function

  end  % methods

  methods (Test)
    % Functions in the Test section are the tests.
    % Before a function in this section runs, the functions defined in the TestMethodSetup section run.

    % -------------------------------------------------------------------------
    % Axle, Constant

    function check_CallbackButton_ClickFcn_code_1(testcase)
      % Check that the ClickFcn callback contains the expected code.

      model_name = "Inputs_Reducer_AxleSide_Constant_refsub";
      block_path = "Inputs_Reducer_AxleSide_Constant_refsub/Edit input torque";

      expected_code = textBoundary("start") + "SignalDesignApp(gcs + ""/Input torque"")";

      load_system(model_name)

      % The target Button block must exist.
      all_block_paths = string(getfullname(Simulink.findBlocksOfType(gcs, "CallbackButton")));
      logical_index = block_path == all_block_paths;
      verifyEqual(testcase, nnz(logical_index), 1)

      ClickFcn_code = string(get_param(block_path, "ClickFcn"));
      verifyTrue(testcase, contains(ClickFcn_code, expected_code))
    end  % function

    function call_linked_app_1(testcase)
      % Make sure that the app which is called by the Button click does work.

      model_name = "Inputs_Reducer_AxleSide_Constant_refsub";
      block_path = "Inputs_Reducer_AxleSide_Constant_refsub/Edit input torque";

      app_name = "SignalDesignApp";
      app_handle = @SignalDesignApp;

      load_system(model_name)

      ClickFcn_code = string(get_param(block_path, "ClickFcn"));

      % The ClickFcn code must contain a line calling the app.
      logical_index = contains(ClickFcn_code, textBoundary("start") + app_name + "(");
      verifyEqual(testcase, nnz(logical_index), 1);

      target_codeline = ClickFcn_code(logical_index);
      argument_text = extractBetween(target_codeline, "(", ")");
      testcase.App = app_handle(eval(argument_text));
    end  % function

    % -------------------------------------------------------------------------
    % Axle, flip

    function check_CallbackButton_ClickFcn_code_2(testcase)
      % Check that the ClickFcn callback contains the expected code.

      model_name = "Inputs_Reducer_AxleSide_Flip_refsub";
      block_path = "Inputs_Reducer_AxleSide_Flip_refsub/Edit input torque";

      expected_code = textBoundary("start") + "SignalDesignApp(gcs + ""/Input torque"")";

      load_system(model_name)

      % The target Button block must exist.
      all_block_paths = string(getfullname(Simulink.findBlocksOfType(gcs, "CallbackButton")));
      logical_index = block_path == all_block_paths;
      verifyEqual(testcase, nnz(logical_index), 1)

      ClickFcn_code = string(get_param(block_path, "ClickFcn"));
      verifyTrue(testcase, contains(ClickFcn_code, expected_code))
    end  % function

    function call_linked_app_2(testcase)
      % Make sure that the app which is called by the Button click does work.

      model_name = "Inputs_Reducer_AxleSide_Flip_refsub";
      block_path = "Inputs_Reducer_AxleSide_Flip_refsub/Edit input torque";

      app_name = "SignalDesignApp";
      app_handle = @SignalDesignApp;

      load_system(model_name)

      ClickFcn_code = string(get_param(block_path, "ClickFcn"));

      % The ClickFcn code must contain a line calling the app.
      logical_index = contains(ClickFcn_code, textBoundary("start") + app_name + "(");
      verifyEqual(testcase, nnz(logical_index), 1);

      target_codeline = ClickFcn_code(logical_index);
      argument_text = extractBetween(target_codeline, "(", ")");
      testcase.App = app_handle(eval(argument_text));
    end  % function

    % -------------------------------------------------------------------------
    % Motor, Constant

    function check_CallbackButton_ClickFcn_code_3(testcase)
      % Check that the ClickFcn callback contains the expected code.

      model_name = "Inputs_Reducer_MotorSide_Constant_refsub";
      block_path = "Inputs_Reducer_MotorSide_Constant_refsub/Edit input torque";

      expected_code = textBoundary("start") + "SignalDesignApp(gcs + ""/Input torque"")";

      load_system(model_name)

      % The target Button block must exist.
      all_block_paths = string(getfullname(Simulink.findBlocksOfType(gcs, "CallbackButton")));
      logical_index = block_path == all_block_paths;
      verifyEqual(testcase, nnz(logical_index), 1)

      ClickFcn_code = string(get_param(block_path, "ClickFcn"));
      verifyTrue(testcase, contains(ClickFcn_code, expected_code))
    end  % function

    function call_linked_app_3(testcase)
      % Make sure that the app which is called by the Button click does work.

      model_name = "Inputs_Reducer_MotorSide_Constant_refsub";
      block_path = "Inputs_Reducer_MotorSide_Constant_refsub/Edit input torque";

      app_name = "SignalDesignApp";
      app_handle = @SignalDesignApp;

      load_system(model_name)

      ClickFcn_code = string(get_param(block_path, "ClickFcn"));

      % The ClickFcn code must contain a line calling the app.
      logical_index = contains(ClickFcn_code, textBoundary("start") + app_name + "(");
      verifyEqual(testcase, nnz(logical_index), 1);

      target_codeline = ClickFcn_code(logical_index);
      argument_text = extractBetween(target_codeline, "(", ")");
      testcase.App = app_handle(eval(argument_text));
    end  % function

    % -------------------------------------------------------------------------
    % Motor, Flip

    function check_CallbackButton_ClickFcn_code_4(testcase)
      % Check that the ClickFcn callback contains the expected code.

      model_name = "Inputs_Reducer_MotorSide_Flip_refsub";
      block_path = "Inputs_Reducer_MotorSide_Flip_refsub/Edit input torque";

      expected_code = textBoundary("start") + "SignalDesignApp(gcs + ""/Input torque"")";

      load_system(model_name)

      % The target Button block must exist.
      all_block_paths = string(getfullname(Simulink.findBlocksOfType(gcs, "CallbackButton")));
      logical_index = block_path == all_block_paths;
      verifyEqual(testcase, nnz(logical_index), 1)

      ClickFcn_code = string(get_param(block_path, "ClickFcn"));
      verifyTrue(testcase, contains(ClickFcn_code, expected_code))
    end  % function

    function call_linked_app_4(testcase)
      % Make sure that the app which is called by the Button click does work.

      model_name = "Inputs_Reducer_MotorSide_Flip_refsub";
      block_path = "Inputs_Reducer_MotorSide_Flip_refsub/Edit input torque";

      app_name = "SignalDesignApp";
      app_handle = @SignalDesignApp;

      load_system(model_name)

      ClickFcn_code = string(get_param(block_path, "ClickFcn"));

      % The ClickFcn code must contain a line calling the app.
      logical_index = contains(ClickFcn_code, textBoundary("start") + app_name + "(");
      verifyEqual(testcase, nnz(logical_index), 1);

      target_codeline = ClickFcn_code(logical_index);
      argument_text = extractBetween(target_codeline, "(", ")");
      testcase.App = app_handle(eval(argument_text));
    end  % function

  end  % methods

end  % classdef
