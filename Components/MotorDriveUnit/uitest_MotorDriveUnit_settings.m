classdef uitest_MotorDriveUnit_settings < matlab.uitest.TestCase
  %% Class-based unit test for app

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

    function Button_callback_opens_app_1(testcase)

      model_name = "HarnessModel_MotorDriveUnit";

      load_system(model_name)
      block_paths = string(getfullname(Simulink.findBlocksOfType(model_name, "CustomCallbackButton")));
      num_blocks = numel(block_paths);
      if num_blocks == 0

        return

      end  % if
      for ii = 1 : num_blocks
        target_block_path = block_paths(ii);
        disp("Checking: " + target_block_path)
        ClickFcn_text = string(get_param(target_block_path, "ClickFcn"));
        lines = CodeTool1.cleanupCodeText(ClickFcn_text);
        if isempty(lines)

          verifyFail(testcase, "Callback must contain code.")

        end  % if

        for jj = 1 : numel(lines)
          target_line = lines(jj);

          % Find if the line is calling an app in one of the following styles.
          %   SomeApp
          %   SomeApp(some_arguments)
          appCallPattern = lettersPattern + alphanumericsPattern + "App" + optionalPattern("(" + wildcardPattern(Except=")") + ")");
          is_target = startsWith(target_line, appCallPattern);
          if not(is_target)

            continue

          end  % if
          disp(" Command: " + target_line)

          app_name = extract(target_line, textBoundary("start") + lettersPattern + alphanumericsPattern + "App");

          app_path = string(which(app_name));  % !test-target
          verifyTrue(testcase, app_path ~= "")

          target_argument = extractBetween(target_line, "(", ")");

          if isempty(target_argument) || target_argument == ""
            testcase.App = feval(app_name);
          else
            testcase.App = feval(app_name, target_argument);
          end  % if
        end  % for
      end  % for
    end  % function

  end  % methods

end  % classdef
