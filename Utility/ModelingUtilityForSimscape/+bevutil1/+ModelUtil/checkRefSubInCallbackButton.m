function Result = checkRefSubInCallbackButton(ModelName, NameValuePair)
% Check that the referenced subsystem used in a Callback Button exists.
%
% This function searches Callback Button blocks in the specified model and
% checks if the buttons use set_param to configure referenced subsystems.
% If so, check that the referenced subsystems exist.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  ModelName (1,1) string = ""
  NameValuePair.Callback (1,1) string = "ClickFcn"
  NameValuePair.DisplayInfo (1,1) logical = true
end  % arguments

arguments (Output)
  Result table
end  % arguments

errorID = "checkRefSubInCallbackButton:";

if ModelName == ""
  id = errorID + "InvalidModelName";
  msg = bevutil1.CodeUtil.i18n("Model name must be specified.");

  throw(MException(id, msg))

end  % if

load_system(ModelName)

block_paths = string( getfullname( Simulink.findBlocksOfType(ModelName, "CustomCallbackButton")));

num_blocks = numel(block_paths);

if num_blocks == 0
  Result = table.empty;

  return

end  % if

tmpresult = cell(num_blocks, 1);

for ii = 1 : num_blocks
  target_block_path = block_paths(ii);

  if NameValuePair.DisplayInfo
    disp("Checking Callback Button [" + ii + "]: " + target_block_path)
  end  % if

  codetext = string( get_param( target_block_path, NameValuePair.Callback));
  lines = bevutil1.CodeUtil.cleanupCodeText(codetext);
  data = bevutil1.ModelUtil.checkRefSubInSetParam(lines, DisplayInfo=NameValuePair.DisplayInfo);

  col = table(repmat(target_block_path, height(data), 1), 'VariableNames', {'BlockPath'});

  tmp = horzcat(col, data);
  tmpresult{ii} = tmp;
end  % for

Result = vertcat(tmpresult{:});

end  % function
