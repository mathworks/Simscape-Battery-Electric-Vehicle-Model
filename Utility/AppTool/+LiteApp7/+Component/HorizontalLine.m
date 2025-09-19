classdef HorizontalLine < matlab.ui.componentcontainer.ComponentContainer
  % Horizontal line, implemented using uipanel.

  % Unlike other components, this component directly inherits from
  % the component container because it makes this code much simpler.

  % Copyright 2023-2025 The MathWorks, Inc.

  methods (Access=protected)

    function setup(component)

      main_grid = uigridlayout(component, [1 1]);
      main_grid.RowSpacing = 0;
      main_grid.ColumnSpacing = 0;
      main_grid.Padding = [0 2 0 2];  % left bottom right top
      main_grid.ColumnWidth{1} = '1x';

      % This is the height/thickness of a horizontal line.
      main_grid.RowHeight{1} = 2;

      panel_ui = uipanel(main_grid);
      panel_ui.Layout.Row = 1;
      panel_ui.Layout.Column = 1;
      panel_ui.Title= "";
      panel_ui.BorderType = "none";

      % !todo: Support the dark/light themes.
      panel_ui.BackgroundColor = "#aaaaaa";  % Assuming light theme.

    end  % function

    % The udpate method in ComponentContainer class is an abstract method.
    % It must be implemented in the child class, even if its code is empty.
    function update(~)
    end  % function

  end  % methods
end  % classdef
