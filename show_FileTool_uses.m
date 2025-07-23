function result = show_FileTool_uses
files = [currentProject().Files.Path]';
result = files(contains(files, "FileTool."));
end
