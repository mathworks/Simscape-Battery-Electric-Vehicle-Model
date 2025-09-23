%[text] # searchText demo
result = TextSearchTool1.searchText(...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileTypes = ["*.m", "*.md"], ...
  TextPattern = "Copyright" );
disp(result.Properties.CustomProperties.TargetFolder) %[output:473448cd]
disp(height(result)) %[output:38652079]
disp(result) %[output:7e2920a1]
%%
%[text] Use the Filter option to apply an additional file filter.
% Find the *.m file excluding live scripts in the current folder.
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileType = "*.m", ...
  Filter = @(x) not(FileTool3.isPlainTextLiveScript(x)), ...
  TextPattern = "Copyright" );
disp(result.Properties.CustomProperties.TargetFolder) %[output:1f77519e]
disp(height(result)) %[output:570fc739]
disp(result) %[output:9b8ebcac]
%%
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileType = "*.m", ...
  ExcludeLiveScript = true, ...
  TextPattern = "Copyright" );
disp(result.Properties.CustomProperties.TargetFolder) %[output:5203555a]
disp(result) %[output:4fedafe4]
%%
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileType = "*.m", ...
  ExcludeMATLABCodeFile = true, ...
  TextPattern = "Copyright" );
disp(result.Properties.CustomProperties.TargetFolder) %[output:0df7c9c7]
disp(result) %[output:9b59a1e3]
%%
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = true, ...
  FileType = ["sample*.m", "sample*.mdl"], ...
  TextPattern = "This" + wildcardPattern + "test", ...
  IncludeStyledFilePath = true );
assert(not(isempty(result)), "No match.")
disp(result.Properties.CustomProperties.TargetFolder) %[output:4d3ad5e6]
disp(height(result)) %[output:8caea8d0]
disp(result) %[output:73b96687]
%%
result = TextSearchTool1.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = true, ...
  FileType = "*.m", ...
  TextPattern = textBoundary + "errorID" + wildcardPattern + "=", ...
  IncludeStyledFilePath = true );
assert(not(isempty(result)), "No match.")
disp(result.Properties.CustomProperties.TargetFolder) %[output:4930acda]
disp(height(result)) %[output:36ea6666]
disp(result(:, ["StyledFilePath", "LineNumber", "LineText"])) %[output:37dae4f4]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:473448cd]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:38652079]
%   data: {"dataType":"text","outputData":{"text":"    10\n\n","truncated":false}}
%---
%[output:7e2920a1]
%   data: {"dataType":"text","outputData":{"text":"                <strong>FilePath<\/strong>                <strong>LineNumber<\/strong>                         <strong>LineText<\/strong>                      \n    <strong>________________________________<\/strong>    <strong>__________<\/strong>    <strong>___________________________________________________<\/strong>\n\n    \"BEVProjectNavigationApp.m\"              5        \"% Copyright 2024-2025 The MathWorks, Inc.\"        \n    \"BEVProject_Description.m\"              35        \"%[text] *Copyright 2020-2025 The MathWorks, Inc.*\"\n    \"buildfile.m\"                           12        \"% Copyright 2023-2025 The MathWorks, Inc.\"        \n    \"uitest_BEVProject.m\"                   12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"      \n    \"uiuptodatetest_BEVProject.m\"           12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"      \n    \"unittest_BEVProject.m\"                 13        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n    \"unittest_BEVProject_settings.m\"        15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n    \"uptodatetest_BEVProject.m\"             15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n    \"ChangeLog.md\"                         335        \"_Copyright 2021-2023 The MathWorks, Inc._\"        \n    \"README.md\"                            329        \"_Copyright 2020-2025 The MathWorks, Inc._\"        \n\n","truncated":false}}
%---
%[output:1f77519e]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:570fc739]
%   data: {"dataType":"text","outputData":{"text":"     7\n\n","truncated":false}}
%---
%[output:9b8ebcac]
%   data: {"dataType":"text","outputData":{"text":"                <strong>FilePath<\/strong>                <strong>LineNumber<\/strong>                      <strong>LineText<\/strong>                   \n    <strong>________________________________<\/strong>    <strong>__________<\/strong>    <strong>_____________________________________________<\/strong>\n\n    \"BEVProjectNavigationApp.m\"              5        \"% Copyright 2024-2025 The MathWorks, Inc.\"  \n    \"buildfile.m\"                           12        \"% Copyright 2023-2025 The MathWorks, Inc.\"  \n    \"uitest_BEVProject.m\"                   12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"\n    \"uiuptodatetest_BEVProject.m\"           12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"\n    \"unittest_BEVProject.m\"                 13        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n    \"unittest_BEVProject_settings.m\"        15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n    \"uptodatetest_BEVProject.m\"             15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n\n","truncated":false}}
%---
%[output:5203555a]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:4fedafe4]
%   data: {"dataType":"text","outputData":{"text":"                <strong>FilePath<\/strong>                <strong>LineNumber<\/strong>                      <strong>LineText<\/strong>                   \n    <strong>________________________________<\/strong>    <strong>__________<\/strong>    <strong>_____________________________________________<\/strong>\n\n    \"BEVProjectNavigationApp.m\"              5        \"% Copyright 2024-2025 The MathWorks, Inc.\"  \n    \"buildfile.m\"                           12        \"% Copyright 2023-2025 The MathWorks, Inc.\"  \n    \"uitest_BEVProject.m\"                   12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"\n    \"uiuptodatetest_BEVProject.m\"           12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"\n    \"unittest_BEVProject.m\"                 13        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n    \"unittest_BEVProject_settings.m\"        15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n    \"uptodatetest_BEVProject.m\"             15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n\n","truncated":false}}
%---
%[output:0df7c9c7]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:9b59a1e3]
%   data: {"dataType":"text","outputData":{"text":"             <strong>FilePath<\/strong>             <strong>LineNumber<\/strong>                         <strong>LineText<\/strong>                      \n    <strong>__________________________<\/strong>    <strong>__________<\/strong>    <strong>___________________________________________________<\/strong>\n\n    \"BEVProject_Description.m\"        35        \"%[text] *Copyright 2020-2025 The MathWorks, Inc.*\"\n\n","truncated":false}}
%---
%[output:4d3ad5e6]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:8caea8d0]
%   data: {"dataType":"text","outputData":{"text":"     9\n\n","truncated":false}}
%---
%[output:73b96687]
%   data: {"dataType":"text","outputData":{"text":"                                            <strong>StyledFilePath<\/strong>                                                                                 <strong>FilePath<\/strong>                                         <strong>LineNumber<\/strong>                                                                                                                                                  <strong>LineText<\/strong>                                                                                                                                               \n    <strong>______________________________________________________________________________________________<\/strong>    <strong>__________________________________________________________________________________<\/strong>    <strong>__________<\/strong>    <strong>_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________<\/strong>\n\n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder1 > samplefunction_11.m\"    \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder1\\samplefunction_11.m\"          5       \"disp(\"This file is for testing.\")\"                                                                                                                                                                                                                                                                  \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder2 > samplescript21.m\"       \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder2\\samplescript21.m\"             1       \"% This script file is for testing.\"                                                                                                                                                                                                                                                                 \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder2 > samplescript21.m\"       \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder2\\samplescript21.m\"             5       \"disp(\"This file is for testing.\")\"                                                                                                                                                                                                                                                                  \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript31.m\"       \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder3\\samplescript31.m\"             1       \"% This script file is for testing.\"                                                                                                                                                                                                                                                                 \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript31.m\"       \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder3\\samplescript31.m\"             5       \"disp(\"This file is for testing.\")\"                                                                                                                                                                                                                                                                  \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript32.m\"       \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder3\\samplescript32.m\"             1       \"%[text] This plain-text Live Script is for testing.\"                                                                                                                                                                                                                                                \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript32.m\"       \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder3\\samplescript32.m\"             2       \"disp(\"This file is for testing.\") %[output:4c7842a9]\"                                                                                                                                                                                                                                               \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder3 > samplescript32.m\"       \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder3\\samplescript32.m\"            11       \"%   data: {\"dataType\":\"text\",\"outputData\":{\"text\":\"This file is for testing.\\n\",\"truncated\":false}}\"                                                                                                                                                                                                \n    \"Utility > TextSearchTool > Test > searchText > testfolder > subfolder1 > samplemodel_11.mdl\"     \"Utility\\TextSearchTool\\Test\\searchText\\testfolder\\subfolder1\\samplemodel_11.mdl\"        1001       \"&lt;p align=&quot;left&quot; style=&quot; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;&quot;&gt;&lt;span style=&quot; font-family:&apos;Arial&apos;; font-size:14px;&quot;&gt;This model is for ===testing===.&lt;\/span&gt;&lt;\/p&gt;\"\n\n","truncated":false}}
%---
%[output:4930acda]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:36ea6666]
%   data: {"dataType":"text","outputData":{"text":"    40\n\n","truncated":false}}
%---
%[output:37dae4f4]
%   data: {"dataType":"text","outputData":{"text":"                                               <strong>StyledFilePath<\/strong>                                                <strong>LineNumber<\/strong>                              <strong>LineText<\/strong>                           \n    <strong>_____________________________________________________________________________________________________<\/strong>    <strong>__________<\/strong>    <strong>_____________________________________________________________<\/strong>\n\n    \"Components > BatteryHighVoltage > +HighVoltageBatteryTool1 > refineOCVData.m\"                               21        \"errorID = \"refineOCVData:\";\"                                \n    \"Components > BatteryHighVoltage > +HighVoltageBatteryTool1 > refineTerminalResistanceData.m\"                21        \"errorID = \"refineTerminalResistanceData:\";\"                 \n    \"Components > MotorDriveUnit > Model-Basic > MotorDriveUnit_getBasicModelBlockInfo.m\"                        43        \"errorID = \"MotorDriveUnit_getBasicModelBlockInfo:\";\"        \n    \"Components > MotorDriveUnit > Model-SystemThermal > MotorDriveUnit_getSystemThermalModelBlockInfo.m\"        23        \"errorID = \"MotorDriveUnit_getSystemThermalModelBlockInfo:\";\"\n    \"Utility > AppTool > +LiteApp7 > +Utility > setupAppConfigFromConfigStruct.m\"                                17        \"errorID = \"setupAppConfigFromConfigStruct:failed\";\"         \n    \"Utility > CodeTool > +CodeTool1 > getDoubleOrSimscapeValueFromString.m\"                                     34        \"errorID = \"getDoubleOrSimscapeValueFromString:\";\"           \n    \"Utility > CodeTool > +CodeTool1 > getNumberArrayFromString.m\"                                               27        \"errorID = \"getNumberArrayFromString:\";\"                     \n    \"Utility > FileTool > +FileTool3 > findTextAndReplace.m\"                                                     98        \"errorID = \"findTextAndReplace:\";\"                           \n    \"Utility > FileTool > +FileTool3 > getFileFullPath.m\"                                                        34        \"errorID = \"getFileFullPath:\";\"                              \n    \"Utility > FileTool > +FileTool3 > getFolderFullPath.m\"                                                      24        \"errorID = \"getFolderFullPath:\";\"                            \n    \"Utility > FileTool > +FileTool3 > getLinkedCommandFromText.m\"                                               28        \"errorID = \"getLinkedCommandFromText:\";\"                     \n    \"Utility > FileTool > +FileTool3 > getUnusedFilename.m\"                                                      38        \"errorID = \"getUnusedFilename:\";\"                            \n    \"Utility > FileTool > +FileTool3 > isLiveScript.m\"                                                           14        \"errorID = \"isLiveScript:\";\"                                 \n    \"Utility > FileTool > +FileTool3 > isModelFile.m\"                                                            16        \"errorID = \"isModelFile:\";\"                                  \n    \"Utility > FileTool > +FileTool3 > isPlainTextLiveScript.m\"                                                  14        \"errorID = \"isPlainTextLiveScript:\";\"                        \n    \"Utility > FileTool > +FileTool3 > mustBeLiveScript.m\"                                                       13        \"errorID = \"mustBeLiveScript:\";\"                             \n    \"Utility > FileTool > +FileTool3 > mustBePlainTextLiveScript.m\"                                              13        \"errorID = \"mustBePlainTextLiveScript:\";\"                    \n    \"Utility > ModelTool > +ModelTool2 > buildPropertyDictionaryFromBlock.m\"                                     39        \"errorID = \"buildPropertyDictionaryFromBlock:\";\"             \n    \"Utility > ModelTool > +ModelTool2 > checkEditInCallbackButton.m\"                                            20        \"errorID = \"checkEditInCallbackButton:\";\"                    \n    \"Utility > ModelTool > +ModelTool2 > checkEditInCode.m\"                                                      36        \"errorID = \"checkEditInCode:\";\"                              \n    \"Utility > ModelTool > +ModelTool2 > checkRefSubInCallbackButton.m\"                                          20        \"errorID = \"checkRefSubInCallbackButton:\";\"                  \n    \"Utility > ModelTool > +ModelTool2 > checkRefSubInSetParam.m\"                                                26        \"errorID = \"checkRefSubInSetParam:\";\"                        \n    \"Utility > ModelTool > +ModelTool2 > findLookupTable1DBlocks.m\"                                              14        \"errorID = \"findLookupTable1DBlocks:\";\"                      \n    \"Utility > ModelTool > +ModelTool2 > findSimscapeBlocks.m\"                                                   16        \"errorID = \"findSimscapeBlocks:\";\"                           \n    \"Utility > ModelTool > +ModelTool2 > getSimscapeValueFromBlockParameter.m\"                                   24        \"errorID = \"getSimscapeValueFromBlockParameter:\";\"           \n    \"Utility > ModelTool > +ModelTool2 > plotLookupTable1DBlocks.m\"                                              29        \"errorID = \"plotLookupTable1DBlocks:\";\"                      \n    \"Utility > ModelTool > +ModelTool2 > saveModels.m\"                                                           38        \"errorID = \"saveModels:\";\"                                   \n    \"Utility > SignalTool > +SignalTool3 > buildPropertyDictionaryFromSimscapeBlock.m\"                           41        \"errorID = \"buildPropertyDictionaryFromSimscapeBlock:\";\"     \n    \"Utility > SignalTool > +SignalTool3 > checkSignalDesignMatrix.m\"                                            14        \"errorID = \"checkSignalDesignMatrix:\";\"                      \n    \"Utility > SignalTool > +SignalTool3 > getSignalDesignMatrixFromBlockDescription.m\"                          24        \"errorID = \"getSignalDesignMatrixFromBlockDescription:\";\"    \n    \"Utility > SignalTool > +SignalTool3 > getVectorsFromSignalDesignMatrix.m\"                                   25        \"errorID = \"getVectorsFromDesignMatrix:\";\"                   \n    \"Utility > SignalTool > +SignalTool3 > plotDifference.m\"                                                     57        \"errorID = \"plotDifference:\";\"                               \n    \"Utility > SignalTool > +SignalTool3 > plotLookupTable1D.m\"                                                  62        \"errorID = \"plotLookupTable1D:\";\"                            \n    \"Utility > SignalTool > +SignalTool3 > plotSimscapePSLookupTable1DBlock.m\"                                   20        \"errorID = \"plotSimscapePSLookupTable1DBlock:\";\"             \n    \"Utility > SignalTool > +SignalTool3 > plotSimulink1DLookupTableBlock.m\"                                     20        \"errorID = \"plotSimulink1DLookupTableBlock:\";\"               \n    \"Utility > SignalTool > +SignalTool3 > plotTimedData.m\"                                                      31        \"errorID = \"plotTimedData:\";\"                                \n    \"Utility > SignalTool > +SignalTool3 > validateSignalSetup_PSLookupTable1D.m\"                                14        \"errorID = \"validateSignalSetup_PSLookupTable1D:\";\"          \n    \"Utility > TextSearchTool > +TextSearchTool1 > newTextSearchTable.m\"                                         31        \"errorID = \"newTextSearchTable:\";\"                           \n    \"Utility > TextSearchTool > +TextSearchTool1 > searchText.m\"                                                 89        \"errorID = \"searchText:\";\"                                   \n    \"Utility > openInProject.m\"                                                                                  26        \"errorID = \"openInProject:\";\"                                \n\n","truncated":false}}
%---
