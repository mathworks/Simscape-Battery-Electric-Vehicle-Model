function result = showMLX
files = [currentProject().Files.Path]';
result = files(endsWith(files, ".mlx"));
end
