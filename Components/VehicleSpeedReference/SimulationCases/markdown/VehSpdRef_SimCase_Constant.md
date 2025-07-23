
# <span style="color:rgb(213,80,0)">Vehicle Speed Reference \- Simulation Case</span>
```matlab
mdl = "VehSpdRef_TestModel";
load_system(mdl)
VehSpdRef_setRefsub_Constant
```

```matlabTextOutput
Model: VehSpdRef_TestModel
Setting up referenced subsystem: VehSpdRef_Constant_refsub
```

```matlab
simOut = sim(mdl);
simData = extractTimetable(simOut.logsout);
VehSpdRef_ResultsPlot( SimData = simData );
```

<center><img src="media/VehSpdRef_SimCase_Constant_media/figure_0.png" width="602" alt="figure_0.png"></center>


*Copyright 2023\-2025 The MathWorks, Inc.*

