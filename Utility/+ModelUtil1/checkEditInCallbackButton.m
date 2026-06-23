function Result = checkEditInCallbackButton(ModelName, NameValuePair)
% Check that the argument passed to the edit command used in a Callback Button exists.
%
% This function searches Callback Button blocks in the specified model and
% checks if the buttons use the edit commands.
% If yes, check that the argument passed to the edit commands exist in the MATLAB paths.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  ModelName (1,1) string = ""
  NameValuePair.Callback (1,1) string = "ClickFcn"
  NameValuePair.DisplayInfo (1,1) logical = false
end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "checkEditInCallbackButton:";

if ModelName == ""
  id = errorID + "InvalidModelName";
  msg = CodeUtil1.i18n("Model name must be specified.");

  throw(MException(id, msg))

end  % if

load_system(ModelName)

block_paths = string( getfullname( Simulink.findBlocksOfType(ModelName, "CustomCallbackButton")));
num_blocks = numel(block_paths);
if num_blocks == 0
  Result = table.empty;

  return

end  % if
result_for_each_block = cell(num_blocks, 1);
for ii = 1 : num_blocks
  target_block_path = block_paths(ii);
  if NameValuePair.DisplayInfo
    disp("Checking Callback Button [" + ii + "]: " + target_block_path)
  end  % if
  codetext = string( get_param( target_block_path, NameValuePair.Callback));
  lines = CodeUtil1.cleanupCodeText(codetext);
  try

    part_result = ModelUtil1.checkEditInCode(lines, DisplayInfo=NameValuePair.DisplayInfo);

  catch exception
    id = errorID + "InvalidCode";
    msg = target_block_path + ": " + NameValuePair.Callback + ": " + exception.message;

    throw(MException(id, msg))

  end  % try, catch
  col = table(repmat(target_block_path, height(part_result), 1), 'VariableNames', {'BlockPath'});
  tmp = horzcat(col, part_result);
  result_for_each_block{ii} = tmp;
end  % for
Result = vertcat(result_for_each_block{:});
end  % function
