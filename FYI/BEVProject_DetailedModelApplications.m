%[text] # BEV Project Detailed Model Applications
%[text] ## Permanent Magnet Synchronous Motor (PMSM)
%[text] #### 3-Phase PMSM and Field Oriented Control (FOC)
%[text] In the BEV system model, an abstract motor block is used for fast simulation, but the block needs electrical loss data in its parameters. To obtain the loss data, a more detailed AC 3-phase synchronous motor and FOC controller are used.
%[text] - [Open](matlab:MotorDrive_testHarness) the PMSM+FOC test harness model.
%[text] - [Open](<matlab:edit MotorDrive_testParams>) the script containing test harness parameters.
%[text] - [Open](<matlab:edit MotorDrivePmsmFemParams>) the script containing model parameters.
%[text] - [Open](<matlab:edit MotorDrive_runSim>) the script to run simulation.
%[text] - [Open](<matlab:edit MotorDrive_calcElectricEfficiency.m>) the script to obtain electrical efficiency data. \
%[text] ### Synchronous Motor
%[text] The PMSM model used above is parameterized based on the magnetic field data, which was imported from an electromagnetic system design tool to FEM-Parameterized PMSM block in Simscape Electrical.
%[text] - [Open](matlab:PmsmFem_testHarness) the motor model.
%[text] - [Open](<matlab:edit PmsmFemParams>) the script containing model parameters. \
%[text] *Copyright 2020-2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
