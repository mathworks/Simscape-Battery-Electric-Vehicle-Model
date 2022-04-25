function windowPosition = adjustFigureHeightAndWindowYPosition(fig, NewHeight)
%% Adjusts the figure height and the Y position of Figure window.
% Making the figure taller than the default plot window height can
% make the top part of the window go outside the monitor screen.
% To prevent it, lower the Y position of the window,
% assuming that lowering the window position is more acceptable
% because the visibility of the window top is more important/convenient
% that of the window bottom.

% Copyright 2022 The MathWorks, Inc.

arguments
  fig (1,1) matlab.ui.Figure
  NewHeight (1,1) {mustBeInteger, mustBePositive}
end

pos = fig.Position;

figHeight_orig = 420;  % Default figure height

new_Y_pos = pos(2) - (NewHeight - figHeight_orig);

windowPosition = [pos(1), new_Y_pos, pos(3), NewHeight];

end
