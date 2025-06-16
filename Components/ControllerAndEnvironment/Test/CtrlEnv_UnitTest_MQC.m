classdef CtrlEnv_UnitTest_MQC < matlab.unittest.TestCase
  %% Class-based unit test implementation
  % https://www.mathworks.com/help/releases/R2025a/matlab/matlab_prog/class-based-unit-tests.html
  %
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2023-2025 The MathWorks, Inc.

  methods(TestMethodSetup)
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

    %% Harness folder

    function MQC_Harness_1(~)
      mdl = "CtrlEnv_harness_model";
      load_system(mdl)
      sim(mdl);
    end

    function MQC_Harness_2(~)
      CtrlEnv_harness_setup
    end

    %% SimulationCases folder

    function MQC_SimulationCase_1(~)
      CtrlEnv_Case_Constant
    end

    function MQC_SimulationCase_2(~)
      CtrlEnv_Case_FTP75
    end

    function MQC_SimulationCase_3(~)
      CtrlEnv_Case_HighSpeed
    end

    function MQC_SimulationCase_4(~)
      CtrlEnv_Case_SimpleDrivePattern
    end

    %% Utility > Configuration folder

    function MQC_Configuration_1(~)
      load_system("CtrlEnv_harness_model")
      CtrlEnv_loadCase
    end

    function MQC_Configuration_2(~)
      load_system("CtrlEnv_harness_model")
      CtrlEnv_loadCase_Constant
    end

    function MQC_Configuration_3(~)
      load_system("CtrlEnv_harness_model")
      CtrlEnv_loadCase_FTP75
    end

    function MQC_Configuration_4(~)
      load_system("CtrlEnv_harness_model")
      CtrlEnv_loadCase_HighSpeed
    end

    function MQC_Configuration_5(~)
      load_system("CtrlEnv_harness_model")
      CtrlEnv_loadCase_SimpleDrivePattern
    end

    %% Utility folder

    function MQC_Utility_1(~)
      mdl = "CtrlEnv_harness_model";
      load_system(mdl)
      simOut = sim(mdl);
      simData = extractTimetable(simOut.logsout);
      CtrlEnv_plotResults( SimData = simData );
    end

  end  % methods (Test)

  %% Test callback buttons

  properties
    FilesAndFolders {mustBeText} = ""
  end

  methods (TestClassSetup)
    function buildFilesFoldersList(testCase)
      projectFiles = [currentProject().Files.Path]';
      folderChar = characterListPattern("/\");
      ptn = "Components" + folderChar + "ControllerAndEnvironment" + folderChar;
      % logical index
      lix = contains(projectFiles, ptn);
      testCase.FilesAndFolders = projectFiles(lix);
    end  % function
  end  % methods

  methods (Test)
    function MQC_CallbackButtons_1(testCase)
      mdl = "CtrlEnv_harness_model";
      load_system(mdl)
      checkCallbackButton(mdl, testCase.FilesAndFolders)
    end  % function
  end  % methods

end  % classdef
