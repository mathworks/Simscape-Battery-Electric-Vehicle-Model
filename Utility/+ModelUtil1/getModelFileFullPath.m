function FullPath = getModelFileFullPath(ModelName)
% Get the full path to the specified model.
%
% Model name can be model filename, i.e., the model name can optionally include
% either ".mdl" or ".slx" file extension.
% Error is issued if there are two or more matches.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  ModelName (1,1) string
end  % arguments

arguments (Output)
  FullPath (1,1) string
end  % arguments

errorID = "getModelFileFullPath:";

if ModelName == ""
  id = errorID + "InvalidModelName";
  msg = CodeUtil1.i18n("Model name must be non-empty.");

  throw(MException(id, msg))

end  % if

% Multiple-match errors out.
result = FileUtil1.getFileFullPath(ModelName, ReturnIfNotFound=true);
if result ~= ""
  if not(endsWith(result, ".mdl")) && not(endsWith(result, ".slx"))
    id = errorID + "InvalidFileName";
    msg = CodeUtil1.i18n("Model file must ends with "".mdl"" or "".slx"".");

    throw(MException(id, msg))

  end  % if

  FullPath = result;

  return

end  % if

result = FileUtil1.getFileFullPath(ModelName+".mdl", ReturnIfNotFound=true);
if result ~= ""
  FullPath = result;

  return

end  % if

result = FileUtil1.getFileFullPath(ModelName+".slx", ReturnIfNotFound=true);
if result ~= ""
  FullPath = result;

  return

end  % if

id = errorID + "ModelFileNotFound";
msg = CodeUtil1.i18n("Model file was not found.");

throw(MException(id, msg))

end  % function
