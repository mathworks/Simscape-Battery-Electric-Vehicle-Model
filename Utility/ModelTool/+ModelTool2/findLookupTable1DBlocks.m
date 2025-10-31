%[text] # Find Lookup Table 1D Blocks
%[text] This function finds Simscape PS Lookup Table (1D) blocks and Simulink 1-D Lookup Table blocks in the specified subsystem layer and returns them as a vector of strings. If `SubsystemPath` is not specified, this function attemps to use `gcs`. The `SearchDepth` option is passed to the `Simulink.FindOptions` function.
function BlockPaths = findLookupTable1DBlocks(SubsystemPath, NameValuePair)

arguments (Input)
  SubsystemPath (1,1) string = ""
  NameValuePair.SearchDepth {mustBeInteger} = -1
end  % arguments

arguments (Output)
  BlockPaths (:,1) string
end  % arguments

errorID = "findLookupTable1DBlocks:";

if SubsystemPath == ""
  if isempty(gcs)

    id = errorID + "ModelIsNotSpecified";
    msg = CodeTool1.i18n("Model must be specified.");

    throw(MException(id, msg))

  end  % if
  SubsystemPath = string(gcs);
end

if contains(SubsystemPath, "/")
  model_name = extractBefore(SubsystemPath, "/");
else
  model_name = SubsystemPath;
end  % if

if not(bdIsLoaded(model_name))
  load_system(model_name)
end  % if

find_options = Simulink.FindOptions(SearchDepth = NameValuePair.SearchDepth);

ssc_lut_block_paths = string(getfullname(Simulink.findBlocksOfType( ...
  SubsystemPath, "SimscapeBlock", ...
  "ComponentPath", "foundation.signal.lookup_tables.one_dimensional", ...
  find_options)));

sl_lut_block_paths = string(getfullname(Simulink.findBlocksOfType( ...
  SubsystemPath, "Lookup_n-D", ...
  "NumberOfTableDimensions", "1", ...
  find_options)));

BlockPaths = [ssc_lut_block_paths; sl_lut_block_paths];

end  % function
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
