
<a id="TMP_1814"></a>

# <span style="color:rgb(213,80,0)">Profiling simulation with Reducer Basic model</span>
<!-- Begin Toc -->

## Table of Contents
&emsp;[Set up](#TMP_96fe)
 
&emsp;[Run simulation normally](#TMP_8c80)
 
&emsp;[Step size](#TMP_7dc5)
 
&emsp;[Profiling simulation](#TMP_6ea0)
 
<!-- End Toc -->

Run simulation using the Solver Profiler's `solverprofiler.profileModel` function. See the documentation about the function for details.

-  [https://www.mathworks.com/help/simulink/slref/solverprofiler.profilemodel.html](https://www.mathworks.com/help/simulink/slref/solverprofiler.profilemodel.html) 
<a id="TMP_96fe"></a>

# Set up
```matlab
model_name = "HarnessModel_Reducer";
target_folder = fullfile(currentProject().RootFolder, "Components", "Reducer", "Model-Basic", "SimulationCases");
data_fullpath = fullfile(target_folder, "profiling_data.mat");
```
<a id="TMP_8c80"></a>

# Run simulation normally
```matlab
assert(isfolder(target_folder))
load_system(model_name);

% Close the Scope window to avoid getting the screenshot.
close_system(model_name + "/Measurement/Scope")
close_system(model_name + "/Measurement/Scope input torques")

Reducer_Basic_params

sim_in = Simulink.SimulationInput(model_name);

sim_in = setBlockParameter(sim_in, model_name + "/Axle inputs", ReferencedSubsystem = "Inputs_Reducer_AxleSide_Flip_refsub");
sim_in = setBlockParameter(sim_in, model_name + "/Motor inputs", ReferencedSubsystem = "Inputs_Reducer_MotorSide_Flip_refsub");

sim_in = setModelParameter(sim_in, StopTime = "150");
```

Run simulation normally and plot results.

```matlab
sim_out = sim(sim_in);
tt = SignalUtil1.getTimetableFromLoggedSignal(sim_out.logsout);
varnames = string(tt.Properties.VariableNames);
for idx = 1 : numel(varnames)
  SignalUtil1.plotTimedData(TimedData=tt, SignalName=varnames(idx), FigureHeight=150);
end  % for
```

<center><img src="media/profileSim_Reducer_Basic_media/figure_0.png" width="702" alt="figure_0.png"></center>


<center><img src="media/profileSim_Reducer_Basic_media/figure_1.png" width="702" alt="figure_1.png"></center>


<center><img src="media/profileSim_Reducer_Basic_media/figure_2.png" width="702" alt="figure_2.png"></center>


<center><img src="media/profileSim_Reducer_Basic_media/figure_3.png" width="702" alt="figure_3.png"></center>


<center><img src="media/profileSim_Reducer_Basic_media/figure_4.png" width="702" alt="figure_4.png"></center>


<center><img src="media/profileSim_Reducer_Basic_media/figure_5.png" width="702" alt="figure_5.png"></center>


<center><img src="media/profileSim_Reducer_Basic_media/figure_6.png" width="702" alt="figure_6.png"></center>

<a id="TMP_7dc5"></a>

# Step size
```matlab
fig = figure;
fig.Position(3:4) = [800, 200];  % width, height
SignalUtil1.plotDifference(sim_out.tout, NewFigure=false, ParentAxes=axes(fig), ...
  YScale = "Log", Title="Step size", YUnitText="s", ...
  XLabel="Time", XUnitText="s" )
```

<center><img src="media/profileSim_Reducer_Basic_media/figure_7.png" width="803" alt="figure_7.png"></center>


```matlab
step_size_data = diff(sim_out.tout);
disp("Maximum step size: " + max(step_size_data))
```

```matlabTextOutput
Maximum step size: 3
```

```matlab
fprintf("Minimum step size: %e", min(step_size_data))
```

```matlabTextOutput
Minimum step size: 2.552514e-04
```

<a id="TMP_6ea0"></a>

# Profiling simulation

Run profiling simulation using the Solver Profiler.

```matlab
load_system(model_name)
result = solverprofiler.profileModel( ...
  model_name, ...
  DataFullFile = data_fullpath, ...
  OpenSP = "off", ... Set "on" to open the Solver Profiler after completing profiling.
  TimeOut = 10, ... in seconds. Stop the profiling simulation if the simulation does not make progress.
  StartTime = 0, ... Start time in seconds for profiling. Simulation starts from the model's StartTime which is usually 0.
  StopTime = 100, ... Stop time in seconds for simulation and profiling. The model's StopTime is not affected by this option.
  BufferSize = 50000, ... Maximum number of events to log.
  SaveStates = "on", ...
  SaveSimscapeStates = "on", ...
  SaveJacobian = "on", ...
  SaveZCSignals = "on" );
```

View the high\-level summary of profiling result. See the documentation for details.

-  `tStart` \- Start time in seconds for profiling. Can be different from simulation start time. 
-  `tStop` \- Stop time in seconds for profiling. Can be different from simulation stop time. 
-  `absTol` \- Absolute tolerance for the solver. 
-  `relTol` \- Relative tolerance for the solver. 
-  `hMax` \- Maximum step size. 
-  `hAverage` \- Average size of steps taken by the solver. 
-  `steps` \- Total number of time steps. 
-  `profileTime` \- Elapsed time in seconds. 
-  `zcNumber` \- Number of zero crossings detected. 
-  `resetNumber` \- Number of solver resets that occurred. 
-  `jacobianNumber` \- Number of times the solver updated the Jacobian matrix. 
-  `exceptionNumber` \- Total number of solver exceptions that occurred. 
```matlab
disp(result.summary)
```

```matlabTextOutput
             solver: 'auto(daessc)'
             tStart: 0
              tStop: 100
             absTol: 1.0000e-06
             relTol: 1.0000e-03
               hMax: 2
           hAverage: 0.6173
              steps: 162
        profileTime: 0.7517
           zcNumber: 0
        resetNumber: 1
     jacobianNumber: 26
    exceptionNumber: 62
```


Open the Solver Profiler with the saved session data.

```matlab
%solverprofiler.exploreResult(char(data_fullpath))
```

*Copyright 2025\-2026 The MathWorks, Inc.*

