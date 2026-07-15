% Parameters for the Rotational Friction Torque app and the Rotational Friction block.

% Copyright 2025-2026 The MathWorks, Inc.

% Rotational Friction Torque app's parameters such as "Breakaway friction torque",
% "Breakaway friction velocity", etc. can refer to base workspace variables.
%
% This script creates a variable of AbstractMotorEfficiencyAppParameters, which
% provides predefined fields for the app parameters and tab-completion for edit.
% The app can also read these fields with the "Get" button all at once.
FrictionParams1 = bevutil1.app.RotationalFrictionTorque.RotationalFrictionTorqueAppParameters;

FrictionParams1.BreakawayTorque = simscape.Value(30, "N*m");
FrictionParams1.BreakawayVelocity = simscape.Value(1, "rad/s");
FrictionParams1.CoulombTorque = simscape.Value(18, "N*m");
FrictionParams1.ViscousCoefficient = simscape.Value(0.5, "N*m/(rad/s)");

% Check box parameters can take "on" or "off".
FrictionParams1.ShowStribeckTorque = "off";
FrictionParams1.ShowCoulombTorque = "off";
FrictionParams1.ShowViscousTorque = "off";

% Parameters for physical unit drop down can take a commensurate unit text.
FrictionParams1.PlotAngularVelocityUnit = "rad/s";
FrictionParams1.PlotTorqueUnit = "N*m";
