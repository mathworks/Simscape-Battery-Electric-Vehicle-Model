
# <span style="color:rgb(213,80,0)">Vehicle Speed Reference \- Simulation Case</span>
```matlab
model_name = "HarnessModel_VehSpdRef";
load_system(model_name)

sim_in = Simulink.SimulationInput(model_name);
sim_in = setBlockParameter(sim_in, gcs + "/Vehicle speed reference", ReferencedSubsystem = "VehSpdRef_Simple_refsub");
sim_in = setModelParameter(sim_in, StopTime = "100");
applyToModel(sim_in)

sim_out = sim(sim_in);

sim_data = extractTimetable(sim_out.logsout);

SignalTool3.plotTimedData( ...
  TimedData = sim_data, ...
  SignalName = "Vehicle speed reference kph", ...
  FigureHeight = 250 )
```

<center><img src="media/VehSpdRef_Simple_sample_script_media/figure_0.png" width="702" alt="figure_0.png"></center>


*Copyright 2025 The MathWorks, Inc.*

