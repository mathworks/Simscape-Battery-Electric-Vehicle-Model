function newPosition = adjustFigureHeightAndWindowYPosition(fig)
%% Adjusts/lowers the Y position of Figure window.
% The top part of the figure window can go above the monitor screen,
% making it invisible.
% This function lowers the Y position of the window.

% Copyright 2022 The MathWorks, Inc.

arguments
  fig (1,1) matlab.ui.Figure
end

iniPos = fig.Position;

iniY = iniPos(2);

% Lower the Y position.
newY = iniY - 420;

newPosition = [iniPos(1), newY, iniPos(3), iniPos(4)];

end
