function App = BEVProjectNavigator()
%% BEV project navigator app
% This is an entry-point app to find some key models, scripts, etc. in the project.
%
% The getFileFullPath function checks that the linked file exists.
% This check is done before the app shows up.
% If the file is not found, the app issues an error and terminates.
% If the app window appears, it guarantees that all the links are valid.
%
% This is a funciton-based app whose life cycle is limited compared to class-based app.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (1,:) struct
end

win = LiteApp5.LiteAppWindow(SourceFilename=mfilename);

win.Name = "BEV Project Navigator";
win.Width = 560;
win.Height = 660;

width_unit = LiteApp5.Utility.Constant.Width{"unitwidth"};
indent = width_unit * 2;

layout = win.MainLayout;

area = NewArea(layout);
column = NewColumn(layout, area);

%% ============================================================================
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "\textbf{Project}";

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_project_description_page = "BEVProjectDescription.html";
% Check that the file exists.
LiteApp5.Utility.getFileFullPath(target_project_description_page);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "BEV project description";
link_ui.Tooltip = "Open page: " + target_project_description_page;
link_ui.HyperlinkClickedCallback = @() open_target_page(target_project_description_page);

%% ============================================================================
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "\textbf{BEV system model}";

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_BEV_system_model = "BEV_system_model";
LiteApp5.Utility.getFileFullPath(target_BEV_system_model);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "BEV system model";
link_ui.Tooltip = "Open model: " + target_BEV_system_model;
link_ui.HyperlinkClickedCallback = @() open_target_model(target_BEV_system_model);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_BEV_main_script = "BEV_main_script";
LiteApp5.Utility.getFileFullPath(target_BEV_main_script);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "BEV main script";
link_ui.Tooltip = "Open script: " + target_BEV_main_script;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_BEV_main_script);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_BEV_Case_FTP75_Basic = "BEV_Case_FTP75_Basic";
LiteApp5.Utility.getFileFullPath(target_BEV_Case_FTP75_Basic);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "Simulation case: FTP75";
link_ui.Tooltip = "Open script: " + target_BEV_Case_FTP75_Basic;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_BEV_Case_FTP75_Basic);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_BEV_Case_SimpleDrivePattern_Basic = "BEV_Case_SimpleDrivePattern_Basic";
LiteApp5.Utility.getFileFullPath(target_BEV_Case_SimpleDrivePattern_Basic);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "Simulation case: Simple drive pattern";
link_ui.Tooltip = "Open script: " + target_BEV_Case_SimpleDrivePattern_Basic;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_BEV_Case_SimpleDrivePattern_Basic);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "See BEV / SimulationCases for more cases";

%% ============================================================================
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "\textbf{Vehicle1D}";

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_app = "Vehicle1DPerformanceDesignApp";
LiteApp5.Utility.getFileFullPath(target_app);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "Vehicle1D performance design app";
link_ui.Tooltip = "Open app: " + target_app;
link_ui.HyperlinkClickedCallback = @() open_app(target_app);

%% ============================================================================
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "\textbf{Motor drive unit (MDU)}";

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_description_page = "MotorDriveUnitDescription.html";
LiteApp5.Utility.getFileFullPath(target_description_page);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "MDU description page";
link_ui.Tooltip = "Open page: " + target_description_page;
link_ui.HyperlinkClickedCallback = @() open_target_page(target_description_page);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_app = "MotorDriveUnitApp";
LiteApp5.Utility.getFileFullPath(target_app);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "MDU app";
link_ui.Tooltip = "Open app: " + target_app;
link_ui.HyperlinkClickedCallback = @() open_app(target_app);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_app = "MotorDriveUnitEfficiencyApp_Basic";
LiteApp5.Utility.getFileFullPath(target_app);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "MDU Efficiency app for Basic model";
link_ui.Tooltip = "Open app: " + target_app;
link_ui.HyperlinkClickedCallback = @() open_app(target_app);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_app = "MotorDriveUnitEfficiencyApp_SystemThermal";
LiteApp5.Utility.getFileFullPath(target_app);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "MDU Efficiency app for System Thermal model";
link_ui.Tooltip = "Open app: " + target_app;
link_ui.HyperlinkClickedCallback = @() open_app(target_app);

%% ============================================================================
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "\textbf{High voltage battery}";

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_hvbattery_harness_model = "BatteryHV_harness_model";
LiteApp5.Utility.getFileFullPath(target_hvbattery_harness_model);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "High voltage battery harness model";
link_ui.Tooltip = "Open model: " + target_hvbattery_harness_model;
link_ui.HyperlinkClickedCallback = @() open_target_model(target_hvbattery_harness_model);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_hvbattery_main_script = "BatteryHV_main_script";
LiteApp5.Utility.getFileFullPath(target_hvbattery_main_script);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "High voltage battery main script";
link_ui.Tooltip = "Open script: " + target_hvbattery_main_script;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_hvbattery_main_script);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_hvbattery_visualization_script = "BatteryHV_Table_visualizeParameters";
LiteApp5.Utility.getFileFullPath(target_hvbattery_visualization_script);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "High voltage battery parameter visualization script";
link_ui.Tooltip = "Open script: " + target_hvbattery_visualization_script;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_hvbattery_visualization_script);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_hvbattery_parameter_build_script = "BatteryHV_Table_buildParameters";
LiteApp5.Utility.getFileFullPath(target_hvbattery_parameter_build_script);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "High voltage battery parameter build script";
link_ui.Tooltip = "Open script: " + target_hvbattery_parameter_build_script;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_hvbattery_parameter_build_script);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

target_BatteryHV_Case_Random = "BatteryHV_Case_Random";
LiteApp5.Utility.getFileFullPath(target_BatteryHV_Case_Random);

link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "Simulation case: Random load current";
link_ui.Tooltip = "Open script: " + target_BatteryHV_Case_Random;
link_ui.HyperlinkClickedCallback = @() open_target_script(target_BatteryHV_Case_Random);

%%
row = NewRow(layout, column);
LiteApp5.Component.Label(NewSlot(layout, row, Width=indent), Text="");

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "See Components / BatteryHighVoltage / SimulationCases for more cases";

%% ============================================================================
row = NewRow(layout, column);

label_ui = LiteApp5.Component.Label(NewSlot(layout, row));
label_ui.Text = "\textbf{Quality tools}";

%% ============================================================================
area = NewArea(layout);

NewColumn(layout, area, Width=indent);  % left indent

%%
column = NewColumn(layout, area);

row = NewRow(layout, column);
link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "Code analyzer";
link_ui.Tooltip = "Open tool: codeAnalyzer";
link_ui.HyperlinkClickedCallback = @() codeAnalyzer(currentProject().RootFolder);

row = NewRow(layout, column);
doclink_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
doclink_ui.ComponentWidth = "fit";
doclink_ui.HyperlinkText = "doc";
doclink_ui.Tooltip = "Open documentation: " + link_ui.HyperlinkText;
doclink_ui.HyperlinkClickedCallback = @() ...
  web("https://www.mathworks.com/help/matlab/ref/codeanalyzer-app.html");

%%
column = NewColumn(layout, area);

row = NewRow(layout, column);
link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "Test browser";
link_ui.Tooltip = "Open tool: testBrowser";
link_ui.HyperlinkClickedCallback = @() testBrowser;

row = NewRow(layout, column);
doclink_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
doclink_ui.ComponentWidth = "fit";
doclink_ui.HyperlinkText = "doc";
doclink_ui.Tooltip = "Open documentation: " + link_ui.HyperlinkText;
doclink_ui.HyperlinkClickedCallback = @() ...
  web("https://www.mathworks.com/help/matlab/ref/testbrowser-app.html");

%%
column = NewColumn(layout, area);

row = NewRow(layout, column);
link_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row));
link_ui.HyperlinkText = "Test manager";
link_ui.Tooltip = "Open tool: matlabTestManager (requires MATLAB Test license)";
link_ui.HyperlinkClickedCallback = @() matlabTestManager;

row = NewRow(layout, column);
doclink_ui = LiteApp5.Component.Hyperlink(NewSlot(layout, row, Width="fit"));
doclink_ui.ComponentWidth = "fit";
doclink_ui.HyperlinkText = "doc";
doclink_ui.Tooltip = "Open documentation: " + link_ui.HyperlinkText;
doclink_ui.HyperlinkClickedCallback = @() ...
  web("https://www.mathworks.com/help/matlab-test/ref/matlabtestmanager-app.html");

%%
Show(win)
% Function-based app must return the App object to keep the app window open.
App.Window = win;
end  % function

function open_target_script(target_script)
disp("Opening script: " + target_script)
edit(target_script)
end  % function

function open_target_model(target_model)
disp("Opening model: " + target_model)
open_system(target_model)
end  % function

function open_target_page(target_page)
disp("Opening page: " + target_page)
% Use web, not open, to open the page in MATLAB's Web browser because
% it supports HTML hyperlinks to run MATLAB commands.
web(target_page)
end  % function

function open_app(target_app)
disp("Opening app: " + target_app)
feval(target_app);
end  % function
