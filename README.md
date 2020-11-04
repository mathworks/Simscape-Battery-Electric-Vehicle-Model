# Simscape Battery Electric Vehicle Project

Version 1

Copyright 2020 The MathWorks, Inc.

## Introduction

This is a MATLAB Project containing a Battery Electric
Vehicle (BEV) model and its components such as
motor, high voltage battery, and longitudinal vehicle.
This project demonstrates Simscape's modular and
multi-fidelity modeling technology.

The BEV model is built in a simple and modular fashion,
and it can run faster than real-time.
It is suitable as a baseline model for drive cycle simulation
to estimate vehicle's electrical efficiency and
other vehicle-level information.

This project also contains the model of a detailed
permanent magnet synchronous motor and controller.
It runs slower than real-time,
but it captures the detailed behaviors of the AC motor drive unit
and can estimate the electrical efficiency at the unit level.

A Live Script demonstrates how to obtain the electrical efficiency
from the slow but detailed motor drive unit and use the result
as the block parameter of the simple but fast motor drive block
in the BEV model.

## Tool Requirements

Supported MATLAB Version: R2020a and newer releases

Required: MATLAB, Simulink, Simscape, Simscape Driveline,
Simscape Electrical, Powertrain Blockset

Optional: Parallel Computing Toolbox

## How to Use

Open `SimscapeBatteryEV.prj` in MATLAB.
It will automatically open `MainScript.mlx`.
The script contains hyperlinks to open the models,
parameter files, and simulation driver scripts.
