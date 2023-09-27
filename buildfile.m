function plan = buildfile
%%
% This is a function to automate custom build tasts for MATLAB projects.
% In this function, Jupyter notebooks and HTML files are generated from Live Scripts.
%
% For information about MATLAB Build Tools, see the documentation:
%
%   https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html

% Copyright 2023 The MathWorks, Inc.

plan = buildplan(localfunctions);
import matlab.buildtool.tasks.*;

plan("lint") = CodeIssuesTask(Results="results/issues.sarif");
plan("test") = TestTask(...
  TestResults=["results/test-results.xml", "results/test-results.pdf"], ...
  CodeCoverageResults=["results/coverage.html", "results/coverage.xml"], ...
  SourceFiles=pwd);

plan("jupyter").Inputs = "**/*.mlx";
plan("jupyter").Outputs = replace(plan("jupyter").Inputs, ".mlx",".ipynb");

plan("doc").Inputs = "**/*.mlx";
plan("doc").Outputs = replace(plan("doc").Inputs, ".mlx",".html");

plan("clean") = CleanTask;

plan.DefaultTasks = ["check", "lint", "test"];
end  % function


function jupyterTask(ctx)
% Generate Jupyer notebooks from all mlx files
mlxFiles = ctx.Task.Inputs.paths;
ipynbFiles = ctx.Task.Outputs.paths;
for idx = 1:numel(mlxFiles)
  disp("Building jupyter notebook from " + mlxFiles(idx))
  export(mlxFiles(idx), ipynbFiles(idx), Run=true);
end
end  % function


function docTask(ctx)
% Generate html doc notebooks from all mlx files
mlxFiles = ctx.Task.Inputs.paths;
docFiles = ctx.Task.Outputs.paths;
for idx = 1:numel(mlxFiles)
  disp("Building html doc from " + mlxFiles(idx))
  export(mlxFiles(idx), docFiles(idx), Run=true);
end
end  % function


function checkTask(~)
BEVProject_CheckProject;
end  % function
