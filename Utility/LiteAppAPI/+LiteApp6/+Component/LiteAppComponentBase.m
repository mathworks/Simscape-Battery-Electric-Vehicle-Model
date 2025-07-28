classdef LiteAppComponentBase < matlab.ui.componentcontainer.ComponentContainer
  %% Implementation of Lite App component
  % This class implements common code used by most Lite App components.
  % Inherit this component to implement a Lite App component.
  %
  % Documentation
  %
  % - matlab.ui.componentcontainer.ComponentContainer
  %   https://www.mathworks.com/help/matlab/ref/matlab.ui.componentcontainer.componentcontainer-class.html

  % Copyright 2023-2024 The MathWorks, Inc.

  %% Public properties

  properties

    CommonFontSize (1,1) {mustBeInteger, mustBePositive} = LiteApp6.Utility.Constant.FontSize{"medium"}

    CommonPaddingTop = 2;
    CommonPaddingBottom = 2;
    CommonPaddingLeft = 4;
    CommonPaddingRight = 4;

    CommonPadding = [4 2 4 2]  % left bottom right top

    CommonColumnSpacing = 4
    CommonRowSpacing = 0

    CommonCharacterLimits = [0 1000]

    HighlightBackground (1,1) matlab.lang.OnOffSwitchState = "off"
    HighlightBackgroundColor (1,1) string = "cyan"

  end  % properties

  properties (Access=protected)
    baseGridObject matlab.ui.container.GridLayout
  end  % properties

  methods (Access=protected)

    function setup(component)
      % uigridlayout creates 2-by-2 cells by default.
      % Specify [1 1] to create one cell.
      component.baseGridObject = uigridlayout(component, [1 1]);

      % Create one row and one column.
      % Expand the cell to the outside element by specifying '1x'.
      % FYI, the opposite of '1x' is 'fit', which shrinks the grid cell.
      component.baseGridObject.RowHeight = {'1x'};
      component.baseGridObject.ColumnWidth = {'1x'};

      % This base class sets spaces 0.
      % Override in the derived class if necessary. Don't change the values here.
      component.baseGridObject.Padding = [0 0 0 0];  % left bottom right top
      component.baseGridObject.ColumnSpacing = 0;
      component.baseGridObject.RowSpacing = 0;

      component.HighlightBackground = "off";

    end  % function

    function update(component)
      if component.HighlightBackground
        component.baseGridObject.BackgroundColor = component.HighlightBackgroundColor;
      end  % if
    end  % function

  end  % methods

end  % classdef
