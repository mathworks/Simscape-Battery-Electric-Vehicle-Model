classdef ComponentBase < matlab.ui.componentcontainer.ComponentContainer
  % LiteApp base component
  %
  % This class implements common code used by most LiteApp components.
  % Inherit this component to implement a LiteApp component.
  %
  % Documentation about matlab.ui.componentcontainer.ComponentContainer
  % https://www.mathworks.com/help/matlab/ref/matlab.ui.componentcontainer.componentcontainer-class.html

  % Copyright 2023-2025 The MathWorks, Inc.

  properties
    % MainFigure property is used to react to the change in the primary uifigure's property.
    % If the component does not have to react, leave this property undefined.
    MainFigure (:,1) matlab.ui.Figure

    CommonFontSize (1,1) {mustBeInteger, mustBePositive} = LiteApp8.Constant.FontSize{"medium"}

    CommonPaddingTop = 2;
    CommonPaddingBottom = 2;
    CommonPaddingLeft = 4;
    CommonPaddingRight = 4;

    CommonPadding = [4 2 4 2]  % left bottom right top

    CommonColumnSpacing = 4
    CommonRowSpacing = 0

    CommonCharacterLimits = [0 1000]

    % The ThemeNameForBackGroundHighlight property is used to control the highlight background color only.
    % If the app does not use the background highlighting, it is safe to ignore.
    ThemeNameForBackGroundHighlight (1,1) string {mustBeMember(ThemeNameForBackGroundHighlight, ["dark" "light"])} = "light"
    LightThemeBackGroundColor (1,1) string = "#2DBEEF"
    DarkThemeBackGroundColor (1,1) string = "#309866" % #309866 = [0.1882 0.5941 0.4] ... summer 49
    CompositeGridColor (1,1) string = "#444444"
    HighlightBackground (1,1) matlab.lang.OnOffSwitchState = "off"

    base_grid (1,1) matlab.ui.container.GridLayout
  end  % properties

  properties (Access=private)
    ThemeResponderDefined (1,1) logical = false
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

    function update(component)
      if not(component.ThemeResponderDefined) && not(isempty(component.MainFigure))
        component.ThemeResponderDefined = true;
        % React when the component.MainFigure.Theme is changed.
        % eventData.AffectedObject is component.MainFigure, which is a matlab.ui.Figure object.
        addlistener(component.MainFigure, "Theme", "PostSet", @(~, eventData) ...
          respondToThemeChange(component, eventData.AffectedObject));
      end  % if
    end  % function

  end  % methods

  methods

    function respondToThemeChange(component, figureObject)
      arguments (Input)
        component
        figureObject matlab.ui.Figure
      end  % arguments
      theme_name = figureObject.Theme.BaseColorStyle;
      component.ThemeNameForBackGroundHighlight = theme_name;
    end  % function

  end  % methods
end  % classdef
