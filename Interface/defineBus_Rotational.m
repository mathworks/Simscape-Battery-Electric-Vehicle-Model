%% Connection Bus Interface Definition for Simscape Bus

% Copyright 2022 The Mathworks, Inc.

Bus_Rotational = Simulink.ConnectionBus;
Bus_Rotational.Description = "Rotational Bus";

Bus_Rotational.Elements(1) = Simulink.ConnectionElement;
Bus_Rotational.Elements(1).Name = "AngSpd";
Bus_Rotational.Elements(1).Type = "Connection: foundation.mechanical.rotational.rotational";
Bus_Rotational.Elements(1).Description = "Angular speed";
