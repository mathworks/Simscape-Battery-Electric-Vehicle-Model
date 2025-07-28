
# <span style="color:rgb(213,80,0)">BEV System Model \- Simulation Case</span>

Using constant inputs, just make sure the model loads and simulation runs.

```matlab
modelName = "BEV_system_model";
load_system(modelName)
BEV_setBasic
```

```matlabTextOutput
Use Basic models for all components.
Loading in base workspace: Vehicle1D_Basic_params
Loading in base workspace: BatteryHV_Basic_params
Loading in base workspace: MotorDriveUnit_Basic_params
Loading in base workspace: Reducer_Basic_params
Loading in base workspace: BEVController_Basic_params
```

```matlab
VehSpdRef_setSimCase_Constant( ...
  ModelName = modelName, ...
  TargetSubsystemPath = "/Controller & Environment/Vehicle speed reference")
```

```matlabTextOutput
Setting up simulation...
Simulation case: Constant
Setting simulation stop time to 1000 sec.
Selecting simulation case 4.
```

```matlab
simOut = sim(modelName);
simData = extractTimetable(simOut.logsout);
fig = BEV_ResultsCompactPlot(SimData = simData, PlotTemperature = false);
```

<center><img src="media/BEV_Basic_Constant_media/figure_0.png" width="702" alt="figure_0.png"></center>


*Copyright 2023\-2025 The MathWorks, Inc.*

