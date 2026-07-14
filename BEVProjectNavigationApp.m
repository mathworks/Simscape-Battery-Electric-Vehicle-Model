function App = BEVProjectNavigationApp(NameValuePair)
% BEV project navigation app
% This is a project entry-point app to find some key models, scripts, etc. in the project.

% Copyright 2024-2026 The MathWorks, Inc.

arguments (Input)

  % Start the app even if some links are invalid.
  NameValuePair.ForceStart (1,1) logical = false

end  % arguments

arguments (Output)
  App struct {mustBeScalarOrEmpty}
end  % arguments

disp("Starting: BEV Project Navigation App")

force_start = NameValuePair.ForceStart;

main_figure = uifigure(Visible = "off");

app_window = AppUtil1.AppWindow(main_figure, SourceFile=mfilename);
app_window.Width = 580;
app_window.Height = 640;
app_window.Name = "BEV Project Navigation App";

app_v_container = app_window.MainVerticalContainer;

width_unit = AppUtil1.Constant.Width{"unitwidth"};
indent = width_unit * 2;

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);

label_ui = AppUtil1.Component.Label(v_layout);
label_ui.Text = "\textbf{Project}";

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_project_description_page = "BEVProject_Description.html";
check_link(target_project_description_page);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "BEV project description";
link_ui.Tooltip = "Open page: " + target_project_description_page;
link_ui.HyperlinkClickedCallback = @() open_target_page(target_project_description_page);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);

label_ui = AppUtil1.Component.Label(v_layout);
label_ui.Text = "\textbf{BEV system model}";

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_BEV_system_model = "BEV_system_model";
check_link(target_BEV_system_model);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "BEV system model";
link_ui.Tooltip = "Open model: " + target_BEV_system_model;
link_ui.HyperlinkClickedCallback = @() open_target_model(target_BEV_system_model);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_BEV_main_script = "BEV_main_script";
check_link(target_BEV_main_script);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "BEV main script";
link_ui.Tooltip = "Open script: " + target_BEV_main_script;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_BEV_main_script);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_BEV_Case_Basic_FTP75 = "BEV_Basic_FTP75";
check_link(target_BEV_Case_Basic_FTP75);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "Simulation case: FTP75";
link_ui.Tooltip = "Open script: " + target_BEV_Case_Basic_FTP75;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_BEV_Case_Basic_FTP75);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_BEV_Case_Basic_Simple = "BEV_Basic_Simple";
check_link(target_BEV_Case_Basic_Simple);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "Simulation case: Simple";
link_ui.Tooltip = "Open script: " + target_BEV_Case_Basic_Simple;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_BEV_Case_Basic_Simple);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
label_ui = AppUtil1.Component.Label(h_layout);
label_ui.Text = "See BEV / Model-* / SimulationCases for more cases";

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);

label_ui = AppUtil1.Component.Label(v_layout);
label_ui.Text = "\textbf{Vehicle1D}";

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_description_page = "Vehicle1D_Description.html";
check_link(target_description_page);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "Vehicle1D description";
link_ui.Tooltip = "Open page: " + target_description_page;
link_ui.HyperlinkClickedCallback = @() open_target_page(target_description_page);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_app = "Vehicle1DApp";
check_link(target_app);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "Vehicle1D performance design app";
link_ui.Tooltip = "Open app: " + target_app;
link_ui.HyperlinkClickedCallback = @() open_app(target_app);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);

label_ui = AppUtil1.Component.Label(v_layout);
label_ui.Text = "\textbf{Motor drive unit (MDU)}";

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_description_page = "MotorDriveUnit_Description.html";
check_link(target_description_page);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "MDU description";
link_ui.Tooltip = "Open page: " + target_description_page;
link_ui.HyperlinkClickedCallback = @() open_target_page(target_description_page);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_app = "AbstractMotorEfficiencyApp";
check_link(target_app);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "Abstract Motor Efficiency app";
link_ui.Tooltip = "Open app: " + target_app;
link_ui.HyperlinkClickedCallback = @() open_app(target_app);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);

label_ui = AppUtil1.Component.Label(v_layout);
label_ui.Text = "\textbf{High voltage battery}";

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_hvbattery_TestModel = "HarnessModel_BatteryHV";
check_link(target_hvbattery_TestModel);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "High voltage battery harness model";
link_ui.Tooltip = "Open model: " + target_hvbattery_TestModel;
link_ui.HyperlinkClickedCallback = @() open_target_model(target_hvbattery_TestModel);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_hvbattery_description = "BatteryHV_Description";
check_link(target_hvbattery_description);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "High voltage battery description";
link_ui.Tooltip = "Open description: " + target_hvbattery_description;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_hvbattery_description);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_hvbattery_visualization_script = "refineOCVData_sample_script";
check_link(target_hvbattery_visualization_script);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "OCV parameterization sample script";
link_ui.Tooltip = "Open script: " + target_hvbattery_visualization_script;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_hvbattery_visualization_script);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_hvbattery_parameter_build_script = "refineTerminalResistanceData_sample_script";
check_link(target_hvbattery_parameter_build_script);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "Terminal resistance parameterization sample script";
link_ui.Tooltip = "Open script: " + target_hvbattery_parameter_build_script;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_hvbattery_parameter_build_script);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

target_BatteryHV_Case_Random = "BatteryHV_Basic_Random";
check_link(target_BatteryHV_Case_Random);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
link_ui = AppUtil1.Component.Hyperlink(h_layout);
link_ui.Text = "Simulation case: Random load current";
link_ui.Tooltip = "Open script: " + target_BatteryHV_Case_Random;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_BatteryHV_Case_Random);

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

addHorizontalGridLayout(h_container, Width=indent);

h_layout = addHorizontalGridLayout(h_container);
label_ui = AppUtil1.Component.Label(h_layout);
label_ui.Text = "See Components / BatteryHighVoltage / Model-* / SimulationCases for more cases";

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);

label_ui = AppUtil1.Component.Label(v_layout);
label_ui.Text = "\textbf{Quality tools}";

% -----------------------------------------------------------------------------
v_layout = addVerticalGridLayout(app_v_container);
h_container = AppUtil1.HorizontalContainer(v_layout);

addHorizontalGridLayout(h_container, Width=indent);

% .............................................................................
% Column for the code analyzer
h_layout = addHorizontalGridLayout(h_container);
v_subcontainer = AppUtil1.VerticalContainer(h_layout);

v_sublayout = addVerticalGridLayout(v_subcontainer);
link_ui = AppUtil1.Component.Hyperlink(v_sublayout);
link_ui.Text = "Code analyzer";
link_ui.Tooltip = "Open tool: codeAnalyzer";
link_ui.HyperlinkClickedCallback = @() codeAnalyzer(currentProject().RootFolder);

v_sublayout = addVerticalGridLayout(v_subcontainer);
doclink_ui = AppUtil1.Component.Hyperlink(v_sublayout);
% doclink_ui.ComponentWidth = "fit";
doclink_ui.Text = "doc";
doclink_ui.Tooltip = "Open documentation: " + link_ui.Text;
doclink_ui.HyperlinkClickedCallback = @() ...
  web("https://www.mathworks.com/help/matlab/ref/codeanalyzer-app.html");

% .............................................................................
% Column for the test browser
h_layout = addHorizontalGridLayout(h_container);
v_subcontainer = AppUtil1.VerticalContainer(h_layout);

v_sublayout = addVerticalGridLayout(v_subcontainer);
link_ui = AppUtil1.Component.Hyperlink(v_sublayout);
link_ui.Text = "Test browser";
link_ui.Tooltip = "Open tool: testBrowser";
link_ui.HyperlinkClickedCallback = @() testBrowser;

v_sublayout = addVerticalGridLayout(v_subcontainer);
doclink_ui = AppUtil1.Component.Hyperlink(v_sublayout);
doclink_ui.ComponentWidth = "fit";
doclink_ui.Text = "doc";
doclink_ui.Tooltip = "Open documentation: " + link_ui.Text;
doclink_ui.HyperlinkClickedCallback = @() ...
  web("https://www.mathworks.com/help/matlab/ref/testbrowser-app.html");

% .............................................................................
% Column for the test manager
h_layout = addHorizontalGridLayout(h_container);
v_subcontainer = AppUtil1.VerticalContainer(h_layout);

v_sublayout = addVerticalGridLayout(v_subcontainer);
link_ui = AppUtil1.Component.Hyperlink(v_sublayout);
link_ui.Text = "Test manager";
link_ui.Tooltip = "Open tool: matlabTestManager (requires MATLAB Test license)";
link_ui.HyperlinkClickedCallback = @() matlabTestManager;

v_sublayout = addVerticalGridLayout(v_subcontainer);
doclink_ui = AppUtil1.Component.Hyperlink(v_sublayout);
doclink_ui.ComponentWidth = "fit";
doclink_ui.Text = "doc";
doclink_ui.Tooltip = "Open documentation: " + link_ui.Text;
doclink_ui.HyperlinkClickedCallback = @() ...
  web("https://www.mathworks.com/help/matlab-test/ref/matlabtestmanager-app.html");

% -----------------------------------------------------------------------------

  function check_link(filename)
    % Check that the file exists.
    try
      bev1mus.FileUtil.getFileFullPath(filename);
    catch exception
      if not(force_start)

        rethrow(exception)

      end  % if
    end  % try, catch
  end  % nested function

% -----------------------------------------------------------------------
movegui(main_figure, "center")
main_figure.Visible = "on";
drawnow
if nargout > 0
  App = struct;
  App.MainFigure = main_figure;
  App.Window = app_window;
end  % if
end  % function

% =============================================================================
% Local functions

function open_target_script(target_script)
disp("Navigation App: Opening script: <a href=""matlab:edit('" + target_script + "')"">" + target_script + "</a>")
edit(target_script)
end  % function

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
