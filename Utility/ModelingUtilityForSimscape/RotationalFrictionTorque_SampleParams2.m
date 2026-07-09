% Parameters for the Rotational Friction Torque app and the Rotational Friction block.

% Copyright 2026 The MathWorks, Inc.

% Rotational Friction Torque app's parameters such as "Breakaway friction torque",
% "Breakaway friction velocity", etc. can refer to base workspace variables.
%
% This script creates a variable of AbstractMotorEfficiencyAppParameters, which
% provides predefined fields for the app parameters and tab-completion for edit.
% The app can also read these fields with the "Get" button all at once.
Params.Friction2 = bev1mus.app.RotationalFrictionTorque.RotationalFrictionTorqueAppParameters;

Params.Friction2.BreakawayTorque = simscape.Value(400, "lbf*in");
Params.Friction2.BreakawayVelocity = simscape.Value(10, "rpm");
Params.Friction2.CoulombTorque = simscape.Value(300, "lbf*in");
Params.Friction2.ViscousCoefficient = simscape.Value(1, "lbf*in/rpm");

Params.Friction2.ShowStribeckTorque = "on";
Params.Friction2.ShowCoulombTorque = "on";
Params.Friction2.ShowViscousTorque = "on";

Params.Friction2.PlotAngularVelocityUnit = "rpm";
Params.Friction2.PlotTorqueUnit = "lbf*in";
