function is_newer = sourceFileIsNewer(NameValuePair)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  % Source file must exist.
  NameValuePair.Source (1,1) {mustBeFile}

  % Destination file may not exist.
  NameValuePair.Destination (1,1) string

  NameValuePair.DisplayInfo (1,1) logical = false
end  % arguments

arguments (Output)
  % This is true if either of these condisions is met:
  % - The source file is newer than the destination file.
  % - The destination file does not exist.
  is_newer (1,1) logical
end  % arguments

sourcefile_info = dir(NameValuePair.Source);
sourcefile_datetime = datetime(sourcefile_info.datenum, ConvertFrom="datenum");

if NameValuePair.DisplayInfo
  disp("Source time stamp")
  disp(sourcefile_datetime)
end  % if

if not(isfile(NameValuePair.Destination))
  % Destination file does not exist.
  is_newer = true;

  return

end  % if

destfile_info = dir(NameValuePair.Destination);
destfile_datetime = datetime(destfile_info.datenum, ConvertFrom="datenum");

if NameValuePair.DisplayInfo
  disp("Destination time stamp")
  disp(destfile_datetime)
end  % if

is_newer = (sourcefile_datetime > destfile_datetime);

end  % function
