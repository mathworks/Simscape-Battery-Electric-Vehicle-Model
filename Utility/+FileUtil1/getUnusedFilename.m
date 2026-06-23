function filename = getUnusedFilename(default_name, NameValuePair)
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
% If it is also used, "2" is added, and so on until unused filename is found.
%
% The number added is capped at 100 by default. Use MaxCount option to change it.
%
% In case all checked filenames are unavailable, this function returns a filename pattern
% (by default, it is "*.m".)
% To issue an error rather than returning a pattern, use ReturnPatternIfNotSuccessful=false.
% uiputfile also accepts a filename pattern, but then it does not fill the filename
% in the dialog, and the user must manually specify filename.

% Copyright 2025 MathWorks, Inc.

arguments (Input)
  default_name (1,1) string = "untitled.m"
  NameValuePair.ReturnPatternIfNotSuccessful (1,1) logical = true
  NameValuePair.MaxCount (1,1) {mustBeInteger, mustBePositive} = 100
end  % arguments

arguments (Output)
  filename (1,1) string
end  % arguments

errorID = "getUnusedFilename:";

[~, base_filename, ext] = fileparts(default_name);

filename = base_filename + ext;

foldercontents = dir;
existing_files = foldercontents(not([foldercontents.isdir]));
existing_filenames = [string({existing_files.name})];

count = 1;
file_exists = false;
while ismember(filename, existing_filenames)
  if count > NameValuePair.MaxCount
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
  if NameValuePair.ReturnPatternIfNotSuccessful
    % The filenames searched in the above are all already used.
    % Return a filename pattern.
    % Returning a filename pattern rather than throwing an error is to make
    % any return value from this function usable for uiputfile.
    filename = "*" + ext;

    return

  else
    id = errorID + "CouldNotFindUnusedFilename";
    msg = CodeUtil1.i18n("Failed to find an unused file name.");

    throw(MException(id, msg))

  end  % if
end  % if
end  % function
