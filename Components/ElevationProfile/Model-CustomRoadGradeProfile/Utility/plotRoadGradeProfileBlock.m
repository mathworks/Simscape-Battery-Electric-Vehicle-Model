function fig = plotRoadGradeProfileBlock(BlockPath, NameValuePair)

% Copyright 2026 The MathWorks, Inc.

arguments (Input)

  BlockPath (1,1) string = ""

  % Interpolation interval (for visualization)
  NameValuePair.InterpolationInterval (1,1) simscape.Value {bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan} ...
    = simscape.Value(nan)

  % Refined data were generated from the original road grade data.
  % Use this option to plot the original data or not.
  NameValuePair.PlotCoarseData (1,1) logical = true

end  % arguments

arguments (Output)
  % fig {mustBeScalarOrEmpty, mustBeA(fig, ["matlab.ui.Figure", "matlab.graphics.layout.TiledChartLayout"])}
  fig matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

errorID = "plotRoadGradeProfileBlock:";

if BlockPath == ""
  id = errorID + "InvalidBlockPath";
  msg = bevutil1.CodeUtil.i18n("Block path must be specified.");

  throw(MException(id, msg))

end  % if

refined_profile_data = buildElevationProfileFromRoadGradeProfileBlock( ...
  BlockPath, ...
  InterpolationInterval = NameValuePair.InterpolationInterval );

fig = plotElevationAndRoadGradeProfiles( ...
  DataSource = "table", ...
  ProfileTable = refined_profile_data, ...
  PlotCoarseData = NameValuePair.PlotCoarseData );

% fig.Children is a tiledlayout object.
fig.Children.Title.String = replace(BlockPath, "/", " > ");

% Prevent _ in the text to be interpreted as a TeX/LaTeX command.
fig.Children.Title.Interpreter = "none";

if nargout == 0
  clear fig
end  % if
end  % function
