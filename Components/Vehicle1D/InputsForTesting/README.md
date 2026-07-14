# Vehicle 1D - Inputs for Testing

`Inputs_Vehicle1D_*_refsub.mdl`

- Used by `HarnessModel_Vehicle1D.mdl` and `HarnessModel_Vehicle1D_Inputs.mdl`.
- Defines input signals in a referenced subsystem for use by `HarnessModel_Vehicle1D.mdl`
  to test the motor drive unit.
- Tested individually with `HarnessModel_Vehicle1D_Inputs.mdl` and
  `unittest_Vehicle1D_Inputs.m`.
- Tested by `unittest_Vehicle1D_Inputs_settings.m` for basic settings.

`BuildInputs_Vehicle1D_*.m` files are Live M files where the input signals are
designed and transferred to the `Inputs_Vehicle1D_*_refsub.mdl` subsystem files.

_Copyright 2026 The MathWorks, Inc._
