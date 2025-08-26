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

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  CodeText (:,1) string
  NameValuePair.DisplayInfo (1,1) logical = false
end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "checkRefSubInSetParam:";

% This struct gets converted to a table and returned.
data = struct("FileName",[], "Found",[], "IsRefSub",[]);

lines = CodeTool1.cleanupCodeText(CodeText);
if isempty(lines)
  id = errorID + "EmptyCode";
  msg = CodeTool1.i18n("Code must be nonempty.");

  throw(MException(id, msg))

end  % if

ospace = optionalPattern(whitespacePattern);

logical_index = startsWith(lines, ospace+"set_param(") & contains(lines, "ReferencedSubsystem");

if nnz(logical_index) == 0
  data.FileName = "";
  data.Found = false;
  data.IsRefSub = false;
  Result = struct2table(data);

  return

end  % if

lines = lines(logical_index);

% At this point, all lines are one of the fopllowings.
%   set_param(<block_path>, ReferencedSubsystem = "<referenced_subsystem_file>")
%   set_param(<block_path>, "ReferencedSubsystem", "<referenced_subsystem_file>")

oquote = optionalPattern(""""|"'");
osep = optionalPattern("="|",");
refsub_names = extractBetween(lines, "ReferencedSubsystem"+oquote+ospace+osep+ospace+oquote, oquote+ospace+")");

for ii = 1 : numel(lines)
  if NameValuePair.DisplayInfo
    disp("Checking code [" + ii + "]: " + lines(ii))
  end  % if

  data(ii).FileName = refsub_names(ii);

  target_fullpath = string( which(refsub_names(ii)));

  if target_fullpath == ""
    data(ii).Found = false;
    data(ii).IsRefSub = false;

  else
    data(ii).Found = true;

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
    data(ii).IsRefSub = isRefSubsystem;
  end  % if
end  % for

Result = struct2table(data);

end  % function
