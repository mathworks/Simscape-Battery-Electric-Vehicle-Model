# Interface definitions

This folder contains MATLAB script files
defining [Connection Bus Object][url-connection-bus]
for [Simscape Bus blocks][url-simscape-bus].

The use of connection bus object in Simscape Bus blocks
makes the interface definitions of physical components
more robust and scalable.

For more information about Connection Bus,
see the documentation:

- [Design Rigid Interface Specifications for Conserving Connections][url-connection-bus-design].

## Tips for using connection bus objects

> Load connection bus definition objects in the base workspace before
> loading the model that uses them.

To automatically load connection bus objects when opening a model,
use the `PreLoadFcn` property of the model.
`PostLoadFcn` is less suitable for this purpose because
it is executed after the model is loaded.

```matlab
% If the model is already loaded or opened,
% use gcs to get current system/model name.
% Alternatively, specify the model name directly.
model_name = gcs;

% To set the property
set_param(model_name, "PreLoadFcn", ...
  "defineBus_Rotational" + newline + ...
  "defineBus_HighVoltage" + newline)

% To get the property
get_param(model_name, "PreLoadFcn")
```

You can also edit the `PreLoadFcn` in the Property Inspector of the model.

[url-connection-bus]: https://www.mathworks.com/help/simulink/slref/simulink.connectionbus.html

[url-simscape-bus]: https://www.mathworks.com/help/simscape/ref/simscapebus.html

[url-connection-bus-design]: https://www.mathworks.com/help/simscape/ug/design-rigid-interface-specifications-for-conserving-connections.html

_Copyright 2023-2025 The MathWorks, Inc._
