# Motor Drive Unit - Inputs for Testing

`Inputs_MotorDriveUnit_*_refsub.mdl`

- Define input signals in a referenced subsystem for use by `HarnessModel_MotorDriveUnit.mdl`
  to test the motor drive unit.
- Tested individually with `HarnessModel_MotorDriveUnit_Inputs.mdl` and
  `unittest_MotorDriveUnit_Inputs.m`.
- Tested by `unittest_MotorDriveUnit_Inputs_settings.m` for basic settings.

`BuildInputs_MotorDriveUnit_*.m` files are Live M files where the input signals are
designed and transferred to the `Inputs_MotorDriveUnit_*_refsub.mdl` subsystem files.

_Copyright 2026 The MathWorks, Inc._
