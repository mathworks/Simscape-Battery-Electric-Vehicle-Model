classdef unittest_getTimetableFromLoggedSignal < matlab.unittest.TestCase
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

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      % This test makes sure that the test data, dataset, are properly built.
      build_dataset1();  % !test-target: This is a local function.
    end  % function

    function PassingTest_2(~)
      extractTimetable(build_dataset1());
    end  % function

    function PassingTest_3(~)
      % This test makes sure that the test data, dataset, are properly built.
      build_dataset2();  % !test-target: This is a local function.
    end  % function

    function PassingTest_4(~)
      extractTimetable(build_dataset2());
    end  % function

    function PassingTest_5(~)
      % This script does a lot. It opens a model, runs simulation, collects logged signals,
      % converts the signals to timetable using getTimetableFromLoggedSignal (!test-target),
      % and makes the plots of the signals.
      demo_getTimetableFromLoggedSignal
    end  % function

    %% Tests

    function Test_1(testcase)
      % Check that the dataset has proper contents that can be used for testing.

      expected_signal_name = "Test signal 1";
      expected_unit_text = "N*m";
      dataset = build_dataset1(expected_signal_name, expected_unit_text);

      tt = extractTimetable(dataset);

      actual_signal_name = string(tt.Properties.VariableNames);  % !test-target
      actual_unit_text = string(tt.Properties.VariableUnits);  % !test-target

      verifyEqual(testcase, actual_signal_name, expected_signal_name)
      verifyEqual(testcase, actual_unit_text, expected_unit_text)
      verifyEqual(testcase, numel(tt.Time), 3)
    end  % function

    function Test_2(testcase)
      % Check that the dataset has proper contents that can be used for testing.

      expected_signal_names = ["Test signal 1", "Test signal 2"];
      expected_unit_texts = ["N*m", "km/hr"];
      dataset = build_dataset2(expected_signal_names, expected_unit_texts);

      tt = extractTimetable(dataset);

      actual_signal_names = string(tt.Properties.VariableNames);  % !test-target
      actual_unit_texts = string(tt.Properties.VariableUnits);  % !test-target

      verifyEqual(testcase, actual_signal_names, expected_signal_names)
      verifyEqual(testcase, actual_unit_texts, expected_unit_texts)
      verifyEqual(testcase, numel(tt.Time), 3)
    end  % function

    function Test_3(testcase)
      expected_signal_name = "Test signal 1";
      expected_unit_text = "N*m";
      dataset = build_dataset1(expected_signal_name, expected_unit_text);

      signal_timetable = SignalTool3.getTimetableFromLoggedSignal(dataset);  % !test-target

      actual_signal_name = string(signal_timetable.Properties.VariableNames);
      actual_unit_texts = string(signal_timetable.Properties.VariableUnits);

      verifyEqual(testcase, actual_signal_name, expected_signal_name)
      verifyEqual(testcase, actual_unit_texts, expected_unit_text)
      verifyEqual(testcase, numel(signal_timetable.Time), 3)
    end  % function

    function Test_4(testcase)
      expected_signal_names = ["Test signal 1", "Test signal 2"];
      expected_unit_texts = ["N*m", "km/hr"];
      dataset = build_dataset2(expected_signal_names, expected_unit_texts);

      signal_timetable = SignalTool3.getTimetableFromLoggedSignal(dataset);  % !test-target

      actual_signal_names = string(signal_timetable.Properties.VariableNames);
      actual_unit_texts = string(signal_timetable.Properties.VariableUnits);

      verifyEqual(testcase, actual_signal_names, expected_signal_names)
      verifyEqual(testcase, actual_unit_texts, expected_unit_texts)
      verifyEqual(testcase, numel(signal_timetable.Time), 3)
    end  % function

  end  % methods

end  % classdef

function dataset = build_dataset1(signal_name, unit_text)
%%
arguments (Input)
  signal_name (1,1) string = "Default signal name"
  unit_text (1,1) string = "Default unit text"
end  % arguments
arguments (Output)
  dataset Simulink.SimulationData.Dataset
end  % arguments

% To define a signal name, follow these rules.
%   (1) Pass the signal name to timeseries using the Name option.
%   (2) Pass the signal name to the addElement method of a Dataset object.
%
% This function builds a dataset object and returns it which is eventually
% processed by timeseries2timetable.
% Simulink.SimulationData.Signal used below has Values and Name properties,
% and timeseries2timetable takes dataset{idx}.Values only.
% Thus, there is no need to configure Name below.

dataset = Simulink.SimulationData.Dataset;

signal_1 = Simulink.SimulationData.Signal;
signal_1.Values = timeseries([1 0 -1]', [0 1 2]', "Name", signal_name);  %#ok<check_timeseries> % rule (1)
signal_1.Values.DataInfo.Units = unit_text;

dataset = addElement(dataset, signal_1, signal_name);  % rule (2)

end  % local function

function dataset = build_dataset2(signal_names, unit_texts)
%%
arguments (Input)
  signal_names (1,2) string = ["Default signal name 1", "Default signal name 2"]
  unit_texts (1,2) string = ["Default unit text 1", "Default unit text 2"]
end  % arguments
arguments (Output)
  dataset Simulink.SimulationData.Dataset
end  % arguments

dataset = Simulink.SimulationData.Dataset;

signal_1 = Simulink.SimulationData.Signal;
signal_1.Values = timeseries([1 0 -1]', [0 1 2]', "Name", signal_names(1)); %#ok<check_timeseries>
signal_1.Values.DataInfo.Units = unit_texts(1);
dataset = addElement(dataset, signal_1, signal_names(1));

signal_2 = Simulink.SimulationData.Signal;
signal_2.Values = timeseries([5 2 4]', [0 1 2]', "Name", signal_names(2)); %#ok<check_timeseries>
signal_2.Values.DataInfo.Units = unit_texts(2);
dataset = addElement(dataset, signal_2, signal_names(2));

end  % local function
