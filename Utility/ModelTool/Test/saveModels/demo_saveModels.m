%[text] # saveModels demo
%[text] 
[num_files_to_be_saved, tbl] = ModelTool2.saveModels( DryRun = true ); %[output:98e53862]
disp(num_files_to_be_saved) %[output:08dacc67]
head(tbl) %[output:9e2de35e]
%%
[num_files_to_be_saved, tbl] = ModelTool2.saveModels( DryRun = true, ...
  DisplayInfo = false, ...
  Target = "FolderTree", ...
  SpecifyTopFolder = true, ...
  TopFolder = fullfile(currentProject().RootFolder, "Components") );
disp(num_files_to_be_saved) %[output:3a962a0e]
head(tbl) %[output:9d5dfe10]
%%
[num_files_to_be_saved, tbl] = ModelTool2.saveModels( DryRun = true, ... %[output:group:47f2a59b] %[output:184b1e09]
  Target = "Project" ); %[output:group:47f2a59b] %[output:184b1e09]
disp(num_files_to_be_saved) %[output:499efb00]
head(tbl) %[output:4f5e4e3b]
%%
[num_files_to_be_saved, tbl] = ModelTool2.saveModels( DryRun = true, ...
  DisplayInfo = false, ...
  Target = "Project", ...
  SpecifyTopFolder = true, ...
  TopFolder = fullfile(currentProject().RootFolder, "Utility") );
disp(num_files_to_be_saved) %[output:9fa3c391]
head(tbl) %[output:6fb0fad0]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:98e53862]
%   data: {"dataType":"text","outputData":{"text":"This is MATLAB R2025a.\nNumber of model files found: 62\nThis is dry run.\nAll model files were already saved in this MATLAB release.\n","truncated":false}}
%---
%[output:08dacc67]
%   data: {"dataType":"text","outputData":{"text":"     0\n\n","truncated":false}}
%---
%[output:9e2de35e]
%   data: {"dataType":"text","outputData":{"text":"    <strong>to_be_saved<\/strong>                                    <strong>modelfiles_relpath<\/strong>                                \n    <strong>___________<\/strong>    <strong>__________________________________________________________________________________<\/strong>\n\n       false       \"BEV\\BEV_system_model.mdl\"                                                        \n       false       \"Components\\BEVController\\BEVMockModel\\BEV_MockModel_refsub.mdl\"                  \n       false       \"Components\\BEVController\\HarnessModel_BEVController.mdl\"                         \n       false       \"Components\\BEVController\\InputsForTesting\\HarnessModel_BEVController_Inputs.mdl\" \n       false       \"Components\\BEVController\\InputsForTesting\\Inputs_BEVController_Random_refsub.mdl\"\n       false       \"Components\\BEVController\\InputsForTesting\\Inputs_BEVController_Simple_refsub.mdl\"\n       false       \"Components\\BEVController\\Model-Basic\\BEVController_Basic_refsub.mdl\"             \n       false       \"Components\\BatteryHighVoltage\\HarnessModel_BatteryHV.mdl\"                        \n\n","truncated":false}}
%---
%[output:3a962a0e]
%   data: {"dataType":"text","outputData":{"text":"     0\n\n","truncated":false}}
%---
%[output:9d5dfe10]
%   data: {"dataType":"text","outputData":{"text":"    <strong>to_be_saved<\/strong>                              <strong>modelfiles_relpath<\/strong>                           \n    <strong>___________<\/strong>    <strong>_______________________________________________________________________<\/strong>\n\n       false       \"BEVController\\BEVMockModel\\BEV_MockModel_refsub.mdl\"                  \n       false       \"BEVController\\HarnessModel_BEVController.mdl\"                         \n       false       \"BEVController\\InputsForTesting\\HarnessModel_BEVController_Inputs.mdl\" \n       false       \"BEVController\\InputsForTesting\\Inputs_BEVController_Random_refsub.mdl\"\n       false       \"BEVController\\InputsForTesting\\Inputs_BEVController_Simple_refsub.mdl\"\n       false       \"BEVController\\Model-Basic\\BEVController_Basic_refsub.mdl\"             \n       false       \"BatteryHighVoltage\\HarnessModel_BatteryHV.mdl\"                        \n       false       \"BatteryHighVoltage\\InputsForTesting\\HarnessModel_BatteryHV_Inputs.mdl\"\n\n","truncated":false}}
%---
%[output:184b1e09]
%   data: {"dataType":"text","outputData":{"text":"This is MATLAB R2025a.\nNumber of model files found: 62\nThis is dry run.\nAll model files were already saved in this MATLAB release.\n","truncated":false}}
%---
%[output:499efb00]
%   data: {"dataType":"text","outputData":{"text":"     0\n\n","truncated":false}}
%---
%[output:4f5e4e3b]
%   data: {"dataType":"text","outputData":{"text":"    <strong>to_be_saved<\/strong>                                    <strong>modelfiles_relpath<\/strong>                                \n    <strong>___________<\/strong>    <strong>__________________________________________________________________________________<\/strong>\n\n       false       \"BEV\\BEV_system_model.mdl\"                                                        \n       false       \"Components\\BEVController\\BEVMockModel\\BEV_MockModel_refsub.mdl\"                  \n       false       \"Components\\BEVController\\HarnessModel_BEVController.mdl\"                         \n       false       \"Components\\BEVController\\InputsForTesting\\HarnessModel_BEVController_Inputs.mdl\" \n       false       \"Components\\BEVController\\InputsForTesting\\Inputs_BEVController_Random_refsub.mdl\"\n       false       \"Components\\BEVController\\InputsForTesting\\Inputs_BEVController_Simple_refsub.mdl\"\n       false       \"Components\\BEVController\\Model-Basic\\BEVController_Basic_refsub.mdl\"             \n       false       \"Components\\BatteryHighVoltage\\HarnessModel_BatteryHV.mdl\"                        \n\n","truncated":false}}
%---
%[output:9fa3c391]
%   data: {"dataType":"text","outputData":{"text":"     0\n\n","truncated":false}}
%---
%[output:6fb0fad0]
%   data: {"dataType":"text","outputData":{"text":"    <strong>to_be_saved<\/strong>                                             <strong>modelfiles_relpath<\/strong>                                         \n    <strong>___________<\/strong>    <strong>____________________________________________________________________________________________________<\/strong>\n\n       false       \"FileTool\\Test\\isModelFile\\testfolder\\subfolder1\\testmodel_isModelFile_11.mdl\"                      \n       false       \"FileTool\\Test\\isModelFile\\testfolder\\subfolder1\\testmodel_isModelFile_12.slx\"                      \n       false       \"FileTool\\Test\\isModelFile\\testfolder\\subfolder2\\testmodel_isModelFile_21.mdl\"                      \n       false       \"FileTool\\Test\\isModelFile\\testfolder\\subfolder2\\testmodel_isModelFile_22.slx\"                      \n       false       \"FileTool\\Test\\isModelFile\\testfolder\\testmodel_isModelFile_1.mdl\"                                  \n       false       \"FileTool\\Test\\isModelFile\\testfolder\\testmodel_isModelFile_2.slx\"                                  \n       false       \"ModelTool\\Test\\findLookupTable1DBlocks\\testmodel_findLookupTable1DBlocks_refsub.mdl\"               \n       false       \"ModelTool\\Test\\getSimscapeValueFromBlockParameter\\testmodel_getSimscapeValueFromBlockParameter.mdl\"\n\n","truncated":false}}
%---
