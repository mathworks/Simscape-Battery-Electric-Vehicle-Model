classdef BEV_UnitTest_MQC < matlab.unittest.TestCase
  %% Class-based unit test implementation
  % https://www.mathworks.com/help/releases/R2025a/matlab/matlab_prog/class-based-unit-tests.html
  %
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2022-2025 The MathWorks, Inc.

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

    %% Top folder

    function MQC_TopFolder_1(~)
      BEV_main_script
    end

    function MQC_TopFolder_2(~)
      mdl = "BEV_system_model";
      load_system(mdl)
      BEV_setup
    end

    function MQC_TopFolder_3(~)
      mdl = "BEV_system_model";
      load_system(mdl)
      sim(mdl);
    end

    %% SimlationCases folder

    function MQC_SimulationCases_1_1(~)
      BEV_Case_Constant_Basic
    end

    function MQC_SimulationCases_1_2(~)
      BEV_Case_FTP75_Basic
    end

    function MQC_SimulationCases_1_3(~)
      BEV_Case_HighSpeed_Basic
    end

    function MQC_SimulationCases_1_4(~)
      BEV_Case_SimpleDrivePattern_Basic
    end

    function MQC_SimulationCases_2_1(~)
      BEV_Case_Constant_Thermal
    end

    function MQC_SimulationCases_2_2(~)
      BEV_Case_SimpleDrivePattern_Thermal
    end

    %% Utility > Configuration folder

    function MQC_Configuration_1(~)
      load_system("BEV_system_model")
      BEV_useComponents_Basic
    end

    function MQC_Configuration_2(~)
      load_system("BEV_system_model")
      BEV_useComponents_Thermal
    end

    %% Utility folder

    function MQC_Utility_1(~)
      BEV_getMotorSpeedFromVehicleSpeed
    end

    function MQC_Utility_2(~)
      mdl = "BEV_system_model";
      load_system(mdl)
      simOut = sim(mdl);
      simData = extractTimetable(simOut.logsout);
      % Test target
      BEV_plotResultsCompact(SimData = simData);
    end

  end  % methods (Test)

  %% Test callback buttons

  properties
    FilesAndFolders {mustBeText} = ""
  end

  methods (TestClassSetup)

    function buildFilesFoldersList(testCase)
      %%
      projectFiles = [currentProject().Files.Path]';
      % logical index
      lix = not(contains(projectFiles, [".git", "resources", "simcache"]));
      testCase.FilesAndFolders = projectFiles(lix);
    end  % function

  end  % methods

  methods (Test)

    function MQC_CallbackButtons_1(testCase)
      mdl = "BEV_system_model";
      load_system(mdl)
      checkCallbackButton(mdl, testCase.FilesAndFolders)
    end

  end  % methods

end  % classdef
