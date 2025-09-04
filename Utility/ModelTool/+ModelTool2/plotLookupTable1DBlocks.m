%[text] # Plot Lookup Table 1D blocks
%[text] This function finds Simscape PS Lookup Table (1D) blocks and Simulink 1D Lookup Table blocks in the specified subsystem layer of a model and makes plots of them stacking vertically.
%[text] If `SubsystemPath` is not specified or is "", this function attemps to use `gcs`.
%[text] Use the `Blocks` option to specify the blocks to make plots. If this option is not specified, all lookup table 1D blocks in the specified subsystems layers are visualized.
%[text] Use the `SearchDepth` option to specify how many subsystems layers to seach lookup table blocks. By default, the search depth is 1.
function ReturnFigure = plotLookupTable1DBlocks(SubsystemPath, NameValuePair)

arguments (Input)

  SubsystemPath (1,1) string = ""

  NameValuePair.Blocks (1,:) string
  NameValuePair.SearchDepth {mustBeInteger} = 1

  NameValuePair.DivisionType {mustBeMember(NameValuePair.DivisionType, ["Divisions", "InterpolationInterval"])} = "Divisions"
  NameValuePair.Divisions (1,:) {mustBeInteger, mustBePositive} = 200
  NameValuePair.InterpolationInterval (1,:) {mustBePositive} = 0.1

  NameValuePair.ParentType {mustBeMember(NameValuePair.ParentType, ["Axes" "Panel"])} = "Axes"
  NameValuePair.ParentPanel (1,:) matlab.ui.container.Panel
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes

end  % arguments

arguments (Output)
  ReturnFigure {mustBeScalarOrEmpty, mustBeA(ReturnFigure, ["matlab.ui.Figure", "matlab.graphics.layout.TiledChartLayout"])}
end  % arguments

errorID = "plotLookupTable1DBlocks:";

if SubsystemPath == ""
  if isempty(gcs)

    id = errorID + "ModelIsNotSpecified";
    msg = CodeTool1.i18n("Model must be specified.");

    throw(MException(id, msg))

  end  % if
  SubsystemPath = string(gcs);
end

all_blocks = ModelTool2.findLookupTable1DBlocks(SubsystemPath, SearchDepth = NameValuePair.SearchDepth);
num_blocks = numel(all_blocks);
if num_blocks == 0

  id = errorID + "BlocksWereNotFound";
  msg = CodeTool1.i18n("No lookup table blocks were found.");

  throw(MException(id, msg))

end  % if

if not(isfield(NameValuePair, "Blocks"))
  % The Blocks option was not specified.
  % Use all 1D LUT blocks in the current subsystem layer.
  specified_blocks = all_blocks;

else
  specified_blocks = NameValuePair.Blocks;

  for idx = 1 : numel(specified_blocks)
    logical_index = endsWith(all_blocks, specified_blocks(idx));

    if not(any(logical_index))
      id = errorID + "SpecifiedBlocksNotFound";
      msg = CodeTool1.i18n("Specified block was found: " + specified_blocks(idx));

      throw(MException(id, msg));

    end  % if

    specified_blocks(idx) = all_blocks(logical_index);

  end  % for
end  % if
num_blocks = numel(specified_blocks);

if NameValuePair.ParentType == "Axes"
  if isfield(NameValuePair, "ParentAxes")
    ax = NameValuePair.ParentAxes;
    parent = ax.Parent;
  else
    parent = figure;
    parent.Position(3) = 600;
    parent.Position(4) = 600;
  end  % if
else
  % ParentType == "Panel"
  parent = NameValuePair.ParentPanel;
end  % if

vertical_tile = tiledlayout(parent, "vertical");
vertical_tile.TileSpacing = "tight";

% First pass - find the maximum X value.
xmaxvalues = nan(num_blocks, 1);
for idx = 1 : num_blocks
  block_path = specified_blocks(idx);

  if ModelTool2.isSimulink1DLookupTableBlock(block_path)
    xdata = eval(get_param(block_path, "BreakpointsForDimension1"));
    xmaxvalues(idx) = xdata(end);
  elseif ModelTool2.isSimscapePSLookupTable1DBlock(block_path)
    xdata = eval(get_param(block_path, "x"));
    xmaxvalues(idx) = xdata(end);
  end  % if
end  % for
x_max = max(xmaxvalues);

% Find Signal Specification blocks.
% This logic is only for Simulink 1-D Lookup Table blocks.
subsystem_path = extractBefore(specified_blocks, "/" + wildcardPattern(Except="/") + textBoundary("end"));
subsystem_path = unique(subsystem_path);
options = Simulink.FindOptions(SearchDepth = 1);
sigspec_blocks = string(getfullname(Simulink.findBlocksOfType(subsystem_path, "SignalSpecification", options)));

for idx = 1 : num_blocks
  block_fullpath = specified_blocks(idx);

  if NameValuePair.SearchDepth == 1
    % Use block name only.
    title_text = extractAfter(block_fullpath, asManyOfPattern(wildcardPattern+"/"));
  else
    % Show the relative path for the block.
    title_text = extractAfter(block_fullpath, SubsystemPath + "/");
    title_text = replace(title_text, "/", " / ");
  end  % if

  if ModelTool2.isSimulink1DLookupTableBlock(block_fullpath)
    logical_index = sigspec_blocks == block_fullpath + " unit";
    if any(logical_index)
      unitspec_block = sigspec_blocks(logical_index);
      unit_text = string(get_param(unitspec_block, "Unit"));
      title_text = title_text + " (" + unit_text + ")";
    end  % if
    SignalTool3.plotSimulink1DLookupTableBlock(block_fullpath, ParentAxes=nexttile(vertical_tile), PlotXUpperBound=x_max, ...
      DivisionType = NameValuePair.DivisionType, ...
      Divisions = NameValuePair.Divisions, ....
      InterpolationInterval = NameValuePair.InterpolationInterval, ...
      Title = title_text )

  elseif ModelTool2.isSimscapePSLookupTable1DBlock(block_fullpath)
    unit_text = string(get_param(block_fullpath, "f_unit"));
    if unit_text ~= "1"
      title_text = title_text + " (" + unit_text + ")";
    end  % if
    SignalTool3.plotSimscapePSLookupTable1DBlock(block_fullpath, ParentAxes=nexttile(vertical_tile), PlotXUpperBound=x_max, ...
      DivisionType = NameValuePair.DivisionType, ...
      Divisions = NameValuePair.Divisions, ....
      InterpolationInterval = NameValuePair.InterpolationInterval, ...
      Title = title_text )

  end  % if
end  % for

if nargout > 0
  ReturnFigure = parent;
end  % if
end  % function
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
