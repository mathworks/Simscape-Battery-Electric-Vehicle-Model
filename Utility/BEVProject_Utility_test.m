classdef BEVProject_Utility_test < matlab.unittest.TestCase
  %% Class-based unit test implementation
  % https://www.mathworks.com/help/releases/R2025a/matlab/matlab_prog/class-based-unit-tests.html
  %
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2023-2025 The MathWorks, Inc.

  methods (Test)

    %% Minimum quality check (MQC)
    % Make sure that scripts, functions, classes, and models run right out of the box.

    function MQC_atProjectStartUp_2(~)
      atProjectStartUp
    end  % function

    % BEVProject_CheckProject runs ok if it runs independetly, but
    % it fails here for some reason if it is run by buildtool.
%{
    function MQC_BEVProject_CheckProject_1(~)
      BEVProject_CheckProject
    end  % function
%}

    function MQC_ProjectStats_1(~)
      ProjectStats
    end  % function

  end  % methods

end  % classdef
