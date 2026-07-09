# Input signals for testing Reducer component

This folder contains input signal subsystems `Inputs_Reducer_*_refsub` and their support files.
The input signal subsystems are used in `HarnessModel_Reducer`
to test the Reducer component.

The `BuildInputs_Reducer_*.m` files build input signal data
and optionally set up the PS Lookup Table (1D) blocks
in `Inputs_Reducer_*_refsub`.

`Inputs_Reducer_*_refsub` subsystems are tested with
the harness models `HarnessModel_Reducer_Inputs_*`.

The `setupProbe_Reducer_Inputs` script sets up
the Probe blocks' output port labels.

_Copyright 2026 The MathWorks, Inc._
