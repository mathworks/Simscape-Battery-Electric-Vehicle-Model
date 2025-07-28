function filename = getUnusedFilename(default_name)
% This function tries to find a filename which is not used in the current working folder.
% Use this function to find a filename which you can pass to uiputfile as default filename
% so that the user can just click the "Save" button if the default filename is fine.
%
% Example usage
%
%   filename = getUnusedFilename("untitled.json");  % namespace is omitted
%   [file, location] = uiputfile(filename);
%
% Description
%
% Provide a default filename, which is "untitled.m" if you don't provide.
% If the default filename (e.g., untitled.m) is already used,
% "1" is added at the end of the base filename (e.g, untitled1.m).
% If it is also used, "2" is added, and so on until the filename which is not used is found.
%
% In case all checked filenames are unavailable, this function returns a filename pattern
% (by default, it is "*.m".)
% uiputfile also accepts a filename pattern, but then it does not fill the filename
% in the dialog, and the user must manually specify filename.

% Copyright 2025 MathWorks, Inc.

arguments (Input)
  default_name (1,1) string = "untitled.m"
end  % arguments

arguments (Output)
  filename (1,1) string
end  % arguments

[~, base_filename, ext] = fileparts(default_name);

filename = base_filename + ext;

foldercontents = dir;
existing_files = foldercontents(not([foldercontents.isdir]));
existing_filenames = [string({existing_files.name})];

count = 1;
file_exists = false;
while ismember(filename, existing_filenames)
  if count > 100
    % Specified default filename has too many similar filenames in the current working folder.
    file_exists = true;

    break

  end  % if
  filename = base_filename + num2str(count) + ext;
  if ismember(filename, existing_filenames)
    file_exists = true;
    count = count + 1;

    continue

  else
    file_exists = false;

    break

  end  % if
end  % while
if file_exists
  % The filenames searched in the above are all already used.
  % Return a filename pattern.
  % Returning a filename pattern rather than throwing an error is to make
  % any return value from this function usable for uiputfile.
  filename = "*" + ext;
end  % if
end  % function
