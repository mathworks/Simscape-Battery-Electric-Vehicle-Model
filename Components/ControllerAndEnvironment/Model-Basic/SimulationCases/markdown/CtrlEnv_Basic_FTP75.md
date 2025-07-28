
# <span style="color:rgb(213,80,0)">Controller and Environment \- Simulation Case</span>
```matlab
mdl = "CtrlEnv_TestModel";
load_system(mdl)
CtrlEnv_TestModelSetup
CtrlEnv_setSimCase_FTP75
```

```matlabTextOutput
Setting up simulation...
Simulation case: FTP-75 using Drive Cycle Source block
Setting simulation stop time to 2474 sec.
Selecting simulation case 3.
```

```matlab
simOut = sim(mdl);
```

```matlab
simData = extractTimetable(simOut.logsout);

% Signal logging names in the Measurement subsystem.
sigNames = [
  "Motor torque command"
  "Vehicle speed reference kph"
  "Vehicle speed kph"
  "Motor speed reference"
  "Motor speed"
  ];

numSigs = numel(sigNames);
for i = 1 : numSigs
  fig = plotSimulationResultSignal( ...
    SimData = simData, ...
    SignalName = sigNames(i) );
  fig.Position(4) = 150;  % height
end  % for
```

<center><img src="media/CtrlEnv_Basic_FTP75_media/figure_0.png" width="702" alt="figure_0.png"></center>


<center><img src="media/CtrlEnv_Basic_FTP75_media/figure_1.png" width="702" alt="figure_1.png"></center>


<center><img src="media/CtrlEnv_Basic_FTP75_media/figure_2.png" width="702" alt="figure_2.png"></center>


<center><img src="media/CtrlEnv_Basic_FTP75_media/figure_3.png" width="702" alt="figure_3.png"></center>


<center><img src="media/CtrlEnv_Basic_FTP75_media/figure_4.png" width="702" alt="figure_4.png"></center>


*Copyright 2023 The MathWorks, Inc.*

