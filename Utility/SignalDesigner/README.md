# Signal Designer and Signal Source Block Library

## Overview

This is a simple tool to design and use signal traces
in MATLAB and Simulink.
Designed signals can be used as inputs for simulation.
The tool is designed like an extension of
Constant block, Step block, or Ramp block in Simulink.

MATLAB API and Simulink blocks have consistent interface.
**Signal Designer** (`SignalDesigner.m`) is the tool to
programmatically design signals in MATLAB.
**Signal Source Block Library** (`SignalSourceBlockLibrary.mdl`)
provides blocks that use Signal Designer
to generate signals in Simulink.

Signal Designer and Signal Source Block Library
let you design three types of signals as follows.

- Continuous multi-step
- Continuous
- Piece-wise constant

**Continuous multi-step signal** is
a signal consisting of points or flat segments
that are smoothly connected.
This type of signal can be designed using a compact matrix form.

**Continuous signal** is
a signal consisting of smoothly connected data points,
which is a more generic representation of signals
than continuous multi-step.
Continous multi-step and Continuous can
generate the same signals.
Difference is the way you specify the signal.

**Piece-wise constant signal** is
a descrete signal consisting of flat segments
connected without smoothing.

Signal Designer also provides `SignalDesignUtility` APIs.
`SignalDesignUtility.buildTrace` function
is an extension of Signal Designer and
provides a high-level interface to
design a continuous multi-step signal.
**Trace Generator** block is the corresponding block
of `buildTrace` function.

## How to Use

To use this tool, copy the entire contents of
`SignalDesigner` folder to the folder of your choice,
set MATLAB path or Project path to it,
and open `SignalSourceBlodckLibrary.mdl` in MATLAB.

Another way to use this tool is to
include the Signal Designer project (`SignalDesigner.prj`)
in your project as MATLAB referenced project.

If you use Git,
you can include this tool in your project as
MATLAB referenced project and Git submodule.
It allows you to track the updates in
this tools' git repository and
lets you use git to update the tool
in your project repository.

_Copyright 2022-2023 The MathWorks, Inc._
