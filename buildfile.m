function plan = buildfile
plan = buildplan(localfunctions);
import matlab.buildtool.tasks.*;

plan("lint") = CodeIssuesTask(Results="results/issues.sarif");

if isempty(matlab.project.rootProject)
    p = matlab.project.loadProject(pwd);
    cl = onCleanup(@() p.close);
end
designFiles = replace(...
    [p.Files.findLabel("Classification","Design").File], ...
    p.RootFolder + filesep, "");
designFiles(~designFiles.endsWith([".m",".mlx"])) = [];

plan("test") = TestTask(...
    TestResults=["results/test-results.xml", "results/test-results.pdf"], ...
    CodeCoverageResults=["results/coverage.html", "results/coverage.xml"], ...
    SourceFiles=designFiles);

plan("jupyter").Inputs = "**/*.mlx";
plan("jupyter").Outputs = replace(plan("jupyter").Inputs, ".mlx",".ipynb");

plan("doc").Inputs = "**/*.mlx";
plan("doc").Outputs = replace(plan("doc").Inputs, ".mlx",".html");

plan("clean") = CleanTask;

plan.DefaultTasks = ["check", "lint", "test"];

end

function jupyterTask(ctx)
% Generate jupyer notebooks from all mlx files

mlxFiles = ctx.Task.Inputs.paths;
ipynbFiles = ctx.Task.Outputs.paths;
for idx = 1:numel(mlxFiles) 
    disp("Building jupyter notebook from " + mlxFiles(idx))
    export(mlxFiles(idx), ipynbFiles(idx), Run=true);
end
end

function docTask(ctx)
% Generate html doc notebooks from all mlx files

mlxFiles = ctx.Task.Inputs.paths;
docFiles = ctx.Task.Outputs.paths;
for idx = 1:numel(mlxFiles) 
    disp("Building html doc from " + mlxFiles(idx))
    export(mlxFiles(idx), docFiles(idx), Run=true);
end
end



function checkTask(~)
BEVProject_CheckProject;
end