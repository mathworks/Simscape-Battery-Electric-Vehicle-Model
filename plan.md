# Plan

This file is not added to git.

## New in 26a

### Simscape: new energy accounting method

Transition from the `power_dissipated` variable.

In the new method, logging is not used.
Instead, a model has the "Enable energy accounting" option in
the Simscape configuration parameters, which is off by default.
Turn it on to enable energy accounting.

```matlab
sim_in = Simulink.SimulationInput(<model_name>);
sim_in = setModelParameter(sim_in, SimscapeUseEnergyAccounting = "on");
```

```matlab
set_param(<model_name>, SimscapeUseEnergyAccounting = "on")
```

Run simulation and collect the result.

```matlab
sim_out = sim(sim_in);
```

The energy accounting results are stored in the `sim_out` object.

```matlab
energy_info = getEnergyInfo(sim_out.simlog.<path>.<to>.<component>);
```
