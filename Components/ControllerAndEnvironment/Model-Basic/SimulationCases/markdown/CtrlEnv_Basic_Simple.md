
# <span style="color:rgb(213,80,0)">Controller and Environment \- Simulation Case</span>
```matlab
model_name = "HarnessModel_CtrlEnv";
load_system(model_name)

HarnessSetup_CtrlEnv

sim_in = Simulink.SimulationInput(model_name);

sim_in = setBlockParameter(sim_in, ...
  model_name + "/Controller and Environment/Vehicle speed reference", ...
  ReferencedSubsystem = "VehSpdRef_Simple_refsub");

sim_in = setModelParameter(sim_in, StopTime = "100");

applyToModel(sim_in)

sim_out = sim(sim_in);

sim_data = extractTimetable(sim_out.logsout);

% Specify the signal logging names in the model.
signal_names = [
  "Brake force"
  "Motor torque command"
  "Motor heat flow command"
  "Battery heat flow command"
  "Vehicle speed kph"
  "Motor speed"
  "Motor temperature"
  "Battery temperature"
  ];

for idx = 1 : numel(signal_names)
  SignalTool3.plotTimedData( TimedData = sim_data, ...
    SignalName = signal_names(idx), ...
    FigureHeight = 200 )
end  % for
```

<center><img src="media/CtrlEnv_Basic_Simple_media/figure_0.png" width="702" alt="figure_0.png"></center>


<center><img src="media/CtrlEnv_Basic_Simple_media/figure_1.png" width="702" alt="figure_1.png"></center>


<center><img src="media/CtrlEnv_Basic_Simple_media/figure_2.png" width="702" alt="figure_2.png"></center>


<center><img src="media/CtrlEnv_Basic_Simple_media/figure_3.png" width="702" alt="figure_3.png"></center>


<center><img src="media/CtrlEnv_Basic_Simple_media/figure_4.png" width="702" alt="figure_4.png"></center>


<center><img src="media/CtrlEnv_Basic_Simple_media/figure_5.png" width="702" alt="figure_5.png"></center>


<center><img src="media/CtrlEnv_Basic_Simple_media/figure_6.png" width="702" alt="figure_6.png"></center>


<center><img src="media/CtrlEnv_Basic_Simple_media/figure_7.png" width="702" alt="figure_7.png"></center>


*Copyright 2023\-2025 The MathWorks, Inc.*

