function ResultTable = findAllSimscapeBlocks(ModelName)
% This function searches Simscape library blocks and Simscape Component blocks 
% in the specified model and returns a table containing the search result.
% A result table has three columns: BlockPath, BlockType, and MaskType.
% If no blocks were found, an empty table is returned.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  ModelName (1,1) string = ""
end  % arguments

arguments (Output)
  ResultTable table
end  % arguments

errorID = "findAllSimscapeBlocks:";

if ModelName == ""
  id = errorID + "ModelNotSpecified";
  msg = bevutil1.CodeUtil.i18n("Model name must be specified.");

  throw(MException(id, msg))

end  % if

load_system(ModelName)

handles_to_SimscapeBlocks = Simulink.findBlocksOfType(ModelName, "SimscapeBlock");
if isempty(handles_to_SimscapeBlocks)
  library_block_table = table.empty;
else
  blockpath_to_SimscapeBlocks = string(getfullname(handles_to_SimscapeBlocks));
  block_type = string(get_param(blockpath_to_SimscapeBlocks, "BlockType"));
  mask_type = string(get_param(blockpath_to_SimscapeBlocks, "MaskType"));
  library_block_table = table(blockpath_to_SimscapeBlocks, block_type, mask_type, VariableNames=["BlockPath", "BlockType", "MaskType"]);
end  % if

handles_to_SimscapeComponentBlocks = Simulink.findBlocksOfType(ModelName, "SimscapeComponentBlock");
if isempty(handles_to_SimscapeComponentBlocks)
  component_block_table = table.empty;
else
  blockpath_to_SimscapeComponentBlocks = string(getfullname(handles_to_SimscapeComponentBlocks));
  block_type = string(get_param(blockpath_to_SimscapeComponentBlocks, "BlockType"));
  mask_type = string(get_param(blockpath_to_SimscapeComponentBlocks, "MaskType"));
  component_block_table = table(blockpath_to_SimscapeComponentBlocks, block_type, mask_type, VariableNames=["BlockPath", "BlockType", "MaskType"]);
end  % if

if isempty(library_block_table) && isempty(component_block_table)
  % No blocks were found.
  ResultTable = table.empty;

elseif not(isempty(library_block_table)) && not(isempty(component_block_table))
  ResultTable = vertcat(library_block_table, component_block_table);

elseif not(isempty(library_block_table)) && isempty(component_block_table)
  ResultTable = library_block_table;

else
  ResultTable = component_block_table;

end  % if
end  % function
