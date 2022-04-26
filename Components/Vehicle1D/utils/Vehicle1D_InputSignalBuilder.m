classdef Vehicle1D_InputSignalBuilder < handle
%% Class implementation of Input Signal Builder

% Copyright 2022 The MathWorks, Inc.

properties
  % Signals

  AxleTrq timetable
  BrakeForce timetable
  RoadGrade timetable

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

  function inpObj = Vehicle1D_InputSignalBuilder(nvpairs)
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
                      inpObj.AxleTrq, ...
                      inpObj.BrakeForce, ...
                      inpObj.RoadGrade );

    addUnitString = @(tt) ...
      string(tt.Properties.VariableNames) ...
        + " (" + string(tt.Properties.VariableUnits) + ")";

    dispLbl = { ...
      addUnitString(inpObj.AxleTrq), ...
      addUnitString(inpObj.BrakeForce), ...
      addUnitString(inpObj.RoadGrade) };

    if not(inpObj.VisiblePlot_tf)
      % Invisible figure.
      inpObj.ParentFigure = figure('Visible', 'off');
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
      nvpairs.StopTime (1,1) duration = seconds(600)
      nvpairs.AxleTorque_Const_Nm (1,1) {mustBeNonnegative} = 10
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0
      nvpairs.InitialVehicleSpeed_kph (1,1) double = 0
    end

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.AxleTorque_Const_Nm;
    BuildSignal_AxleTorque(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.BrakeForce_Const_N;
    BuildSignal_BrakeForce(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.RoadGrade_Const_pct;
    BuildSignal_RoadGrade(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialVehicleSpeed_kph = nvpairs.InitialVehicleSpeed_kph;

  end  % function

  function signalData = Coastdown(inpObj, nvpairs)
  %%
    arguments
      inpObj

      nvpairs.InitialVehicleSpeed_kph (1,1) double = 100

      nvpairs.StopTime (1,1) duration = seconds(500)
      nvpairs.AxleTorque_Const_Nm (1,1) {mustBeNonnegative} = 0
      nvpairs.BrakeForce_Const_N (1,1) {mustBeNonnegative} = 0
      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 0
    end

    tmp = inpObj.Plot_tf;
    inpObj.Plot_tf = false;

    Constant(inpObj, ...
      StopTime = nvpairs.StopTime, ...
      InitialVehicleSpeed_kph = nvpairs.InitialVehicleSpeed_kph, ...
      AxleTorque_Const_Nm = nvpairs.AxleTorque_Const_Nm, ...
      BrakeForce_Const_N = nvpairs.BrakeForce_Const_N, ...
      RoadGrade_Const_pct = nvpairs.RoadGrade_Const_pct );

    inpObj.Plot_tf = tmp;

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialVehicleSpeed_kph = nvpairs.InitialVehicleSpeed_kph;

  end  % function

  function signalData = Brake3(inpObj, nvpairs)
  %%
    arguments
      inpObj

      nvpairs.InitialVehicleSpeed_kph (1,1) double = 0

      nvpairs.BrakeForce_1_N (1,1) {mustBeNonnegative} = 7000
      nvpairs.BrakeForce_2_N (1,1) {mustBeNonnegative} = 2000
      nvpairs.BrakeForce_3_N (1,1) {mustBeNonnegative} = 0

      nvpairs.BrakeChange_1_StartTime (1,1) duration = seconds(10)
      nvpairs.BrakeChange_1_EndTime (1,1) duration = seconds(10 + 1)
      nvpairs.BrakeChange_2_StartTime (1,1) duration = seconds(11 + 9)
      nvpairs.BrakeChange_2_EndTime (1,1) duration = seconds(20 + 1)
      nvpairs.StopTime (1,1) duration = seconds(31 + 9)

      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = -30

      nvpairs.AxleTorque_Const_Nm (1,1) {mustBeNonnegative} = 0
    end

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.AxleTorque_Const_Nm;
    BuildSignal_AxleTorque(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.BrakeForce_1_N;
    x2 = nvpairs.BrakeForce_2_N;
    x3 = nvpairs.BrakeForce_3_N;
    t1 = seconds(nvpairs.BrakeChange_1_StartTime);
    t2 = seconds(nvpairs.BrakeChange_1_EndTime);
    t3 = seconds(nvpairs.BrakeChange_2_StartTime);
    t4 = seconds(nvpairs.BrakeChange_2_EndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t3 )
    assert( t3 < t4 )
    assert( t4+0.01 < t_end )
    BuildSignal_BrakeForce(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2 x3 x3      x3], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t_end]));

    x1 = nvpairs.RoadGrade_Const_pct;
    BuildSignal_RoadGrade(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialVehicleSpeed_kph = nvpairs.InitialVehicleSpeed_kph;

  end  % function

  function signalData = RoadGrade3(inpObj, nvpairs)
  %%
    arguments
      inpObj

      nvpairs.InitialVehicleSpeed_kph (1,1) double = 0

      nvpairs.RoadGrade_1_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_1_pct, -50, 50)} = 40
      nvpairs.RoadGrade_2_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_2_pct, -50, 50)} = -40
      nvpairs.RoadGrade_3_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_3_pct, -50, 50)} = 5

      nvpairs.BrakeForce_1_N (1,1) {mustBeNonnegative} = 0
      nvpairs.BrakeForce_2_N (1,1) {mustBeNonnegative} = 2000

      nvpairs.RoadGradeChange_1_StartTime (1,1) duration = seconds(10)
      nvpairs.RoadGradeChange_1_EndTime (1,1) duration = seconds(10 + 5)
      nvpairs.RoadGradeChange_2_StartTime (1,1) duration = seconds(15 + 5)
      nvpairs.RoadGradeChange_2_EndTime (1,1) duration = seconds(20 + 5)

      nvpairs.BrakeForceChange_1_StartTime (1,1) duration = seconds(30)
      nvpairs.BrakeForceChange_1_EndTime (1,1) duration = seconds(30 + 5)

      nvpairs.StopTime (1,1) duration = seconds(35 + 15)

      nvpairs.AxleTorque_Const_Nm (1,1) {mustBeNonnegative} = 0
    end

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.AxleTorque_Const_Nm;
    BuildSignal_AxleTorque(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    x1 = nvpairs.RoadGrade_1_pct;
    x2 = nvpairs.RoadGrade_2_pct;
    x3 = nvpairs.RoadGrade_3_pct;
    t1 = seconds(nvpairs.RoadGradeChange_1_StartTime);
    t2 = seconds(nvpairs.RoadGradeChange_1_EndTime);
    t3 = seconds(nvpairs.RoadGradeChange_2_StartTime);
    t4 = seconds(nvpairs.RoadGradeChange_2_EndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t3 )
    assert( t3 < t4 )
    assert( t4+0.01 < t_end )
    BuildSignal_RoadGrade(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2 x3 x3      x3], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t_end]));

    x1 = nvpairs.BrakeForce_1_N;
    x2 = nvpairs.BrakeForce_2_N;
    t1 = seconds(nvpairs.BrakeForceChange_1_StartTime);
    t2 = seconds(nvpairs.BrakeForceChange_1_EndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t_end )
    BuildSignal_BrakeForce(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialVehicleSpeed_kph = nvpairs.InitialVehicleSpeed_kph;

  end  % function

  function signalData = DriveAxle(inpObj, nvpairs)
  %%
    arguments
      inpObj

      nvpairs.InitialVehicleSpeed_kph (1,1) double = 0

      nvpairs.AxleTorque_1_Nm (1,1) {mustBeNonnegative} = 1000
      nvpairs.AxleTorque_2_Nm (1,1) {mustBeNonnegative} = 1500
      nvpairs.AxleTorque_3_Nm (1,1) {mustBeNonnegative} = 0

      nvpairs.BrakeForce_1_N (1,1) {mustBeNonnegative} = 0
      nvpairs.BrakeForce_2_N (1,1) {mustBeNonnegative} = 7000

      nvpairs.AxleTorqueChange_1_StartTime (1,1) duration = seconds(10)
      nvpairs.AxleTorqueChange_1_EndTime (1,1) duration = seconds(10 + 1)
      nvpairs.AxleTorqueChange_2_StartTime (1,1) duration = seconds(11 + 9)
      nvpairs.AxleTorqueChange_2_EndTime (1,1) duration = seconds(20 + 1)

      nvpairs.BrakeForceChange_1_StartTime (1,1) duration = seconds(25)
      nvpairs.BrakeForceChange_1_EndTime (1,1) duration = seconds(25 + 5)

      nvpairs.StopTime (1,1) duration = seconds(30 + 10)

      nvpairs.RoadGrade_Const_pct (1,1) {mustBeInRange(nvpairs.RoadGrade_Const_pct, -50, 50)} = 10
    end

    % Record the function name. This is used for the plot window title.
    ds = dbstack;
    thisFunctionFullName = ds(1).name;
    inpObj.FunctionName = extractAfter(thisFunctionFullName, ".");

    inpObj.StopTime = nvpairs.StopTime;
    t_end = seconds(nvpairs.StopTime);

    x1 = nvpairs.AxleTorque_1_Nm;
    x2 = nvpairs.AxleTorque_2_Nm;
    x3 = nvpairs.AxleTorque_3_Nm;
    t1 = seconds(nvpairs.AxleTorqueChange_1_StartTime);
    t2 = seconds(nvpairs.AxleTorqueChange_1_EndTime);
    t3 = seconds(nvpairs.AxleTorqueChange_2_StartTime);
    t4 = seconds(nvpairs.AxleTorqueChange_2_EndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t3 )
    assert( t3 < t4 )
    assert( t4+0.01 < t_end )
    BuildSignal_AxleTorque(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2 x3 x3      x3], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t3 t4 t4+0.01 t_end]));

    x1 = nvpairs.BrakeForce_1_N;
    x2 = nvpairs.BrakeForce_2_N;
    t1 = seconds(nvpairs.BrakeForceChange_1_StartTime);
    t2 = seconds(nvpairs.BrakeForceChange_1_EndTime);
    assert( 0.01 < t1 )
    assert( t1 < t2 )
    assert( t2+0.01 < t_end )
    BuildSignal_BrakeForce(inpObj, ...
      'Data',        [x1 x1   x1 x2 x2      x2], ...
      'Time',seconds([0  0.01 t1 t2 t2+0.01 t_end]));

    x1 = nvpairs.RoadGrade_Const_pct;
    BuildSignal_RoadGrade(inpObj, 'Data',[x1 x1], 'Time',seconds([0 t_end]));

    if inpObj.Plot_tf
      plotSignals(inpObj);
    end

    signalData = BundleSignals(inpObj);

    signalData.Options.InitialVehicleSpeed_kph = nvpairs.InitialVehicleSpeed_kph;

  end  % function

end  % methods

methods (Access = private)

  %% Build signal trace with timetable

  function inpObj = BuildSignal_AxleTorque(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.AxleTrq = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.AxleTrq.Properties.VariableNames = {'AxleTrq'};
    inpObj.AxleTrq.Properties.VariableUnits = {'N*m'};
    inpObj.AxleTrq.Properties.VariableContinuity = {'continuous'};
    inpObj.AxleTrq = ...
      retime(inpObj.AxleTrq, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_BrakeForce(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.BrakeForce = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.BrakeForce.Properties.VariableNames = {'BrakeForce'};
    inpObj.BrakeForce.Properties.VariableUnits = {'N'};
    inpObj.BrakeForce.Properties.VariableContinuity = {'continuous'};
    inpObj.BrakeForce = ...
      retime(inpObj.BrakeForce, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function inpObj = BuildSignal_RoadGrade(inpObj, nvpairs)
  %%
    arguments
      inpObj
      nvpairs.Data (:,1) double
      nvpairs.Time (:,1) duration
      nvpairs.TimeStep (1,1) duration = seconds(0.01)
    end
    inpObj.RoadGrade = timetable(nvpairs.Data, 'RowTimes',nvpairs.Time);
    inpObj.RoadGrade.Properties.VariableNames = {'RoadGrade'};
    inpObj.RoadGrade.Properties.VariableUnits = {'%'};
    inpObj.RoadGrade.Properties.VariableContinuity = {'continuous'};
    inpObj.RoadGrade = ...
      retime(inpObj.RoadGrade, 'regular','makima', 'TimeStep',nvpairs.TimeStep);
  end

  function signalData = BundleSignals(inpObj)
  %%
    signalData.Signals.AxleTrq = inpObj.AxleTrq;
    signalData.Signals.BrakeForce = inpObj.BrakeForce;
    signalData.Signals.RoadGrade = inpObj.RoadGrade;

    signalData.Bus = Simulink.Bus;
    sigs = {
      inpObj.AxleTrq ...
      inpObj.BrakeForce ...
      inpObj.RoadGrade };
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
