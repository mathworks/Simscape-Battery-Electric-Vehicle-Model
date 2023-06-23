%% Model Parameters for Motor Drive Model

% Copyright 2020 The MathWorks, Inc.

PmsmFemParams

%% PMSM Controller Subsystem

clear foc
foc.initialHighV_V = 500;

%% Model Parameters for PMSM Field-Oriented Controller

clear tmp

% Control parameters
tmp.Ts = 2e-6;  % Fundamental sample time 
tmp.fsw = 2e3;  % Switching frequency (Hz) 
tmp.fc = tmp.fsw*10;  % Control loop frequency (Hz)  
tmp.Tsc = 1/tmp.fc;  % Control loop sample time

% PMSM parameters 
tmp.PM = 0.1447;  % Permanent magnet flux linkage 
tmp.Ld =0.0012975;  % H d-axis inductance  -
tmp.Lq = 0.00393;  % H q-axis inductance
tmp.N = 4;  % Number of pole pairs

% Operating and derived limits
tmp.iq_max = 249.8477;  % current component on the Q-axis
tmp.id_max = 8.7249;  % current component on the D-axis

tmp.Tmax = 1.5*(tmp.N*tmp.PM*tmp.iq_max+(tmp.Ld - tmp.Lq)*tmp.id_max*tmp.iq_max);
  % Max electromagnetic torque

% General

  % Control mode: Velocity control

  % Nominal dc-link voltage (V)
  foc.nominalDC_V = foc.initialHighV_V;
  
  % Maximum power (W)
  foc.maxPower_W = 60000;
  
  % Maximum torque (N*m)
  foc.maxTrq_Nm = tmp.Tmax;
  
  % Number of rotor pole pairs
  foc.numPolePairs = tmp.N;
  
  % Inverter dc-link voltage threshold (V)
  foc.DCthresh_V = 10;
  
  % Fundamental sample time (s)
  foc.sampleTime_s = tmp.Ts;
  
  % Control sample time (s)
  foc.controlSampleTime_s = tmp.Tsc;

% Outer Loop
  
  % Permanent magnet flux linkage (Wb)
  foc.PM_Wb = tmp.PM;

% Inner Loop
  
  % D-axis inductance for feed-forward pre-control (H)
  foc.Ld_H = tmp.Ld;
  
  % Q-axis inductance for feed-forward pre-control (H)
  foc.Lq_H = tmp.Lq;
  
  % Permanent magnet flux linkage for feed-forward pre-control (Wb)
  foc.PM_Wb = tmp.PM;

% PWM
  
  % Switching frequency (Hz)
  foc.fsw_Hz = tmp.fsw;

clear tmp
