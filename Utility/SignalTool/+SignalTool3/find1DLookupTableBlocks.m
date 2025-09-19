function BlockPaths = find1DLookupTableBlocks(ModelName)
% This function finds 1-D Lookup Table block in the specified model and returns
% the block path to it as string.
% If more than 2 blocks were found, block path strings are returned as a column vector.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  ModelName (1,1) string
end  % arguments

arguments (Output)
  BlockPaths (:,1) string
end  % arguments

if not(bdIsLoaded(ModelName))
  load_system(ModelName)
end  % if

BlockPaths = find_system(ModelName, BlockType="Lookup_n-D", NumberOfTableDimensions="1");
BlockPaths = string(BlockPaths);

end  % function
