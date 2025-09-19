function TrueOrFalse = isSimscapePSLookupTable1DBlock(BlockPath)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string
end  % arguments

arguments (Output)
  TrueOrFalse (1,1) logical
end  % arguments

model_name = extractBefore(BlockPath, "/");
load_system(model_name)

component_path = string(get_param(BlockPath, "ComponentPath"));
if component_path ~= "foundation.signal.lookup_tables.one_dimensional"
  TrueOrFalse = false;
else
  TrueOrFalse = true;
end  % if
end  % function
