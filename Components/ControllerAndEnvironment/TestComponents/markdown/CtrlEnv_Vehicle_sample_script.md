
# <span style="color:rgb(213,80,0)">Simplistic Vehicle \- Simulation Case</span>

Note that vehicle dynamics and temperature dynamics are isolated from each other in the model, and it is intentional.

```matlab
mdl = "HarnessModel_CtrlEnv_Vehicle";
load_system(mdl)

CtrlEnv_Vehicle_params

initial.VehicleSpeed_kph = 0;

TireRollingRadius_m = 0.35;
GearRatio = 9.1;

initial.VehicleInertiaSpd_rpm = CtrlEnv_Vehicle_getMotorSpeedFromVehicleSpeed( ...
  VehicleSpeed_kph = initial.VehicleSpeed_kph, ...
  TireRollingRadius_m = TireRollingRadius_m, ...
  GearRatio = GearRatio );

initial.MotorTemperature_K = 273.15 + 70;
initial.BatteryTemperature_K = 273.15 + 50;

initial.MotorAmbientTemperature_K = 273.15 + 20;
initial.BatteryAmbientTemperature_K = initial.MotorAmbientTemperature_K;

sim_in = Simulink.SimulationInput(mdl);
sim_in = setModelParameter(sim_in, StopTime = "300");

sim_out = sim(sim_in);
sim_data = extractTimetable(sim_out.logsout);

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
  SignalUtil1.plotTimedData( TimedData = sim_data, ...
    SignalName = signal_names(idx), ...
    FigureHeight = 200 )
end  % for
```

<center><img src="media/CtrlEnv_Vehicle_sample_script_media/figure_0.png" width="702" alt="figure_0.png"></center>


<center><img src="media/CtrlEnv_Vehicle_sample_script_media/figure_1.png" width="702" alt="figure_1.png"></center>


<center><img src="media/CtrlEnv_Vehicle_sample_script_media/figure_2.png" width="702" alt="figure_2.png"></center>


<center><img src="media/CtrlEnv_Vehicle_sample_script_media/figure_3.png" width="702" alt="figure_3.png"></center>


<center><img src="media/CtrlEnv_Vehicle_sample_script_media/figure_4.png" width="702" alt="figure_4.png"></center>


<center><img src="media/CtrlEnv_Vehicle_sample_script_media/figure_5.png" width="702" alt="figure_5.png"></center>


<center><img src="media/CtrlEnv_Vehicle_sample_script_media/figure_6.png" width="702" alt="figure_6.png"></center>


<center><img src="media/CtrlEnv_Vehicle_sample_script_media/figure_7.png" width="702" alt="figure_7.png"></center>


*Copyright 2023\-2025 The MathWorks, Inc.*

