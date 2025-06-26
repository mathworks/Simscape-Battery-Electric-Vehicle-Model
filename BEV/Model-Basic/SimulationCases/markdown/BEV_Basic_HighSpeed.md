
# <span style="color:rgb(213,80,0)">BEV System Model \- Simulation Case</span>
```matlab
modelName = "BEV_system_model";
load_system(modelName)
BEV_useBasic
```

```matlabTextOutput
Use Basic models for all components.
Loading parameters: Vehicle1D_refsub_Basic_params
Loading parameters: BatteryHV_refsub_Basic_params
Loading parameters: MotorDriveUnit_refsub_Basic_params
Loading parameters: Reducer_refsub_Basic_params
Loading parameters: BEVController_refsub_Basic_params
```

```matlab
VehSpdRef_loadCase_HighSpeed( ...
  ModelName = modelName, ...
  TargetSubsystemPath = "/Controller & Environment/Vehicle speed reference")
```

```matlabTextOutput
Setting up simulation...
Simulation case: High speed driving
Setting simulation stop time to 200 sec.
Selecting simulation case 2.
```

```matlab
simOut = sim(modelName);
simData = extractTimetable(simOut.logsout);
fig = BEV_ResultsCompactPlot(SimData = simData, PlotTemperature = false);
```

<center><img src="media/BEV_Basic_HighSpeed_media/figure_0.png" width="702" alt="figure_0.png"></center>


*Copyright 2023\-2025 The MathWorks, Inc.*

