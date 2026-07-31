function fig = plotElevationAndRoadGradeProfiles(NameValuePair)
% Make plots of elevation profile and road grade profile.
%
% The original road grade data are plotted if the data are included in
% the CustomProperties, which must meet the following conditions.
%
% 1) PlotCoarseData option is set to true.
%
% 2) The custom properties were created by the getGradeProfileFromElevationProfile function.
%
% 3) The properties represent the original road grade data that were used to derive
%    the refined data for road grade and elevation.
%
% Thus, the field names and the data of the custom properties must match those
% created by getGradeProfileFromElevationProfile.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ParentAxes matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  % ThemeMode and Theme are valid only when 1) MATLAB is R2025a or newer and 2) ParentAxes is not specified.
  % Theme is ignored if ThemeMode is "auto".
  % These options correspond to the figure's equivalent options.
  % https://www.mathworks.com/help/matlab/ref/matlab.ui.figure.html
  NameValuePair.ThemeMode {mustBeMember(NameValuePair.ThemeMode, ["auto", "manual"])} = "auto"
  NameValuePair.Theme {mustBeMember(NameValuePair.Theme, ["light", "dark"])} = "light"

  % ProfileTable is ignored if DataSource is "direct".
  NameValuePair.DataSource (1,1) string {mustBeMember(NameValuePair.DataSource, ["direct", "table"])} = "direct"

  NameValuePair.HorizontalDistance = [-1 0 1]
  NameValuePair.GradePercent = [-1 -1 -1]
  NameValuePair.Elevation = [1 0 -1]
  % NameValuePair.HorizontalDistance = [ 0 50 100, 200 250 300, 400 450 500, 600 650 700, 800 850 900 ]
  % NameValuePair.GradePercent = [ 0 0 0, 5 5 5, 0 0 0, -2 -2 -2, 0 0 0 ]
  % NameValuePair.Elevation = [ 0 0 0, 2.5 5 7.5, 10 10 10, 9 8 7, 6 6 6 ]

  NameValuePair.ProfileTable (:,3) table ...
    = table(simscape.Value([-1; 0; 1], "m"), [0; 0; 0], simscape.Value([0; 0; 0], "m"), ...
    VariableNames = ["HorizontalDistance", "GradePercent", "Elevation"])

  % Refined data were generated from the original road grade data.
  % Use this option to plot the original data or not.
  NameValuePair.PlotCoarseData (1,1) logical = true

end  % arguments

arguments (Output)
  fig {mustBeScalarOrEmpty, mustBeA(fig, ["matlab.ui.Figure", "matlab.graphics.layout.TiledChartLayout"])}
end  % arguments

plot_coarse_data = false;

if NameValuePair.DataSource == "direct"
  refined_x_vec_value = NameValuePair.HorizontalDistance;
  refined_x_vec_unit = "";

  refined_grade_pct = NameValuePair.GradePercent;

  refined_elevation_value = NameValuePair.Elevation;
  refined_elevation_unit = "";

else
  % Data source is "table".
  tbl = NameValuePair.ProfileTable;

  refined_x_vec_ssc = tbl.HorizontalDistance;
  refined_x_vec_value = value(refined_x_vec_ssc);
  refined_x_vec_unit = string(unit(refined_x_vec_ssc));

  refined_grade_pct = tbl.GradePercent;

  refined_elevation_ssc = tbl.Elevation;
  refined_elevation_value = value(refined_elevation_ssc);
  refined_elevation_unit = string(unit(refined_elevation_ssc));

  if not(isempty(fieldnames(tbl.Properties.CustomProperties)))
    plot_coarse_data = NameValuePair.PlotCoarseData;
    cp = tbl.Properties.CustomProperties;

    coarse_x_vec_ssc = simscape.Value(cp.HorizontalDistance_value, cp.HorizontalDistance_unit);
    % Get the value of coarse_x_vec in the unit of refined_x_vec.
    coarse_x_vec_value = value(coarse_x_vec_ssc, refined_x_vec_unit);

    coarse_grade_pct = cp.RoadGradePercent;
  end  % if

end  % if

if isfield(NameValuePair, "ParentAxes")
  % NameValuePair.ParentAxes is guaranteed to be of type matlab.graphics.axis.Axes.
  ax = NameValuePair.ParentAxes;
  tl = tiledlayout(ax.Parent, 2, 1, TileSpacing="tight");
else
  fig = figure;
  if not(isMATLABReleaseOlderThan("R2025a"))
    fig.Theme = NameValuePair.Theme;
    fig.ThemeMode = NameValuePair.ThemeMode;
  end  % if
  tl = tiledlayout(fig, 2, 1, TileSpacing="tight");
end  % if

ax = nexttile(tl);
plot(ax, refined_x_vec_value, refined_elevation_value, LineWidth=2)
hold(ax, "on")
grid(ax, "on")
axis(ax, "padded")
title(ax, "Elevation")
if refined_elevation_unit ~= ""
  ylabel(ax, "(" + refined_elevation_unit + ")")
end  % if

ax = nexttile(tl);
plot(ax, refined_x_vec_value, refined_grade_pct, LineWidth=2)
hold(ax, "on")
grid(ax, "on")
axis(ax, "padded")
if plot_coarse_data
  sc = scatter(ax, coarse_x_vec_value, coarse_grade_pct, 60);
  sc.Marker = "x";
  sc.LineWidth = 1.4;
end  % if
title(ax, "Road grade")
ylabel(ax, "(%)")

if refined_x_vec_unit == ""
  xlabel(ax, "Horizontal position x")
else
  xlabel(ax, "Horizontal position x (" + refined_x_vec_unit + ")")
end  % if

if nargout == 0
  clear fig
end  % if
end  % function
