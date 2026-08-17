# Input signals for testing Vehicle 1D component

This folder contains resources to set up input signals to test
the Vehicle 1D component.

The model `Inputs_Vehicle1D_LookupTables_refsub` is a subsystem to generate input signals.
It has Lookup Table blocks for brake force, road grade, and axle torque signals.
The scripts `loadLUTData_*.m` load variables in the base workspace for the signals,
and the lookup table blocks use them.

The `Test` folder contains resources to test the subsystem and the scripts.

The `Utility` folder contains Live Scripts to view the input signals.

_Copyright 2026 The MathWorks, Inc._
