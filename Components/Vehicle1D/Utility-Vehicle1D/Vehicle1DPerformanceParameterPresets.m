classdef Vehicle1DPerformanceParameterPresets

  % Copyright 2024 The MathWorks, Inc.

  properties (SetAccess=immutable)
    PresetDictionary = configureDictionary("string", "Vehicle1DPerformanceParameters")
  end  % properties

  methods

    function PresetDictionary = Vehicle1DPerformanceParameterPresets()
      %%

      data = Vehicle1DPerformanceParameters;

      data.TireRollingCoefficient = simscape.Value(0.013, "1");
      data.VehicleMass = simscape.Value(1100, "kg");
      data.AirDragCoefficient = simscape.Value(0.31, "1");
      data.FrontalArea = simscape.Value(2.153, "m^2");
      data.TopSpeed = simscape.Value(140, "km/hr");
      data.MaximumAcceleration = simscape.Value(0.4, "1");  % F = 0.4 * M * g
      data.MaximumClimbGrade = simscape.Value(5, "1");  % percent
      data = updateDerivedParameters(data);

      PresetDictionary.PresetDictionary("Small car") = data;

      % -----------------------------------------------------------------------

      data = Vehicle1DPerformanceParameters;

      data.TireRollingCoefficient = simscape.Value(0.0136, "1");
      data.VehicleMass = simscape.Value(1800, "kg");
      data.AirDragCoefficient = simscape.Value(0.31, "1");
      data.FrontalArea = simscape.Value(2.36, "m^2");
      data.TopSpeed = simscape.Value(160, "km/hr");
      data.MaximumAcceleration = simscape.Value(0.4, "1");
      data.MaximumClimbGrade = simscape.Value(5, "1");
      data = updateDerivedParameters(data);

      PresetDictionary.PresetDictionary("Medium car") = data;

      % -----------------------------------------------------------------------

      data = Vehicle1DPerformanceParameters;

      data.TireRollingCoefficient = simscape.Value(0.014, "1");
      data.VehicleMass = simscape.Value(2600, "kg");
      data.AirDragCoefficient = simscape.Value(0.36, "1");
      data.FrontalArea = simscape.Value(3.13, "m^2");
      data.TopSpeed = simscape.Value(160, "km/hr");
      data.MaximumAcceleration = simscape.Value(0.4, "1");
      data.MaximumClimbGrade = simscape.Value(5, "1");
      data = updateDerivedParameters(data);

      PresetDictionary.PresetDictionary("Large SUV") = data;

      % -----------------------------------------------------------------------

      function data = updateDerivedParameters(data)
        data = UpdateRoadLoadA(data);
        data = UpdateRoadLoadC(data);
        data = UpdateMaximumClimbPower(data);
        data = UpdateMaximumForce(data);
      end  % function
    end  % function

  end  % methods

end  % classdef
