
# <span style="color:rgb(213,80,0)">Controller and Environment \- Simulation Case</span>
```matlab
mdl = "CtrlEnv_TestModel";
load_system(mdl)
CtrlEnv_TestModelSetup
CtrlEnv_setSimCase_HighSpeed
```

```matlabTextOutput
Setting up simulation...
Simulation case: High speed driving
Setting simulation stop time to 200 sec.
Selecting simulation case 2.
```

```matlab
simOut = sim(mdl);
```

```matlab
simData = extractTimetable(simOut.logsout);
CtrlEnv_ResultsPlot( SimData = simData, ...
  FigureHeight = 200 );
```

<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_0.png" width="602" alt="figure_0.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_1.png" width="602" alt="figure_1.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_2.png" width="602" alt="figure_2.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_3.png" width="602" alt="figure_3.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_4.png" width="602" alt="figure_4.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_5.png" width="602" alt="figure_5.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_6.png" width="602" alt="figure_6.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_7.png" width="602" alt="figure_7.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_8.png" width="602" alt="figure_8.png"></center>


<center><img src="media/CtrlEnv_Basic_HighSpeed_media/figure_9.png" width="602" alt="figure_9.png"></center>


*Copyright 2023\-2025 The MathWorks, Inc.*

