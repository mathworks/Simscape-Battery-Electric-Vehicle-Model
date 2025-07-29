classdef BEVProjectNavigationAppMain < handle
  %% Main code of BEV project navigation app
  % This is a project entry-point app for a project to find some key models, scripts, etc.
  %
  % The app does not start if a linked file is not found during start up.
  % If the app window appears, it means that all linked files were found.
  % To disable the link checking, set ForceStart to true:
  %
  %   BEVProjectNavigationAppMain(ForceStart = true)

  % Copyright 2024-2025 The MathWorks, Inc.

  properties
    Window LiteApp6.LiteAppWindow
  end  % properties

  properties (Access=private)
    force_start (1,1) logical = false
  end  % properties

  methods

    function delete(App)
      delete(App.Window)
    end  % function

    function App = BEVProjectNavigationAppMain(NameValuePair)

      arguments (Input)
        % Start the app even if some links are invalid.
        NameValuePair.ForceStart (1,1) logical = false
      end  % argumentsend  %

      App.force_start = NameValuePair.ForceStart;

      app_window = build_ui(App);

      App.Window = app_window;
      Show(App.Window)
    end  % function

    function app_window = build_ui(App)

      function check_link(filename)
        % Check that the file exists.
        try
          LiteApp6.Utility.getFileFullPath(filename);
        catch exception
          if not(App.force_start)
            rethrow(exception)
          end  % if
        end  % try, catch
      end  % nested function

      app_window = LiteApp6.LiteAppWindow(SourceFilename=mfilename);

      app_window.Name = "BEV Project Navigation App";
      app_window.Width = 580;
      app_window.Height = 680;

      width_unit = LiteApp6.Utility.Constant.Width{"unitwidth"};
      indent = width_unit * 2;

      layout = app_window.MainLayout;

      area = NewArea(layout);
      column = NewColumn(layout, area);

      %% ============================================================================
      row = NewRow(layout, column);

      label_ui = LiteApp6.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{Project}";

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_project_description_page = "BEVProject_Description.html";
      check_link(target_project_description_page);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "BEV project description";
      link_ui.Tooltip = "Open page: " + target_project_description_page;
      link_ui.HyperlinkClickedCallback = @() open_target_page(target_project_description_page);

      %% ============================================================================
      row = NewRow(layout, column);

      label_ui = LiteApp6.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{BEV system model}";

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_BEV_system_model = "BEV_system_model";
      check_link(target_BEV_system_model);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "BEV system model";
      link_ui.Tooltip = "Open model: " + target_BEV_system_model;
      link_ui.HyperlinkClickedCallback = @() open_target_model(target_BEV_system_model);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_BEV_main_script = "BEV_main_script";
      check_link(target_BEV_main_script);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "BEV main script";
      link_ui.Tooltip = "Open script: " + target_BEV_main_script;
      link_ui.HyperlinkClickedCallback = @() open_target_script(App, target_BEV_main_script);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_BEV_Case_FTP75_Basic = "BEV_Basic_FTP75";
      check_link(target_BEV_Case_FTP75_Basic);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Simulation case: FTP75";
      link_ui.Tooltip = "Open script: " + target_BEV_Case_FTP75_Basic;
      link_ui.HyperlinkClickedCallback = @() open_target_script(App, target_BEV_Case_FTP75_Basic);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_BEV_Case_SimpleDrivePattern_Basic = "BEV_Basic_SimpleDrivePattern";
      check_link(target_BEV_Case_SimpleDrivePattern_Basic);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Simulation case: Simple drive pattern";
      link_ui.Tooltip = "Open script: " + target_BEV_Case_SimpleDrivePattern_Basic;
      link_ui.HyperlinkClickedCallback = @() open_target_script(App, target_BEV_Case_SimpleDrivePattern_Basic);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      label_ui = LiteApp6.Component.Label(NewSlot(layout, row));
      label_ui.Text = "See BEV / Model-* / SimulationCases for more cases";

      %% ============================================================================
      row = NewRow(layout, column);

      label_ui = LiteApp6.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{Vehicle1D}";

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_description_page = "Vehicle1D_Description.html";
      check_link(target_description_page);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Vehicle1D description";
      link_ui.Tooltip = "Open page: " + target_description_page;
      link_ui.HyperlinkClickedCallback = @() open_target_page(target_description_page);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_app = "Vehicle1DPerformanceDesignApp";
      check_link(target_app);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Vehicle1D performance design app";
      link_ui.Tooltip = "Open app: " + target_app;
      link_ui.HyperlinkClickedCallback = @() open_app(target_app);

      %% ============================================================================
      row = NewRow(layout, column);

      label_ui = LiteApp6.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{Motor drive unit (MDU)}";

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_description_page = "MotorDriveUnit_Description.html";
      check_link(target_description_page);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "MDU description";
      link_ui.Tooltip = "Open page: " + target_description_page;
      link_ui.HyperlinkClickedCallback = @() open_target_page(target_description_page);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_app = "MotorDriveUnitApp";
      check_link(target_app);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "MDU app";
      link_ui.Tooltip = "Open app: " + target_app;
      link_ui.HyperlinkClickedCallback = @() open_app(target_app);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_app = "MotorDriveUnit_BasicModelEfficiencyApp";
      check_link(target_app);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "MDU Efficiency app for Basic model";
      link_ui.Tooltip = "Open app: " + target_app;
      link_ui.HyperlinkClickedCallback = @() open_app(target_app);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_app = "testui_MotorDriveUnit_SystemThermalModelEfficiencyApp";
      check_link(target_app);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "MDU Efficiency app for System Thermal model";
      link_ui.Tooltip = "Open app: " + target_app;
      link_ui.HyperlinkClickedCallback = @() open_app(target_app);

      %% ============================================================================
      row = NewRow(layout, column);

      label_ui = LiteApp6.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{High voltage battery}";

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_hvbattery_TestModel = "BatteryHV_TestModel";
      check_link(target_hvbattery_TestModel);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "High voltage battery test model";
      link_ui.Tooltip = "Open model: " + target_hvbattery_TestModel;
      link_ui.HyperlinkClickedCallback = @() open_target_model(target_hvbattery_TestModel);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_hvbattery_main_script = "BatteryHV_main_script";
      check_link(target_hvbattery_main_script);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "High voltage battery main script";
      link_ui.Tooltip = "Open script: " + target_hvbattery_main_script;
      link_ui.HyperlinkClickedCallback = @() open_target_script(App, target_hvbattery_main_script);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_hvbattery_visualization_script = "BatteryHV_SystemTable_ParameterPlot_sample_script";
      check_link(target_hvbattery_visualization_script);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "High voltage battery parameter visualization script";
      link_ui.Tooltip = "Open script: " + target_hvbattery_visualization_script;
      link_ui.HyperlinkClickedCallback = @() open_target_script(App, target_hvbattery_visualization_script);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_hvbattery_parameter_build_script = "BatteryHV_SystemTable_DataBuild_sample_script";
      check_link(target_hvbattery_parameter_build_script);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "High voltage battery parameter build script";
      link_ui.Tooltip = "Open script: " + target_hvbattery_parameter_build_script;
      link_ui.HyperlinkClickedCallback = @() open_target_script(App, target_hvbattery_parameter_build_script);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      target_BatteryHV_Case_Random = "BatteryHV_Basic_Random";
      check_link(target_BatteryHV_Case_Random);

      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Simulation case: Random load current";
      link_ui.Tooltip = "Open script: " + target_BatteryHV_Case_Random;
      link_ui.HyperlinkClickedCallback = @() open_target_script(App, target_BatteryHV_Case_Random);

      %%
      row = NewRow(layout, column);
      LiteApp6.Component.Label(NewSlot(layout, row, Width=indent), Text="");

      label_ui = LiteApp6.Component.Label(NewSlot(layout, row));
      label_ui.Text = "See Components / BatteryHighVoltage / Model-* / SimulationCases for more cases";

      %% ============================================================================
      row = NewRow(layout, column);

      label_ui = LiteApp6.Component.Label(NewSlot(layout, row));
      label_ui.Text = "\textbf{Quality tools}";

      %% ============================================================================
      area = NewArea(layout);

      NewColumn(layout, area, Width=indent);  % left indent

      %%
      column = NewColumn(layout, area);

      row = NewRow(layout, column);
      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Code analyzer";
      link_ui.Tooltip = "Open tool: codeAnalyzer";
      link_ui.HyperlinkClickedCallback = @() codeAnalyzer(currentProject().RootFolder);

      row = NewRow(layout, column);
      doclink_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
      doclink_ui.ComponentWidth = "fit";
      doclink_ui.HyperlinkText = "doc";
      doclink_ui.Tooltip = "Open documentation: " + link_ui.HyperlinkText;
      doclink_ui.HyperlinkClickedCallback = @() ...
        web("https://www.mathworks.com/help/matlab/ref/codeanalyzer-app.html");

      %%
      column = NewColumn(layout, area);

      row = NewRow(layout, column);
      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Test browser";
      link_ui.Tooltip = "Open tool: testBrowser";
      link_ui.HyperlinkClickedCallback = @() testBrowser;

      row = NewRow(layout, column);
      doclink_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
      doclink_ui.ComponentWidth = "fit";
      doclink_ui.HyperlinkText = "doc";
      doclink_ui.Tooltip = "Open documentation: " + link_ui.HyperlinkText;
      doclink_ui.HyperlinkClickedCallback = @() ...
        web("https://www.mathworks.com/help/matlab/ref/testbrowser-app.html");

      %%
      column = NewColumn(layout, area);

      row = NewRow(layout, column);
      link_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row));
      link_ui.HyperlinkText = "Test manager";
      link_ui.Tooltip = "Open tool: matlabTestManager (requires MATLAB Test license)";
      link_ui.HyperlinkClickedCallback = @() matlabTestManager;

      row = NewRow(layout, column);
      doclink_ui = LiteApp6.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
      doclink_ui.ComponentWidth = "fit";
      doclink_ui.HyperlinkText = "doc";
      doclink_ui.Tooltip = "Open documentation: " + link_ui.HyperlinkText;
      doclink_ui.HyperlinkClickedCallback = @() ...
        web("https://www.mathworks.com/help/matlab-test/ref/matlabtestmanager-app.html");

    end  % function

    % At least one callback function must be a class method of an app class.
    % This makes the object life cycle of app class resilient, i.e.,
    % the app remains open even when workspace is cleared or
    % when a function which creates an app exits.
    function open_target_script(~, target_script)
      disp("Navigation App: Opening script: <a href=""matlab:edit('" + target_script + "')"">" + target_script + "</a>")
      edit(target_script)
    end  % function

  end  % methods
end  % classdef

function open_target_model(target_model)
disp("Navigation App: Opening model: <a href=""matlab:" + target_model + """>" + target_model + "</a>")
open_system(target_model)
end  % local function

function open_target_page(target_page)
disp("Navigation App: Opening page: <a href=""matlab:web('" + target_page + "')"">" + target_page + "</a>")
% To open an HTML file, use the web command, not the open command.
% web opens the page in MATLAB's web browser which supports
% HTML hyperlinks to run MATLAB commands.
web(target_page)
end  % local function

function open_app(target_app)
disp("Navigation App: Opening app: <a href=""matlab:" + target_app + """>" + target_app + "</a>")
feval(target_app);
end  % local function
