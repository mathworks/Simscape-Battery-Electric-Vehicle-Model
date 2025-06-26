classdef HorizontalLine < matlab.ui.componentcontainer.ComponentContainer
  %% Panel component

  % Unlike other components, this component directly inherits from
  % the component container because it makes this code much simpler.

  % Copyright 2023-2024 The MathWorks, Inc.

  methods (Access=protected)

    function setup(component)

      % component.Layout.Column = 1;

      gridlayoutObj = uigridlayout(component, [1 1]);
      gridlayoutObj.RowSpacing = 0;
      gridlayoutObj.ColumnSpacing = 0;
      gridlayoutObj.Padding = [0 2 0 2];  % left bottom right top
      gridlayoutObj.ColumnWidth{1} = '1x';

      % This is the height/thickness of a horizontal line.
      gridlayoutObj.RowHeight{1} = 2;

      panelObj = uipanel(gridlayoutObj);
      panelObj.Layout.Row = 1;
      panelObj.Layout.Column = 1;
      panelObj.Title= "";
      panelObj.BorderType = "none";
      panelObj.BackgroundColor = "#aaaaaa";

    end  % function

    % The udpate method in ComponentContainer class is an abstract method.
    % It must be implemented in the child class.
    function update(~)
    end  % function

  end  % methods
end  % classdef
