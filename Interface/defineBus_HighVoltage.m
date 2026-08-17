%% Connection Bus Interface Definition for Simscape Bus

% Copyright 2022 The Mathworks, Inc.

Bus_HighVoltage = Simulink.ConnectionBus;
Bus_HighVoltage.Description = "Electrical plus and minus nodes";

Bus_HighVoltage.Elements(1) = Simulink.ConnectionElement;
Bus_HighVoltage.Elements(1).Name = "Plus";
Bus_HighVoltage.Elements(1).Type = "Connection: foundation.electrical.electrical";
Bus_HighVoltage.Elements(1).Description = "Electrical Port";

Bus_HighVoltage.Elements(2) = Simulink.ConnectionElement;
Bus_HighVoltage.Elements(2).Name = "Minus";
Bus_HighVoltage.Elements(2).Type = "Connection: foundation.electrical.electrical";
Bus_HighVoltage.Elements(2).Description = "Electrical Port";