classdef BatteryHV_InputSignalBuilder < handle
%% Class implementation of Input Signal Builder

% Copyright 2022 The MathWorks, Inc.

properties
  % Signals

  LoadCurrent timetable
  HeatFlow timetable

  % Other properties

  FunctionName (1,1) string
  StopTime (1,1) duration

  ParentFigure (1,1)  % must be of type matlab.ui.Figure
  Plot_tf (1,1) logical = false
  VisiblePlot_tf (1,1) logical = true
  FigureWidth (1,1) double = 400
  FigureHeight (1,1) double = 300
  LineWidth (1,1) double = 2

  SavePlot_tf (1,1) logical = false
  SavePlotImageFileName (1,1) {mustBeTextScalar} = "image_input_signals.png"
end

methods

  function inpObj = BatteryHV_InputSignalBuilder(nvpairs)
  %%
    arguments
      nvpairs.Plot_tf
      nvpairs.FigureWidth
      nvpairs.FigureHeight
      nvpairs.LineWidth
    end
    if isfield(nvpairs, 'Plot_tf'), inpObj.Plot_tf = nvpairs.Plot_tf; end
    if isfield(nvpairs, 'FigureWidth'), inpObj.FigureWidth = nvpairs.FigureWidth; end
    if isfield(nvpairs, 'FigureHeight'), inpObj.FigureHeight = nvpairs.FigureHeight; end
    if isfield(nvpairs, 'LineWidth'), inpObj.LineWidth = nvpairs.LineWidth; end

    % Default signals are created in the constructor so that
    % the plotSignals function works right after creating a class object.
    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;
    Constant(inpObj);
    inpObj.Plot_tf = tmp;

  end

  function plotSignals(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.ParentFigure (1,1)
    end

    syncedInputs = synchronize( ...
                      inpObj.LoadCurrent, ...
                      inpObj.HeatFlow );

    addUnitString = @(tt) ...
      string(tt.Properties.VariableNames) ...
        + " (" + string(tt.Properties.VariableUnits) + ")";

    dispLbl = { ...
      addUnitString(inpObj.LoadCurrent), ...
      addUnitString(inpObj.HeatFlow) };

    if not(inpObj.VisiblePlot_tf)
      % Invisible figure.
      inpObj.ParentFigure = figure(Visible = "off");
    elseif isfield(nvpairs, 'ParentFigure')
      % This function's ParentFigure option is specified.
      assert(isa(nvpairs.ParentFigure, 'matlab.ui.Figure'))
      inpObj.ParentFigure = nvpairs.ParentFigure;
    else
      % Create a new figure.
      inpObj.ParentFigure = figure;  % Do not use 'Visible','on'
    end

    % Show pattern name in the window title.
    inpObj.ParentFigure.Name = inpObj.FunctionName;

    stk = stackedplot( inpObj.ParentFigure, syncedInputs );
    stk.LineWidth = inpObj.LineWidth;
    stk.GridVisible = 'on';
    stk.DisplayLabels = dispLbl;
    % stackedplot does not have Interpreter=off setting for the title.
    % To prevent '_' from being interpreted as a subscript directive,
    % replace it with a space.
    % Note that title() does not work with stackedplot either.
    stk.Title = strrep(inpObj.FunctionName, '_', ' ');

    % Making the figure taller than the default plot window height can
    % make the top part of the window go outside the monitor screen.
    % To prevent it, lower the y position of the window,
    % assuming that lowering the window position is safer
    % because the visibility of the window top is more important
    % that of the window bottom.
    pos = inpObj.ParentFigure.Position;
    h_orig = pos(4);
    w = inpObj.FigureWidth;
    h_new = inpObj.FigureHeight;
    inpObj.ParentFigure.Position = [pos(1), pos(2)-(h_new-h_orig), w, h_new];

    if inpObj.SavePlot_tf
      exportgraphics(gca, inpObj.SavePlotImageFileName)
    end
  end  % function

  %% Signal Patterns

  function signalData = Constant(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.StopTime (1,1) duration = seconds(100)
      nvpairs.LoadCurrent_Const_A (1,1) double = 0
      nvpairs.HeatFlow_Const_W (1,1) double = 0
      nvpairs.InitialSOC_pct (1,1) double {mustBeInRange(nvpairs.InitialSOC_pct, 0, 100)} = 50
      nvpairs.InitialCharge_Ahr (1,1) double {mustBeNonnegative} = 10
      nvpairs.InitialTemperature_degC (1,1) double ...
        {mustBeInRange(nvpairs.InitialTemperature_degC, -50, 50)} = 20
    end

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.LoadCurrent_Const_A;
    BuildSignal_LoadCurrent(inpObj, Data=[x1 x1], Time=seconds([0 t_end]));

    x1 = nvpairs.HeatFlow_Const_W;
    BuildSignal_HeatFlow(inpObj, Data=[x1 x1], Time=seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialSOC_pct = nvpairs.InitialSOC_pct;
    signalData.Options.InitialCharge_Ahr = nvpairs.InitialCharge_Ahr;
    signalData.Options.InitialTemperature_degC = nvpairs.InitialTemperature_degC;

  end  % function

  function signalData = Charge(inpObj, nvpairs)
  %%
    arguments
      inpObj

      nvpairs.LoadCurrent_Const_A (1,1) double {mustBeNegative} = -10
      nvpairs.HeatFlow_Const_W (1,1) double = 0

      nvpairs.InitialSOC_pct (1,1) double {mustBeInRange(nvpairs.InitialSOC_pct, 0, 99)} = 0
      nvpairs.InitialCharge_Ahr (1,1) double {mustBeNonnegative} = 10
      nvpairs.InitialTemperature_degC (1,1) double ...
        {mustBeInRange(nvpairs.InitialTemperature_degC, -50, 50)} = 20

      nvpairs.StopTime (1,1) duration = seconds(500)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Constant(inpObj, ...
      StopTime = nvpairs.StopTime, ...
      InitialSOC_pct = nvpairs.InitialSOC_pct, ...
      LoadCurrent_Const_A = nvpairs.LoadCurrent_Const_A, ...
      HeatFlow_Const_W = nvpairs.HeatFlow_Const_W );

    inpObj.Plot_tf = tmp;

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialSOC_pct = nvpairs.InitialSOC_pct;
    signalData.Options.InitialCharge_Ahr = nvpairs.InitialCharge_Ahr;
    signalData.Options.InitialTemperature_degC = nvpairs.InitialTemperature_degC;

  end  % function

  function signalData = Discharge(inpObj, nvpairs)
  %%
    arguments
      inpObj

      nvpairs.LoadCurrent_Const_A (1,1) double {mustBePositive} = 10
      nvpairs.HeatFlow_Const_W (1,1) double = 0

      nvpairs.InitialSOC_pct (1,1) double {mustBeInRange(nvpairs.InitialSOC_pct, 1, 100)} = 100
      nvpairs.InitialCharge_Ahr (1,1) double {mustBeNonnegative} = 10
      nvpairs.InitialTemperature_degC (1,1) double ...
        {mustBeInRange(nvpairs.InitialTemperature_degC, -50, 50)} = 20

      nvpairs.StopTime (1,1) duration = seconds(500)
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Constant(inpObj, ...
      StopTime = nvpairs.StopTime, ...
      InitialSOC_pct = nvpairs.InitialSOC_pct, ...
      LoadCurrent_Const_A = nvpairs.LoadCurrent_Const_A, ...
      HeatFlow_Const_W = nvpairs.HeatFlow_Const_W );

    inpObj.Plot_tf = tmp;

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialSOC_pct = nvpairs.InitialSOC_pct;
    signalData.Options.InitialCharge_Ahr = nvpairs.InitialCharge_Ahr;
    signalData.Options.InitialTemperature_degC = nvpairs.InitialTemperature_degC;

  end  % function

  function signalData = LoadCurrentStep3(inpObj, nvpairs)
  %%
    arguments
      inpObj

      nvpairs.InitialSOC_pct (1,1) double {mustBeInRange(nvpairs.InitialSOC_pct, 0, 100)} = 70
      nvpairs.InitialCharge_Ahr (1,1) double {mustBeNonnegative} = 10
      nvpairs.InitialTemperature_degC (1,1) double ...
        {mustBeInRange(nvpairs.InitialTemperature_degC, -50, 50)} = 20

      nvpairs.HeatFlow_Const_W (1,1) double = 0

      nvpairs.LoadCurrent_1_A (1,1) double = 10
      nvpairs.LoadCurrent_2_A (1,1) double = -5
      nvpairs.LoadCurrent_3_A (1,1) double = 0

      nvpairs.LoadCurrentChange_1_StartTime (1,1) duration = seconds(100)
      nvpairs.LoadCurrentChange_1_EndTime (1,1) duration = seconds(100 + 1)
      nvpairs.LoadCurrentChange_2_StartTime (1,1) duration = seconds(101 + 99)
      nvpairs.LoadCurrentChange_2_EndTime (1,1) duration = seconds(200 + 1)
      nvpairs.StopTime (1,1) duration = seconds(201 + 99)
    end

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.HeatFlow_Const_W;
    BuildSignal_HeatFlow(inpObj, Data=[x1 x1], Time=seconds([0 t_end]));

    x1 = nvpairs.LoadCurrent_1_A;
    x2 = nvpairs.LoadCurrent_2_A;
    x3 = nvpairs.LoadCurrent_3_A;
    t1 = seconds(nvpairs.LoadCurrentChange_1_StartTime);
    t2 = seconds(nvpairs.LoadCurrentChange_1_EndTime);
    t3 = seconds(nvpairs.LoadCurrentChange_2_StartTime);
    t4 = seconds(nvpairs.LoadCurrentChange_2_EndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t3 )
    assert( t3 < t4 )
    assert( t4+0.01 < t_end )
    BuildSignal_LoadCurrent(inpObj, ...
      Data =         [x1 x1   x1 x2 x2      x2 x3 x3      x3], ...
      Time = seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialSOC_pct = nvpairs.InitialSOC_pct;
    signalData.Options.InitialCharge_Ahr = nvpairs.InitialCharge_Ahr;
    signalData.Options.InitialTemperature_degC = nvpairs.InitialTemperature_degC;

  end  % function

end  % methods

methods (Access = private)

  %% Build signal trace with timetable

  function inpObj = BuildSignal_LoadCurrent(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.LoadCurrent = timetable(nvpairs.Data, RowTimes=nvpairs.Time);
    inpObj.LoadCurrent.Properties.VariableNames = {'LoadCurrent'};
    inpObj.LoadCurrent.Properties.VariableUnits = {'A'};
    inpObj.LoadCurrent.Properties.VariableContinuity = {'continuous'};
    inpObj.LoadCurrent = ...
      retime(inpObj.LoadCurrent, regular="makima", TimeStep=nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_HeatFlow(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.HeatFlow = timetable(nvpairs.Data, RowTimes=nvpairs.Time);
    inpObj.HeatFlow.Properties.VariableNames = {'HeatFlow'};
    inpObj.HeatFlow.Properties.VariableUnits = {'W'};
    inpObj.HeatFlow.Properties.VariableContinuity = {'continuous'};
    inpObj.HeatFlow = ...
      retime(inpObj.HeatFlow, regular="makima", TimeStep=nvpairs.TimeStep);
  end

  function signalData = BundleSignals(inpObj)
  %%
    signalData.Signals.LoadCurrent = inpObj.LoadCurrent;
    signalData.Signals.HeatFlow = inpObj.HeatFlow;

    signalData.Bus = Simulink.Bus;
    sigs = {
      inpObj.LoadCurrent, ...
      inpObj.HeatFlow };
    for i = 1:numel(sigs)
      signalData.Bus.Elements(i) = Simulink.BusElement;
      signalData.Bus.Elements(i).Name = sigs{i}.Properties.VariableNames{1};
      signalData.Bus.Elements(i).Unit = sigs{i}.Properties.VariableUnits{1};
    end

    % Additional data to return
    opts.FunctionName = inpObj.FunctionName;
    opts.StopTime_s = seconds(inpObj.StopTime);
    opts.TimeStamp = string(datetime("now", "Format","yyyy-MM-dd HH:mm:ss"));

    if isprop(inpObj, 'ParentFigure')
      opts.ParentFigure = inpObj.ParentFigure;
    end

    signalData.Options = opts;
  end  % function

end  % methods
end  % classdef
