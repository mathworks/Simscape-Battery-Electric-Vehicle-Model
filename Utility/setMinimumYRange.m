function setMinimumYRange(parent, ydata, nvpairs)
% adds an invisible plot to prevent the y-axis range from getting too narrow.

% Copyright 2021 The MathWorks, Inc.

arguments
  parent (1,1) matlab.graphics.axis.Axes
  ydata (1,:) double
  nvpairs.dy_threshold (1,1) double {mustBePositive}
  nvpairs.dy_plot (1,1) double {mustBePositive}
end

dy_threshold = nvpairs.dy_threshold;

if ~isfield(nvpairs, 'dy_plot')
  dy_plot = dy_threshold;
else
  dy_plot = nvpairs.dy_plot;
end

y_hi = max(ydata);
y_lo = min(ydata);
dy_data = y_hi - y_lo;
if abs(dy_data) < dy_threshold
  y_mean = (y_hi + y_lo) / 2;
  plot(parent, xlim, [y_mean-dy_plot/2, y_mean+dy_plot/2], ...
        "LineStyle","none", "Marker","none")
end

end
