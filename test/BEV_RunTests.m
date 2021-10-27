%% Script to run unit test and generate report

% Copyright 2021 The MathWorks, Inc.

%% Create test suite

import matlab.unittest.TestSuite;
s1 = TestSuite.fromClass(?BEV_UnitTest);
suite = s1;

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
  'OutputDetail', matlab.unittest.Verbosity.Detailed);

%% Set up report

% XML
%{=
runner.addPlugin( ...
  matlab.unittest.plugins.XMLPlugin.producingJUnitFormat('testResults.xml'));
%}

% PDF
%{=
runner.addPlugin( ...
  matlab.unittest.plugins.TestReportPlugin.producingPDF('testReport.pdf'));
%}

%% Run test

results = runner.run(suite);
disp(results.assertSuccess);
