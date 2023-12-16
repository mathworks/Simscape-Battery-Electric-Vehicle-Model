function plan = buildfile
%% Define tasks for `buildtool` command
% Copyright 2023 The MathWorks, Inc.

top_folder = currentProject().RootFolder;

component_path = fullfile(top_folder, "Components", "BatteryHighVoltage");

test_definitions = [
  fullfile(component_path, "Test", "BatteryHV_UnitTest.m")
  fullfile(component_path, "Test", "BatteryHV_UnitTest_MQC.m")
  ];

% This `buildfile` function is used by `buildtool` to perform the following tasks.
%
% - Check code issues.
% - Run unit tests.
%
% To run this function, take the following steps.
%
% 1. Change the working folder to a folder where this function is stored.
%
% 2. Run `buildtool` in Command Window.
%    `buildtool` searches `buildfile.m` file in the working folder and uses it
%    to perform tasks defined in there.
%
% The test task used in this function is supported by R2023b or newer MATLAB.
% For information about `buildtool` and `buildfile.m`, see the documentation.
%
% - buildtool
%   https://mathworks.com/help/matlab/ref/buildtool.html
%
% - Task for running tests
%   https://mathworks.com/help/matlab/ref/matlab.buildtool.tasks.testtask-class.html

%% Create a build plan object
% A build plan object is required to define tasks.
% See the documentation for details.
% - https://mathworks.com/help/matlab/ref/buildplan.html

plan = buildplan(localfunctions);

%% Define a test task
% For information about the test task of buildtool, see the documentation.
% - https://mathworks.com/help/matlab/ref/matlab.buildtool.tasks.testtask-class.html

plan("Test") = matlab.buildtool.tasks.TestTask( ...
  SourceFiles = component_path, ...
  TestResults = ["test-results.xml", "test-results.pdf"], ...
  CodeCoverageResults = ["code-coverage.html", "code-coverage.xml"] );

plan("Test").Tests = test_definitions;

%% Define custom tasks
% These tasks are defined as local functions in this file.

plan("LiveScriptToJupyterNotebook").Inputs = "**/*.mlx";
plan("LiveScriptToJupyterNotebook").Outputs = replace(plan("LiveScriptToJupyterNotebook").Inputs, ".mlx", ".ipynb");
plan("LiveScriptToJupyterNotebook").Dependencies = ["CodeIssues" "Test"];

plan("LiveScriptToHTML").Inputs = "**/*.mlx";
plan("LiveScriptToHTML").Outputs = replace(plan("LiveScriptToHTML").Inputs, ".mlx", ".html");
plan("LiveScriptToHTML").Dependencies = ["CodeIssues" "Test"];

%% Add a task to identify code issues
% This is a built-in task, available from R2023b.
% See the documentation for details.
% - https://mathworks.com/help/matlab/ref/matlab.buildtool.tasks.codeissuestask-class.html
% You can run this task as follows.
%
%   buildtool CodeIssues
%

plan("CodeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
  Results = "code-issues.sarif");

%% Add a task for deleting outputs and traces
% This is a built-in task, available from R2023b.
% To delete the outputs and traces of all other tasks in the build file,
% run the "clean" task.
%
%   buildtool clean
%
% To delete the outputs and traces of certain tasks,
% specify the task names as a string vector.
% For example, delete the outputs and the trace of a task named "task1".
%
%   buildtool clean("task1")
%
% Delete the outputs and traces of several tasks.
%
%   buildtool clean(["task1" "task2" "task3"])
%
% See the documentation for more details.
% - https://mathworks.com/help/matlab/ref/matlab.buildtool.tasks.cleantask-class.html

plan("Clean") = matlab.buildtool.tasks.CleanTask;

%% Define default tasks
% Default tasks are executed when `buildtool` is called without any arguments.

plan.DefaultTasks = [
  "CodeIssues"
  "Test"
  "LiveScriptToJupyterNotebook"
  ];

end  % function


%% Custom task functions
% Custom task functions can be defined as local functions
% in the build file (this file).
%
% - Function name must end with the word "Task", which is case insensitive.
%   The build tool generates task names from task function names
%   by removing the "Task" suffix.
%   For example, a task function `testTask` results in a task named "test".
%
% - A task function must accept a TaskContext object as its first input,
%   even if the task ignores it.
%
% - The build tool treats the first help text line,
%   often called the H1 line, of the task function as the task description.


function LiveScriptToJupyterNotebookTask(context)
%% Export Live Scripts to Jupyter notebooks
% GitHub web site and VS code render Jupyter notebooks (`*.ipynb` files).
% Convert Live Scripts to Jupyter notebooks for viewing convenience.
% You can run this task as follows.
%
%   buildtool LiveScriptToJupyterNotebook
%

arguments
  context (1,1) matlab.buildtool.TaskContext
end

live_script_files = context.Task.Inputs.paths;
jupyter_files = context.Task.Outputs.paths;
for idx = 1 : numel(live_script_files)
  disp("Generating Jupyter notebook from Live Script:")
  disp("  " + live_script_files(idx))

  export(live_script_files(idx), jupyter_files(idx), Run=true);

end  % for
end  % function


function LiveScriptToHTMLTask(context)
%% Export Live Scripts to HTML
% You can run this task as follows.
%
%   buildtool LiveScriptToHTML
%

arguments
  context (1,1) matlab.buildtool.TaskContext
end

live_script_files = context.Task.Inputs.paths;
docFiles = context.Task.Outputs.paths;
for idx = 1 : numel(live_script_files)
  disp("Generating HTML from Live Script:")
  disp("  " + live_script_files(idx))

  export(live_script_files(idx), docFiles(idx), Run=true);

end  % for
end  % function
