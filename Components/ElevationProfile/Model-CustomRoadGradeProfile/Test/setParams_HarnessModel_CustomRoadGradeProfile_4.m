% Copyright 2026 The MathWorks, Inc.

model_name = "HarnessModel_CustomRoadGradeProfile";
load_system(model_name)
sim_in = Simulink.SimulationInput(model_name);

% -----------------------------------------------------------------------------
block_path = model_name + "/Curvilinear Speed";

sim_in = setBlockParameter(sim_in, block_path, constant = "1");
sim_in = setBlockParameter(sim_in, block_path, constant_unit = "m/s");

% -----------------------------------------------------------------------------
block_path = model_name + "/Road";

% Horizontal distance for vertical profile
sim_in = setBlockParameter(sim_in, block_path, x_vector = "[ 0 50 100, 200 250 300, 400 450 500, 600 650 700, 800 850 900 ]");
sim_in = setBlockParameter(sim_in, block_path, x_vector_unit = "m");

% Road grade profile (percent)
sim_in = setBlockParameter(sim_in, block_path, grade_vector = "[ 0 0 0, 5 5 5, 0 0 0, -2 -2 -2, 0 0 0 ]");

% Profile interpolation method
sim_in = setBlockParameter(sim_in, block_path, profile_interp_method = "simscape.enum.interpolation.smooth");

% Elevation at left most horizontal position
sim_in = setBlockParameter(sim_in, block_path, left_elevation = "0");
sim_in = setBlockParameter(sim_in, block_path, left_elevation_unit = "m");

% Initial horizontal position
sim_in = setBlockParameter(sim_in, block_path, initial_position = "0");
sim_in = setBlockParameter(sim_in, block_path, initial_position_unit = "m");

% -----------------------------------------------------------------------------
sim_in = setModelParameter(sim_in, StopTime = "900");
applyToModel(sim_in)
