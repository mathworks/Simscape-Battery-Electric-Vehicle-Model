%[text] # Check MATLAB Project
%[text] Running this script is basically the same as clicking the **Project Issues** button in the Project toolstrip. The main command is `runchecks`
%[text] - [https://www.mathworks.com/help/matlab/ref/matlab.project.project.runchecks.html](https://www.mathworks.com/help/matlab/ref/matlab.project.project.runchecks.html) \
disp("This is MATLAB " + matlabRelease().Release + ".") %[output:04d4bf83]
updateDependencies(currentProject);

checkResultArray = runChecks(currentProject);

resultTable = table(checkResultArray);
disp(resultTable(:, ["Passed", "Description"])) %[output:683e6c75]
%[text] Check all passed.
assert(all(resultTable.Passed))
%[text] *Copyright 2022-2026 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:04d4bf83]
%   data: {"dataType":"text","outputData":{"text":"This is MATLAB R2026a.\n","truncated":false}}
%---
%[output:683e6c75]
%   data: {"dataType":"text","outputData":{"text":"    <strong>Passed<\/strong>                                  <strong>Description<\/strong>                              \n    <strong>______<\/strong>    <strong>_______________________________________________________________________<\/strong>\n\n    true      \"All project definition files are under source control\"                \n    true      \"All project files are under source control\"                           \n    true      \"All files under source control are in the project\"                    \n    true      \"All project files and folders exist on the file system\"               \n    true      \"No case mismatch detected in project files, paths, and references\"    \n    true      \"All project folders on the MATLAB search path are on the project path\"\n    true      \"All projects in sub-folders are referenced by this project\"           \n    true      \"Project has no duplicates or missing built-in labels\"                 \n    true      \"No out of date P-code files\"                                          \n    true      \"No project files have unsaved changes\"                                \n    true      \"No models in the project have mismatching file formats\"               \n    true      \"No slprj or sfprj folders in the project\"                             \n\n","truncated":false}}
%---
