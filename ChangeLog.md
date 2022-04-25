# Change Log

## Version 1.2 (2022)

MATLAB Release

- This version requires MATLAB R2022a or newer.

Project

- Files and folders are reorganized.

Models

- DAESSC solver is used.
- Simulink model files are saved in `mdl` format.
  Starting from R2021b, MDL format is based the new text format
  which is feature parity with binary SLX format.
- Longitudinal Vehicle block from Simscape Driveline is
  added as a new (and default) Referenced Subsystem.
  The previous custom block is still included too.

Testing

- GitHub Actions continuous integration is enabled
  in the GitHub repository.
