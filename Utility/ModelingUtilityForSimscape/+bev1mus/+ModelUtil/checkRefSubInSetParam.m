function Result = checkRefSubInSetParam(CodeText, NameValuePair)
% This function checks if the given text contains code for setting a referenced subsystem
% in one of the following styles.
%   set_param(<block_path>, ReferencedSubsystem = "<refsub_name>")
%   set_param(<block_path>, "ReferencedSubsystem", "<refsub_name>")
%   (Double quotes can be single quotes.)
%
% This function returns a table where each row indicates if a found code line
% is actually referring to an existing file and if it is a referenced subsystem file.
%
% This function is designed to check if set_param for a subsystem reference is
% referring to an existing referenced subsystem file.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  CodeText (:,1) string
  NameValuePair.DisplayInfo (1,1) logical = true
  NameValuePair.MaxThreshold (1,1) {mustBeInteger, mustBePositive} = 100
end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "checkRefSubInSetParam:";

max_threshold = NameValuePair.MaxThreshold;

FileName = strings(max_threshold, 1);
Found = false(max_threshold, 1);
IsRefSub = false(max_threshold, 1);

lines = bev1mus.CodeUtil.cleanupCodeText(CodeText);
if isempty(lines)
  Result = table(strings(0,1), false(0,1), false(0,1), 'VariableNames', {'FileName','Found','IsRefSub'});

  return

end  % if

ospace = optionalPattern(whitespacePattern);

logical_index = startsWith(lines, ospace+"set_param(") & contains(lines, "ReferencedSubsystem");

lines = lines(logical_index);
% At this point, all lines are one of the followings.
%   set_param(<block_path>, ReferencedSubsystem = "<referenced_subsystem_file>")
%   set_param(<block_path>, "ReferencedSubsystem", "<referenced_subsystem_file>")

num_lines = numel(lines);

oquote = optionalPattern(""""|"'");
osep = optionalPattern("="|",");
refsub_names = extractBetween(lines, "ReferencedSubsystem"+oquote+ospace+osep+ospace+oquote, oquote+ospace+")");

for ii = 1 : num_lines
  if ii > max_threshold
    id = errorID + "TooMany";
    msg = bev1mus.CodeUtil.i18n("There are too many target code lines to process.");

    throw(MException(id, msg))

  end  % if

  if NameValuePair.DisplayInfo
    disp("Checking code [" + ii + "]: " + lines(ii))
  end  % if

  FileName(ii) = refsub_names(ii);

  target_fullpath = string( which(refsub_names(ii)));

  if target_fullpath == ""
    Found(ii) = false;
    IsRefSub(ii) = false;

  else
    Found(ii) = true;

    % Check that the file found is actually a referenced subsystem file.
    [~, refsub_name, ~] = fileparts(refsub_names(ii));
    close_later = false;
    if not(bdIsLoaded(refsub_name))
      close_later = true;
      load_system(refsub_name)
    end  % if

    isRefSubsystem = bdIsSubsystem(refsub_name);

    if close_later
      bdclose(refsub_name)
    end  % if
    IsRefSub(ii) = isRefSubsystem;
  end  % if
end  % for

FileName(num_lines+1 : end) = [];
Found(num_lines+1 : end) = [];
IsRefSub(num_lines+1 : end) = [];

Result = table(FileName, Found, IsRefSub);

end  % function
