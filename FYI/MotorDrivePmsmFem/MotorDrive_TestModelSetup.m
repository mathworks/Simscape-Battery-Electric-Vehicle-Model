%% Model Parameters for Motor Drive Test Harness

% Copyright 2020 The MathWorks, Inc.

MotorDrivePmsmFemParams

clear testParams
testParams.sampleTime_s = foc.sampleTime_s;
testParams.controlSampleTime_s = foc.controlSampleTime_s;
testParams.DC_V = foc.initialHighV_V;
testParams.Load_Inertia_kg_m2 = 50*0.05^2;
