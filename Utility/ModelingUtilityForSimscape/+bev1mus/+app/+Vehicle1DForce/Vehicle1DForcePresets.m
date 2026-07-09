classdef Vehicle1DForcePresets

  % Copyright 2024-2026 The MathWorks, Inc.

  properties (SetAccess=immutable)
    PresetDictionary = configureDictionary("string", "bev1mus.app.Vehicle1DForce.Vehicle1DForceDataSet")
  end  % properties

  methods

    function PresetDictionary = Vehicle1DForcePresets()
      %%

      data_set = bev1mus.app.Vehicle1DForce.Vehicle1DForceDataSet;

      data_set.ModelParams.VehicleMass = simscape.Value(1100, "kg");
      data_set.ModelParams.TireRollingCoefficient = 0.013;
      data_set.ModelParams.AirDragCoefficient = 0.31;
      data_set.ModelParams.FrontalArea = simscape.Value(2.153, "m^2");
      data_set.ModelParams.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
      data_set.ModelParams.DryAirDensity = simscape.Value(1.184, "kg/m^3");
      data_set.ModelParams.RoadLoadB = simscape.Value(0, "N/(m/s)");
      data_set.ModelParams.TopSpeed = simscape.Value(140, "km/hr");
      data_set.ModelParams.MaxAcceleration = 0.4;
      data_set.ModelParams.MaxClimbGradePercent = 4;

      data_set.ModelParams = updateDerivedParameters(data_set.ModelParams);

      data_set.PlotGrades = [0, 4, 10, 30];
      data_set.PlotPowers = simscape.Value([10, 50], "kW");
      data_set.PlotSpeedUpperBound = simscape.Value(160, "km/hr");
      data_set.PlotForceUpperBound = simscape.Value(5000, "N");

      PresetDictionary.PresetDictionary("Small car") = data_set;

      % -----------------------------------------------------------------------

      data_set = bev1mus.app.Vehicle1DForce.Vehicle1DForceDataSet;

      data_set.ModelParams.VehicleMass = simscape.Value(1800, "kg");
      data_set.ModelParams.TireRollingCoefficient = 0.0136;
      data_set.ModelParams.AirDragCoefficient = 0.31;
      data_set.ModelParams.FrontalArea = simscape.Value(2.36, "m^2");
      data_set.ModelParams.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
      data_set.ModelParams.DryAirDensity = simscape.Value(1.184, "kg/m^3");
      data_set.ModelParams.RoadLoadB = simscape.Value(0, "N/(m/s)");
      data_set.ModelParams.TopSpeed = simscape.Value(160, "km/hr");
      data_set.ModelParams.MaxAcceleration = 0.42;
      data_set.ModelParams.MaxClimbGradePercent = 5;

      data_set.ModelParams = updateDerivedParameters(data_set.ModelParams);

      data_set.PlotGrades = [0, 5, 10, 20, 35];
      data_set.PlotPowers = simscape.Value([10, 50, 100], "kW");
      data_set.PlotSpeedUpperBound = simscape.Value(180, "km/hr");
      data_set.PlotForceUpperBound = simscape.Value(8000, "N");

      PresetDictionary.PresetDictionary("Medium car") = data_set;

      % -----------------------------------------------------------------------

      data_set = bev1mus.app.Vehicle1DForce.Vehicle1DForceDataSet;

      data_set.ModelParams.VehicleMass = simscape.Value(2600, "kg");
      data_set.ModelParams.TireRollingCoefficient = 0.014;
      data_set.ModelParams.AirDragCoefficient = 0.36;
      data_set.ModelParams.FrontalArea = simscape.Value(3.13, "m^2");
      data_set.ModelParams.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
      data_set.ModelParams.DryAirDensity = simscape.Value(1.184, "kg/m^3");
      data_set.ModelParams.RoadLoadB = simscape.Value(0, "N/(m/s)");
      data_set.ModelParams.TopSpeed = simscape.Value(180, "km/hr");
      data_set.ModelParams.MaxAcceleration = 0.45;
      data_set.ModelParams.MaxClimbGradePercent = 6;

      data_set.ModelParams = updateDerivedParameters(data_set.ModelParams);

      data_set.PlotGrades = [0, 6, 10, 20, 35];
      data_set.PlotPowers = simscape.Value([10, 50, 100, 150, 200], "kW");
      data_set.PlotSpeedUpperBound = simscape.Value(200, "km/hr");
      data_set.PlotForceUpperBound = simscape.Value(13000, "N");

      PresetDictionary.PresetDictionary("Large SUV") = data_set;

    end  % function

  end  % methods
end  % classdef
