
# <span style="color:rgb(213,80,0)">BEV Controller \- Simulation Case</span>
```matlab
model_name = "BEVController_TestModel";
load_system(model_name) 
BEVController_TestModelSetup
```

```matlab
simOut = sim(model_name);
simResultTimetable = extractTimetable(simOut.logsout);
```

```matlab
fig = figure;
hold on
grid on
axis padded
fig.Position(3:4) = [700 300];  % width height

plot(simResultTimetable, "Time", "Vehicle speed input kph", LineWidth=2)
title("Input to controller: Vehicle target speed")
ylabel("km/h")
```

<center><img src="media/BEVController_Basic_TrackVehicleTargetSpeed_media/figure_0.png" width="702" alt="figure_0.png"></center>


```matlab
fig = figure;
hold on
grid on
axis padded
fig.Position(3:4) = [700 300];  % width height

plot(simResultTimetable, "Time", "Motor torque command", LineWidth=2)
title("Output from controller: Motor torque command")
ylabel("N*m")
```

<center><img src="media/BEVController_Basic_TrackVehicleTargetSpeed_media/figure_1.png" width="702" alt="figure_1.png"></center>


*Copyright 2023\-2025 The MathWorks, Inc.*

