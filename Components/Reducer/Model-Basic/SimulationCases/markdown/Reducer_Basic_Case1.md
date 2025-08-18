
# <span style="color:rgb(213,80,0)">Simulation with Reducer Basic model</span>

Run simulation and plot the power loss. See the `Reducer_Basic_LoggingSetup` script for how to set up Simscape selective data logging.

```matlab
model_name = "HarnessModel_Reducer";
load_system(model_name);
set_param(model_name, StopTime="100");
evalin("base", "Reducer_Basic_params")
```

Input signals. These are used in PS Lookup Table (1D) blocks in the model.

```matlab
Reducer_setInput_AxleSide_1
```

<center><img src="media/Reducer_Basic_Case1_media/figure_0.png" width="562" alt="figure_0.png"></center>


```matlab
Reducer_setInput_MotorSide_1
```

<center><img src="media/Reducer_Basic_Case1_media/figure_1.png" width="562" alt="figure_1.png"></center>


```matlab
simOut = sim(model_name);
tt = SignalTool2.getTimetableFromLoggedSignal(simOut.logsout);
```

```matlab
varnames = string(tt.Properties.VariableNames);
for idx = 1 : numel(varnames)
  SignalTool2.plotTimedData(TimedData=tt, SignalName=varnames(idx));
end  % for
```

<center><img src="media/Reducer_Basic_Case1_media/figure_2.png" width="702" alt="figure_2.png"></center>


<center><img src="media/Reducer_Basic_Case1_media/figure_3.png" width="702" alt="figure_3.png"></center>


<center><img src="media/Reducer_Basic_Case1_media/figure_4.png" width="702" alt="figure_4.png"></center>


*Copyright 2025 The MathWorks, Inc.*

