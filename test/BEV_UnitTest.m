classdef BEV_UnitTest < matlab.unittest.TestCase
% BEV_UnitTest implements tests that should be run both locally and in CI.

% Copyright 2021 The MathWorks, Inc.

methods (Test)

  function testMATLABVersion_20b(testCase)
    expected = "R2020b";
    actual = matlabRelease.Release;
    verifyEqual(testCase, actual, expected);
  end

  function minimalTest_BevDriveCycleModel_Basic_10s(testCase)
    mdl = "BevDriveCycleModel";
    t_end = 10;  % Simulation stop time in seconds
    if not(bdIsLoaded(mdl)), load_system(mdl); end
    in = Simulink.SimulationInput(mdl);
    in = setModelParameter(in, 'StopTime',num2str(t_end));
    sim(in);
    bdclose(mdl)
  end

end  % methods (Test)
end  % classdef
