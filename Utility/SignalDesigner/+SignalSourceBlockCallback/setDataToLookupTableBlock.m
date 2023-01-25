function setDataToLookupTableBlock(nvpairs)
%% Sets signal data to 1-D Lookup Table block in a model
%
% This function sets the signal data of Signal Designer object
% to 1-D Lookup Table block in a model.
% The model must be loaded for this function to work.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.SignalObject (1,1) SignalDesigner
  nvpairs.PathToBlock {mustBeText} = gcb

end

sig = nvpairs.SignalObject;
blkpath = nvpairs.PathToBlock;

xStr = "[" + num2str(sig.Data.X') + "]";
yStr = "[" + num2str(sig.Data.Y') + "]";

set_param(blkpath, 'Table', yStr)
set_param(blkpath, 'BreakpointsForDimension1', xStr)

end  % function
