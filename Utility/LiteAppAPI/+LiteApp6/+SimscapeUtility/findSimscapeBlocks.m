function ResultTable = findSimscapeBlocks(ModelName)
% This function searches Simscape blocks in the specified model and returns
% a table containing three columns: BlockPath, BlockType, and MaskType.
% If no blocks were found, an empty table is returned.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  ModelName (1,1) string = ""
end  % arguments

arguments (Output)
  ResultTable table
end  % arguments

errorID = "findSimscapeBlocks:";

if ModelName == ""
  id = errorID + "ModelNotSpecified";
  msg = LiteApp6.Utility.i18n("Model name must be specified.");

  throw(MException(id, msg))

end  % if

load_system(ModelName)

handles_to_SimscapeBlocks = Simulink.findBlocksOfType(ModelName, "SimscapeBlock");
if isempty(handles_to_SimscapeBlocks)
  t_library_block = table.empty;
else
  blockpath_to_SimscapeBlocks = string(getfullname(handles_to_SimscapeBlocks));
  block_type = string(get_param(blockpath_to_SimscapeBlocks, "BlockType"));
  mask_type = string(get_param(blockpath_to_SimscapeBlocks, "MaskType"));
  t_library_block = table(blockpath_to_SimscapeBlocks, block_type, mask_type, VariableNames=["BlockPath", "BlockType", "MaskType"]);
end  % if

handles_to_SimscapeComponentBlocks = Simulink.findBlocksOfType(ModelName, "SimscapeComponentBlock");
if isempty(handles_to_SimscapeComponentBlocks)
  t_component_block = table.empty;
else
  blockpath_to_SimscapeComponentBlocks = string(getfullname(handles_to_SimscapeComponentBlocks));
  block_type = string(get_param(blockpath_to_SimscapeComponentBlocks, "BlockType"));
  mask_type = string(get_param(blockpath_to_SimscapeComponentBlocks, "MaskType"));
  t_component_block = table(blockpath_to_SimscapeComponentBlocks, block_type, mask_type, VariableNames=["BlockPath", "BlockType", "MaskType"]);
end  % if

if isempty(t_library_block) && isempty(t_component_block)
  % No blocks were found.
  ResultTable = table.empty;

elseif not(isempty(t_library_block)) && not(isempty(t_component_block))
  ResultTable = vertcat(t_library_block, t_component_block);

elseif not(isempty(t_library_block)) && isempty(t_component_block)
  ResultTable = t_library_block;

else
  ResultTable = t_component_block;

end  % if
end  % function
