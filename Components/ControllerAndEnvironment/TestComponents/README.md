# Simplistic vehicle model for testing

The `CtrlEnv_Vehicle_refsub` model is a highly abstract model of
system-level longitudinal road vehicle, which is
intended for use in testing the Controller and Environment component.
This model is not suitable for other purposes.

The model consists of three independent submodels -
geartrain and longitudinal vehicle dynamics,
motor temperature dynamics,
and high voltage battery temperature dynamics.
Vehicle dynamics and temperature dynamics are isolated from each other.

_Copyright 2023-2025 The MathWorks, Inc._
