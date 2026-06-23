function BlockPaths = findSimscapeBlocks(ModelName, SimscapeBlockNames)
% Find block paths to the specified Simscape blocks in the model.
%
% This function takes 2 arguments. First argument is a model name.
% Second argument is a scalar string or a string array, representing
% block name which get_param(block_path, "MaskType") returns, such as
% "Mass", "PS Ramp", etc., that are defined in Simscape source files.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  ModelName (1,1) string = ""
  SimscapeBlockNames (1,:) string = ""
end  % arguments

arguments (Output)
  BlockPaths (:,1) string
end  % arguments

errorID = "findSimscapeBlocks:";

if ModelName == ""
  id = errorID + "InvalidModelName";
  msg = CodeUtil1.i18n("Model name must be specified.");

  throw(MException(id, msg))

end  % if

load_system(ModelName)

if SimscapeBlockNames == ""
  id = errorID + "InvalidSimscapeBlockName";
  msg = CodeUtil1.i18n("Simscape block name must be specified.");

  throw(MException(id, msg))

end  % if

blocks_table = ModelUtil1.findAllSimscapeBlocks(ModelName);

if isempty(blocks_table)
  id = errorID + "SimscapeBlockNotFound";
  msg = CodeUtil1.i18n("Specified model does not have any Simscape blocks.");

  throw(MException(id, msg))

end  % if

if not(ismember(SimscapeBlockNames, blocks_table.MaskType))
  id = errorID + "TargetBlockNotFound";
  msg = CodeUtil1.i18n("The specified block was not found in the specified model.");

  throw(MException(id, msg))

end  %if

logical_index_column = any(blocks_table.MaskType==SimscapeBlockNames, 2);
result_table = blocks_table(logical_index_column, "BlockPath");
BlockPaths = result_table.BlockPath;
end  % function
