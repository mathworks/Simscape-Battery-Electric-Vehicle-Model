function Result = findReplace(TopFolder, NameValuePair)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  TopFolder (1,1) string {mustBeFolder} = pwd

  NameValuePair.DryRun (1,1) logical = true

  % matlab.buildtool.io.Glob
  NameValuePair.FileNamePattern (1,1) string = "**/*"

  NameValuePair.SearchWord (1,1) string = ""
  NameValuePair.NewWord (1,1) string = ""
end  % arguments

arguments (Output)
  Result table
end  % arguments

target = fullfile(TopFolder, NameValuePair.FileNamePattern);
collection = matlab.buildtool.io.FileCollection.fromPaths(target);
file_paths = paths(collection);
num_files = numel(file_paths);

FilePath = strings(num_files, 1);
Found = false(num_files, 1);
Replaced = false(num_files, 1);

for ii = 1 : num_files
  target_file = file_paths(ii);
  FilePath(ii) = target_file;
  lines = readlines(target_file);

  if any(contains(lines, NameValuePair.SearchWord))
    Found(ii) = true;
    if not(NameValuePair.DryRun)
      newlines = replace(lines, NameValuePair.SearchWord, NameValuePair.NewWord);
      try
        writelines(newlines, FilePath(ii));
      catch exception

        rethrow(exception)

      end  % try, catch
      Replaced(ii) = true;
    end  % if
  end  % if
end  % for

FilePath(num_files+1 : end) = [];
Found(num_files+1 : end) = [];
Replaced(num_files+1 : end) = [];

Result = table(FilePath, Found, Replaced);
Result.Properties.UserData = dictionary(["SearchWord", "NewWord"], [NameValuePair.SearchWord, NameValuePair.NewWord]);
end  % function
