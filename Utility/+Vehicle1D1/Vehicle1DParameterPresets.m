classdef Vehicle1DParameterPresets

  % Copyright 2024-2026 The MathWorks, Inc.

  properties (SetAccess=immutable)
    PresetDictionary = configureDictionary("string", "Vehicle1D1.Vehicle1DModelParameters")
  end  % properties

  methods

    function PresetDictionary = Vehicle1DParameterPresets()
      %%

      data = Vehicle1D1.Vehicle1DModelParameters;

      data.VehicleMass = simscape.Value(1100, "kg");
      data.TireRollingCoefficient = 0.013;
      data.AirDragCoefficient = 0.31;
      data.FrontalArea = simscape.Value(2.153, "m^2");
      data.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
      data.AirDensity = simscape.Value(1.184, "kg/m^3");
      data.RoadLoadB = simscape.Value(0, "N/(m/s)");
      data.TopSpeed = simscape.Value(140, "km/hr");
      data.MaxAcceleration = 0.4;
      data.MaxClimbGradePercent = 5;
      updateDerivedParameters(data);

      PresetDictionary.PresetDictionary("Small car") = data;

      % -----------------------------------------------------------------------

      data = Vehicle1D1.Vehicle1DModelParameters;

      data.VehicleMass = simscape.Value(1800, "kg");
      data.TireRollingCoefficient = 0.0136;
      data.AirDragCoefficient = 0.31;
      data.FrontalArea = simscape.Value(2.36, "m^2");
      data.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
      data.AirDensity = simscape.Value(1.184, "kg/m^3");
      data.RoadLoadB = simscape.Value(0, "N/(m/s)");
      data.TopSpeed = simscape.Value(160, "km/hr");
      data.MaxAcceleration = 0.4;
      data.MaxClimbGradePercent = 5;
      updateDerivedParameters(data);

      PresetDictionary.PresetDictionary("Medium car") = data;

      % -----------------------------------------------------------------------

      data = Vehicle1D1.Vehicle1DModelParameters;

      data.VehicleMass = simscape.Value(2600, "kg");
      data.TireRollingCoefficient = 0.014;
      data.AirDragCoefficient = 0.36;
      data.FrontalArea = simscape.Value(3.13, "m^2");
      data.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
      data.AirDensity = simscape.Value(1.184, "kg/m^3");
      data.RoadLoadB = simscape.Value(0, "N/(m/s)");
      data.TopSpeed = simscape.Value(160, "km/hr");
      data.MaxAcceleration = 0.4;
      data.MaxClimbGradePercent = 5;
      updateDerivedParameters(data);

      PresetDictionary.PresetDictionary("Large SUV") = data;

    end  % function

  end  % methods

end  % classdef
