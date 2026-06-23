classdef ComponentBase < matlab.ui.componentcontainer.ComponentContainer
  % AppUtil base component
  %
  % This class implements common code used by most of the AppUtil components.
  % Inherit this component to implement an AppUtil component.
  %
  % See also the documentation about matlab.ui.componentcontainer.ComponentContainer
  % https://www.mathworks.com/help/matlab/ref/matlab.ui.componentcontainer.componentcontainer-class.html

  % Copyright 2023-2026 The MathWorks, Inc.

  properties

    % MainFigure is used to react to the change in the primary uifigure's property.
    MainFigure (:,1) matlab.ui.Figure

    CommonFontSize (1,1) {mustBeInteger, mustBePositive} = AppUtil1.Constant.FontSize{"medium"}

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

    % The main grid is used to configure the width of the main component
    % while the base grid is used to configure the width of the whole component.
    main_grid (1,1) matlab.ui.container.GridLayout

    % To see outputs from the class constructor, you must set BaseReporting to "on" here.
    % Setting it to "on" in other ways do not enable reporting from the constructor.
    BaseReporting (1,1) matlab.lang.OnOffSwitchState = "off"

  end  % properties
  properties (Access=private)
    ThemeResponderDefined (1,1) logical = false
  end  % properties

  methods (Access=protected)

    function setup(component)
      if component.BaseReporting
        FileUtil1.displayTimeAndFileLocation("1")
      end  % if

      component.MainFigure = ancestor(component, "figure");

      % uigridlayout creates 2-by-2 cells by default.
      % Specify [1 1] to create one cell.
      component.base_grid = uigridlayout(component, [1 1]);

      % Create one row and one column.
      % Expand the cell to the outer element by specifying '1x'.
      % FYI, the opposite of '1x' is 'fit', which shrinks the grid cell.
      component.base_grid.RowHeight = {'1x'};
      component.base_grid.ColumnWidth = {'1x'};

      % This base class sets spaces to 0.
      % Override in the derived class if necessary. Don't change the values here.
      component.base_grid.Padding = [0 0 0 0];  % left bottom right top
      component.base_grid.ColumnSpacing = 0;
      component.base_grid.RowSpacing = 0;

      % The main grid can be overridden by the child component.
      component.main_grid = uigridlayout(component.base_grid, [1 1]);
      component.main_grid.RowHeight = {'1x'};
      component.main_grid.ColumnWidth = {'1x'};
      component.main_grid.Padding = [0 0 0 0];  % left bottom right top
      component.main_grid.ColumnSpacing = 0;
      component.main_grid.RowSpacing = 0;

      if not(isMATLABReleaseOlderThan("R2025a")) && not(isempty(component.MainFigure))
        if component.BaseReporting
          FileUtil1.displayTimeAndFileLocation("2")
        end  % if

        % Get the current theme setting from uifigure.
        theme_name = component.MainFigure.Theme.BaseColorStyle;
        component.ThemeNameForBackGroundHighlight = theme_name;

        % Prepare for responding to the theme change after the app opened.
        component.ThemeResponderDefined = true;
        % React when the component.MainFigure.Theme is changed.
        % eventData.AffectedObject is component.MainFigure, which is a matlab.ui.Figure object.
        addlistener(component.MainFigure, "Theme", "PostSet", @(~, eventData) ...
          respondToThemeChange(component, eventData.AffectedObject));
      end  % if
    end  % function

    function update(component)
      if component.HighlightBackground
        switch component.ThemeNameForBackGroundHighlight
          case "light"
            component.main_grid.BackgroundColor = component.LightThemeBackGroundColor;
          case "dark"
            component.main_grid.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

  end  % methods

  methods

    function respondToThemeChange(component, figureObject)
      arguments (Input)
        component
        figureObject matlab.ui.Figure
      end  % arguments
      if component.BaseReporting
        FileUtil1.displayTimeAndFileLocation
      end  % if
      theme_name = figureObject.Theme.BaseColorStyle;
      component.ThemeNameForBackGroundHighlight = theme_name;
    end  % function

  end  % methods
end  % classdef
