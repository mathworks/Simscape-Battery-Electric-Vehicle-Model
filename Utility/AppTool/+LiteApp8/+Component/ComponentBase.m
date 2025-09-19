classdef ComponentBase < matlab.ui.componentcontainer.ComponentContainer
  % LiteApp base component
  %
  % This class implements common code used by most LiteApp components.
  % Inherit this component to implement a LiteApp component.
  %
  % Documentation
  %
  % - matlab.ui.componentcontainer.ComponentContainer
  %   https://www.mathworks.com/help/matlab/ref/matlab.ui.componentcontainer.componentcontainer-class.html

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    CommonFontSize (1,1) {mustBeInteger, mustBePositive} = LiteApp7.Constant.FontSize{"medium"}

    CommonPaddingTop = 2;
    CommonPaddingBottom = 2;
    CommonPaddingLeft = 4;
    CommonPaddingRight = 4;

    CommonPadding = [4 2 4 2]  % left bottom right top

    CommonColumnSpacing = 4
    CommonRowSpacing = 0

    CommonCharacterLimits = [0 1000]

    % The Theme property of this component is used to control the highlight background color only.
    % If the app does not use the background highlighting, it is safe to ignore this property.
    Theme (1,1) string {mustBeMember(Theme, ["dark" "light"])} = "dark"
    LightThemeBackGroundColor (1,1) string = "cyan"
    DarkThemeBackGroundColor (1,1) string = "#000099"
    HighlightBackground (1,1) matlab.lang.OnOffSwitchState = "off"

    base_grid (1,1) matlab.ui.container.GridLayout

  end  % properties

  methods (Access=protected)

    function setup(component)
      % uigridlayout creates 2-by-2 cells by default.
      % Specify [1 1] to create one cell.
      component.base_grid = uigridlayout(component, [1 1]);

      % Create one row and one column.
      % Expand the cell to the outer element by specifying '1x'.
      % FYI, the opposite of '1x' is 'fit', which shrinks the grid cell.
      component.base_grid.RowHeight = {'1x'};
      component.base_grid.ColumnWidth = {'1x'};

      % This base class sets spaces 0.
      % Override in the derived class if necessary. Don't change the values here.
      component.base_grid.Padding = [0 0 0 0];  % left bottom right top
      component.base_grid.ColumnSpacing = 0;
      component.base_grid.RowSpacing = 0;

    end  % function

    function update(~)
    end  % function

  end  % methods

end  % classdef
