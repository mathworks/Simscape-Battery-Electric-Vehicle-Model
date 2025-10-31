%[text] # searchText demo
%[text] Find `*.m` files containing "Copright" in the current folder.
result = TextSearchTool1.searchText(...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileTypes = "*.m", ...
  SearchText = "Copyright" );
disp(result.Properties.CustomProperties.TargetFolder) %[output:8253c824]
disp(height(result)) %[output:550cb4cd]
disp(result) %[output:1a405689]
%%
%[text] Do the same search as above, but exclude Live Scripts.
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileTypes = "*.m", ...
  ExcludeLiveScript = true, ...
  SearchText = "Copyright" );
disp(result.Properties.CustomProperties.TargetFolder) %[output:3370169c]
disp(height(result)) %[output:2796c09c]
disp(result) %[output:3df8b82b]
%%
%[text] Do the same search as above two cases, but exclude MATLAB code files.
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileTypes = "*.m", ...
  ExcludeMATLABCodeFile = true, ...
  SearchText = "Copyright" );
disp(result.Properties.CustomProperties.TargetFolder) %[output:3e2009b5]
disp(result) %[output:173781eb]
%%
%[text] If the `FileTypes` option is specified, other options to specify file types are ignored. In the following case, the `CustomFileTypes` option is specified but ignored.
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = true, ...
  FileTypes = ["sample*.m", "sample*.mdl"], ...
  CustomFileTypes = "*.md", ...
  SearchText = "Copyright", ...
  IncludeStyledFilePath = true );
assert(not(isempty(result)), "No match.")
disp(result.Properties.CustomProperties.TargetFolder) %[output:9ee52986]
disp(height(result)) %[output:3aab07fd]
disp(result(:, ["StyledFilePath", "LineNumber"])) %[output:7413d005]
%%
%[text] Unlike the above case which uses the `FileTypes` option, the follwoing case uses the `CustomFileTypes` option. In this case, the `SelectMarkdown` option takes effect.
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = true, ...
  SelectMarkdown = true, ...
  CustomFileTypes = ["sample*.m", "sample*.mdl"], ...
  SearchText = "Copyright 2025", ...
  IncludeStyledFilePath = true );
assert(not(isempty(result)), "No match.")
disp(result.Properties.CustomProperties.TargetFolder) %[output:7685be56]
disp(height(result)) %[output:5762b24c]
disp(result(:, ["StyledFilePath", "LineNumber"])) %[output:8c4d6c1b]
%%
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = true, ...
  SelectMATLAB = true, ...
  SelectMarkdown = true, ...
  SearchText = "test various aspects", ...
  IgnoreCase = true, ...
  IncludeStyledFilePath = true );
assert(not(isempty(result)), "No match.")
disp(result.Properties.CustomProperties.TargetFolder) %[output:42a2133a]
disp(height(result)) %[output:127c35b9]
disp(result(:, ["StyledFilePath", "LineNumber"])) %[output:1598a716]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:8253c824]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:550cb4cd]
%   data: {"dataType":"text","outputData":{"text":"     8\n\n","truncated":false}}
%---
%[output:1a405689]
%   data: {"dataType":"text","outputData":{"text":"                <strong>FilePath<\/strong>                <strong>LineNumber<\/strong>                         <strong>LineText<\/strong>                      \n    <strong>________________________________<\/strong>    <strong>__________<\/strong>    <strong>___________________________________________________<\/strong>\n\n    \"BEVProjectNavigationApp.m\"              5        \"% Copyright 2024-2025 The MathWorks, Inc.\"        \n    \"BEVProject_Description.m\"              35        \"%[text] *Copyright 2020-2025 The MathWorks, Inc.*\"\n    \"buildfile.m\"                           12        \"% Copyright 2023-2025 The MathWorks, Inc.\"        \n    \"uitest_BEVProject.m\"                   12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"      \n    \"uiuptodatetest_BEVProject.m\"           12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"      \n    \"unittest_BEVProject.m\"                 13        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n    \"unittest_BEVProject_settings.m\"        15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n    \"uptodatetest_BEVProject.m\"             15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n\n","truncated":false}}
%---
%[output:3370169c]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:2796c09c]
%   data: {"dataType":"text","outputData":{"text":"     7\n\n","truncated":false}}
%---
%[output:3df8b82b]
%   data: {"dataType":"text","outputData":{"text":"                <strong>FilePath<\/strong>                <strong>LineNumber<\/strong>                      <strong>LineText<\/strong>                   \n    <strong>________________________________<\/strong>    <strong>__________<\/strong>    <strong>_____________________________________________<\/strong>\n\n    \"BEVProjectNavigationApp.m\"              5        \"% Copyright 2024-2025 The MathWorks, Inc.\"  \n    \"buildfile.m\"                           12        \"% Copyright 2023-2025 The MathWorks, Inc.\"  \n    \"uitest_BEVProject.m\"                   12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"\n    \"uiuptodatetest_BEVProject.m\"           12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"\n    \"unittest_BEVProject.m\"                 13        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n    \"unittest_BEVProject_settings.m\"        15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n    \"uptodatetest_BEVProject.m\"             15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n\n","truncated":false}}
%---
%[output:3e2009b5]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:173781eb]
%   data: {"dataType":"text","outputData":{"text":"             <strong>FilePath<\/strong>             <strong>LineNumber<\/strong>                         <strong>LineText<\/strong>                      \n    <strong>__________________________<\/strong>    <strong>__________<\/strong>    <strong>___________________________________________________<\/strong>\n\n    \"BEVProject_Description.m\"        35        \"%[text] *Copyright 2020-2025 The MathWorks, Inc.*\"\n\n","truncated":false}}
%---
%[output:9ee52986]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:3aab07fd]
%   data: {"dataType":"text","outputData":{"text":"     5\n\n","truncated":false}}
%---
%[output:7413d005]
%   data: {"dataType":"text","outputData":{"text":"                                            <strong>StyledFilePath<\/strong>                                            <strong>LineNumber<\/strong>\n    <strong>______________________________________________________________________________________________<\/strong>    <strong>__________<\/strong>\n\n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder1 > samplefunction_11.m\"         3    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder2 > samplescript21.m\"            3    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript31.m\"            3    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript32.m\"            3    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder1 > samplemodel_11.mdl\"        990    \n\n","truncated":false}}
%---
%[output:7685be56]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:5762b24c]
%   data: {"dataType":"text","outputData":{"text":"    31\n\n","truncated":false}}
%---
%[output:8c4d6c1b]
%   data: {"dataType":"text","outputData":{"text":"                                                                <strong>StyledFilePath<\/strong>                                                                <strong>LineNumber<\/strong>\n    <strong>______________________________________________________________________________________________________________________________________<\/strong>    <strong>__________<\/strong>\n\n    \"Components > BatteryHighVoltage > ToolTest > refineOCVData > markdown > refineOCVData_sample_script.md\"                                      83    \n    \"Components > BatteryHighVoltage > ToolTest > refineTerminalResistanceData > markdown > refineTerminalResistanceData_sample_script.md\"        83    \n    \"Components > ControllerAndEnvironment > TestComponents > markdown > BuildInputs_CtrlEnv_Vehicle_Simple.md\"                                   82    \n    \"Components > MotorDriveUnit > Model-Basic > README.md\"                                                                                       34    \n    \"Components > MotorDriveUnit > Model-SystemThermal > README.md\"                                                                               39    \n    \"Components > MotorDriveUnit > Utility > README.md\"                                                                                            5    \n    \"Components > Reducer > InputsForTesting > markdown > BuildInputs_Reducer_AxleSide_Constant.md\"                                               82    \n    \"Components > Reducer > InputsForTesting > markdown > BuildInputs_Reducer_AxleSide_Flip.md\"                                                   90    \n    \"Components > Reducer > InputsForTesting > markdown > BuildInputs_Reducer_MotorSide_Constant.md\"                                              82    \n    \"Components > Reducer > InputsForTesting > markdown > BuildInputs_Reducer_MotorSide_Flip.md\"                                                  88    \n    \"Components > Reducer > InputsForTesting > markdown > setupProbe_Reducer_Inputs.md\"                                                           45    \n    \"Components > Reducer > Model-Basic > SimulationCases > markdown > Reducer_Basic_Constant.md\"                                                 57    \n    \"Components > Reducer > Model-Basic > SimulationCases > markdown > Reducer_Basic_Flip.md\"                                                     57    \n    \"Components > Reducer > Model-Basic > SimulationCases > markdown > profileSim_Reducer_Basic.md\"                                              175    \n    \"Components > Vehicle1D > AppFiles-PerformanceDesign > markdown > Vehicle1DPerformanceParameters_sample_script.md\"                            84    \n    \"Components > VehicleSpeedReference > Model-Constant > markdown > VehSpdRef_Constant_sample_script.md\"                                        25    \n    \"Components > VehicleSpeedReference > Model-FTP75 > markdown > VehSpdRef_FTP75_sample_script.md\"                                              26    \n    \"Components > VehicleSpeedReference > Model-HighSpeed > markdown > BuildSignal_VehSpdRef_HighSpeed.md\"                                        51    \n    \"Components > VehicleSpeedReference > Model-HighSpeed > markdown > VehSpdRef_HighSpeed_sample_script.md\"                                      25    \n    \"Components > VehicleSpeedReference > Model-Simple > markdown > VehSpdRef_Simple_sample_script.md\"                                            25    \n    \"FYI > README.md\"                                                                                                                             37    \n    \"Utility > FileTool > Test > isPlainTextLiveScript > samplefolder > README.md\"                                                                 8    \n    \"Utility > ModelTool > README.md\"                                                                                                             10    \n    \"Utility > SignalTool > README.md\"                                                                                                            19    \n    \"Utility > SignalTool > Test > plotDifference > markdown > demo_plotDifference.md\"                                                            32    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > README.md\"                                                                        8    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder1 > samplefunction_11.m\"                                                 3    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder2 > samplescript21.m\"                                                    3    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript31.m\"                                                    3    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript32.m\"                                                    3    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder1 > samplemodel_11.mdl\"                                                990    \n\n","truncated":false}}
%---
%[output:42a2133a]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:127c35b9]
%   data: {"dataType":"text","outputData":{"text":"     3\n\n","truncated":false}}
%---
%[output:1598a716]
%   data: {"dataType":"text","outputData":{"text":"                                    <strong>StyledFilePath<\/strong>                                    <strong>LineNumber<\/strong>\n    <strong>______________________________________________________________________________<\/strong>    <strong>__________<\/strong>\n\n    \"Utility > TextSearchTool > Test > searchText > demo_searchText.m\"                    64    \n    \"Utility > FileTool > Test > isPlainTextLiveScript > samplefolder > README.md\"         4    \n    \"Utility > TextSearchTool > Test > searchText > testfolder > README.md\"                4    \n\n","truncated":false}}
%---
