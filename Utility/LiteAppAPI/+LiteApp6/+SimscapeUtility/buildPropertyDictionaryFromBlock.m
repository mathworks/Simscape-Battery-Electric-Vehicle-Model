function PropertyDictionary = buildPropertyDictionaryFromBlock(BlockPath)
% This function builds a dictionary of block property names and values from
% a Simscape block.
%
% This function loads the model, reads all the block parameters of a Simscape block,
% and builds and returns a dictionary of the properties.
%
% A successfully returning dictionary has the BlockType key, which
% is either "Library block" if the block is a library block
% or "Component block" if the block is a Simscape Component block.

% Documentation about key APIs
%
% get_param
% https://www.mathworks.com/help/simulink/slref/get_param.html
%
% Common Block Properties
% https://www.mathworks.com/help/simulink/slref/common-block-parameters.html
%
% Simulink.Mask Class
% https://www.mathworks.com/help/simulink/slref/simulink.mask-class.html
%
% Simulink.Mask.getWorkspaceVariables
% https://www.mathworks.com/help/simulink/slref/simulink.mask.simulink.mask.getworkspacevariables.html

% Copyright 2021-2025 The MathWorks, Inc.

arguments (Input)
  % BlockPath must start with model name, i.e., it is a full path to the block.
  % For example, the BlockPath of "friction1" block in "mymodel1" model is
  % "mymodel1/friction1".
  BlockPath string {mustBeScalarOrEmpty} = ""
end  % arguments

arguments (Output)
  PropertyDictionary (1,1) dictionary
end  % arguments

errorID = "buildPropertyDictionaryFromBlock:";

if BlockPath == "" || not(contains(BlockPath, "/"))
  id = errorID + "InvalidBlockPath";
  msg = LiteApp6.Utility.i18n("Empty block path is not allowed.");

  throw(MException(id, msg))

end  % if

ModelName = extractBefore(BlockPath, "/");

load_system(ModelName)

block_type = string(get_param(BlockPath, "BlockType"));
if block_type ~= "SimscapeBlock" && block_type ~= "SimscapeComponentBlock"
  id = errorID + "NotASimscapeBlock";
  msg = LiteApp6.Utility.i18n("Specified block is not a Simscape block: ") + BlockPath;

  throw(MException(id, msg))

end  % if

% Get all mask parameters at once.
block_mask = Simulink.Mask.get(BlockPath);
mask_params = block_mask.Parameters;

if all(size(mask_params) == [0 0])
  id = errorID + "NoParameter";
  msg = LiteApp6.Utility.i18n("Selected Simscape block has no parameters.");

  throw(MException(id, msg))

end  % if

Name = string({mask_params(:).Name}');
Value = string({mask_params(:).Value}');
PropertyDictionary = dictionary(Name, Value);

if block_type == "SimscapeBlock"
  PropertyDictionary("BlockType") = "Library block";
else  % block_type == "SimscapeComponentBlock"
  PropertyDictionary("BlockType") = "Component block";
end  % if

end  % function
