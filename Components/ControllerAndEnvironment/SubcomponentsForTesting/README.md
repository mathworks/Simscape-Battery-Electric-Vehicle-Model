# Simplistic vehicle model for testing

This folder contains a simplistic vehicle plant model (`CtrlEnv_Vehicle_refsub`), which is
is a highly abstract longitudinal road vehicle model designed specificially for
testing the Controller and Environment component (and not suitable for other purposes.)
This folder also contains a harness model (`HarnessModel_CtrlEnv_Vehicle`) and other resources
to test the plant model.

The plant model consists of three independent submodels -
geartrain and longitudinal vehicle dynamics,
motor temperature dynamics,
and high voltage battery temperature dynamics.
Vehicle dynamics and temperature dynamics are isolated from each other.

The plant model is used to test the Controller and Environment component
in another harness model (`HarnessModel_CtrlEnv`).

_Copyright 2023-2026 The MathWorks, Inc._
