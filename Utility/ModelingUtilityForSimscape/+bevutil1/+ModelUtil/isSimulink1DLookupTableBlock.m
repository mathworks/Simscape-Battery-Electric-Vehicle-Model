function TrueOrFalse = isSimulink1DLookupTableBlock(BlockPath)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string
end  % arguments

arguments (Output)
  TrueOrFalse (1,1) logical
end  % arguments

model_name = extractBefore(BlockPath, "/");
load_system(model_name)

block_type = get_param(BlockPath, "BlockType");
if block_type ~= "Lookup_n-D"
  TrueOrFalse = false;

  return

end  % if

table_dim = get_param(BlockPath, "NumberOfTableDimensions");
if table_dim == "1"
  TrueOrFalse = true;
else
  TrueOrFalse = false;
end  % if
end  % function
