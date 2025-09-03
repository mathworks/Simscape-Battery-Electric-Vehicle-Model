function SignalDesignMatrix = getSignalDesignMatrixFromBlockDescription(BlockPath)
%% Find and return signal design matrix in block description
% This function returns a signal design matrix from Simscape PS Lookup Table (1D) block
% or Simulink 1-D Lookup Table block.
%
% This function extracts text between
%   % SignalDesignMatrix:start
% and
%   % SignalDesignMatrix:end
% from the Description property of the target block and returns it as a numeric matrix.
% The Description property is what get_param(block_path, "Description") returns.
% The extracted text is assumed to be properly representing a signal design matrix.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string
end  % arguments

arguments (Output)
  SignalDesignMatrix (:,3) double {mustBeMatrix, mustBeNumeric}
end  % arguments

errorID = "getSignalDesignMatrixFromBlockDescription:";

model_name = extractBefore(BlockPath, "/");

if not(bdIsLoaded(model_name))
  load_system(model_name)
end  % if

% Get all mask parameters at once.
% Simscape PS Lookup Table (1D) block has mask while Simulink 1-D Lookup Table block does not.
block_mask = Simulink.Mask.get(BlockPath);
invalid_block = false;
if isempty(block_mask)
  % must be Simulink 1-D Lookup Table block.
  if get_param(BlockPath, "BlockType") ~= "Lookup_n-D" || get_param(BlockPath, "NumberOfTableDimensions") ~= "1"
    invalid_block = true;
  end  % if

else
  % must be Simscape PS Lookup Table (1D) block.
  mask_params = block_mask.Parameters;
  Name = string({mask_params(:).Name}');
  Value = string({mask_params(:).Value}');

  component_path = Value(Name == "ComponentPath");
  if component_path ~= "foundation.signal.lookup_tables.one_dimensional"
    invalid_block = true;
  end  % if
end  % if

if invalid_block
  id = errorID + "InvalidBlock";
  msg = "Specified block is not PS Lookup Table (1D) block nor 1-D Lookup Table block: " + BlockPath;

  throw(MException(id, msg))

end  % if

description_text = get_param(BlockPath, "Description");

% Find a string assuming it properly represents a matrix.
extracted_text = extractBetween(description_text, "% SignalDesignMatrixStart" + newline, newline + "% SignalDesignMatrixEnd");
extracted_text = string(extracted_text{:});

if extracted_text == ""
  id = errorID + "InvalidDescription";
  msg = "Description has no signal design matrix text.";

  throw(MException(id, msg))

end  % if

SignalDesignMatrix = evalin("base", extracted_text);  % !todo: Avoid evaluation

end  % function
