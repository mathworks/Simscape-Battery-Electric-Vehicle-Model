classdef WindowHeader < bevutil1.AppUtil.Component.ComponentBase
  % AppUtil Window Header component

  % Copyright 2024-2026 The MathWorks, Inc.

  properties

    AppName (1,1) string = bevutil1.CodeUtil.i18n("App")

    % If you want a hyperlink to the app source code,
    % assign mfilename to this property in your app code.
    % Leave this "" if you don't need the hyperlink.
    AppSourceName (1,1) string = ""

    UseCheckBoxForAlwaysOnTop (1,1) matlab.lang.OnOffSwitchState = "on"

    % Set a uifigure object to this if you want to use always-on-top check box.
    % Don't assign anything if you don't use the check box.
    % MainFigure matlab.ui.Figure {mustBeScalarOrEmpty}

    AppNameUI bevutil1.AppUtil.Component.Label
    SourceLinkUI bevutil1.AppUtil.Component.Hyperlink
    AlwaysOnTopUI bevutil1.AppUtil.Component.CheckBox

    % To see outputs from the setup method, you must set Reporting to "on" here.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"

  end  % properties

  properties (Dependent)
    AlwaysOnTop (1,1) matlab.lang.OnOffSwitchState
  end  % properties

  properties (Constant)
    common_height = bevutil1.AppUtil.Constant.Height{"oneline++"}
  end  % properties

  properties (Access=private)
    initialized (1,1) logical = false
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@bevutil1.AppUtil.Component.ComponentBase(component)

      if component.Reporting
        % This if-branch runs only when the default value of Reporting is "on".
        % Changing the value of Reporting via constructor name-value pair argument
        % or individual assignment takes effect after the setup method ends.
        bevutil1.FileUtil.displayTimeAndFileLocation("Within setup")
      end  % if

      % Create two rows.
      component.base_grid.RowHeight = {component.common_height, 'fit'};

      % Create three columns.
      % The setting of each element is overridden in the update method.
      component.base_grid.ColumnWidth = {'1x', 'fit', 'fit'};

      % -----------------------------------------------------------------------
      % App name

      component.AppNameUI = bevutil1.AppUtil.Component.Label(component.base_grid);
      component.AppNameUI.Layout.Row = 1;
      component.AppNameUI.Layout.Column = 1;
      component.AppNameUI.WordWrap = "off";

      % -----------------------------------------------------------------------
      % Hyperlink to app source code

      component.SourceLinkUI = bevutil1.AppUtil.Component.Hyperlink(component.base_grid);
      component.SourceLinkUI.Layout.Row = 1;
      component.SourceLinkUI.Layout.Column = 2;
      component.SourceLinkUI.ComponentHeight = component.common_height;
      component.SourceLinkUI.VerticalAlignment = "center";

      component.SourceLinkUI.Text = "Source";
      component.SourceLinkUI.HyperlinkClickedCallback = @() edit(component.AppSourceName);

      % -----------------------------------------------------------------------
      % Always-on-top check box

      component.AlwaysOnTopUI = bevutil1.AppUtil.Component.CheckBox(component.base_grid);
      component.AlwaysOnTopUI.Layout.Row = 1;
      component.AlwaysOnTopUI.Layout.Column = 3;
      component.AlwaysOnTopUI.ComponentHeight = component.common_height;
      component.AlwaysOnTopUI.VerticalAlignment = "center";
      component.AlwaysOnTopUI.Text = "Always on top";

      % -----------------------------------------------------------------------
      % Horizontal line

      component.base_grid.RowHeight{2} = 1;  % thickness of the line
      hline = uipanel(component.base_grid);
      hline.Layout.Row = 2;  % second row
      hline.Layout.Column = [1 3];
      hline.BorderType = "none";
      hline.BorderWidth = 0;
      hline.BackgroundColor = 0.5*ones(1,3);  % !todo: Use an abstract color name.

    end  % function

    function update(component)
      %%
      update@bevutil1.AppUtil.Component.ComponentBase(component)

      if component.initialized
        regular_update(component)

        return

      end  % if

      first_update(component)
      component.initialized = true;
    end  % function

    function regular_update(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("regular update")
        bevutil1.FileUtil.displayTimeAndFileLocation("component.AppName: " + component.AppName)
      end  % if

      % AppName can be defined by the user, first as the Name property of bevutil1.AppUtil.AppWindow.
      % Then it is passed to the AppName property of this class.
      % Because bevutil1.AppUtil.AppWindow class is a regular MATLAB class, not a child class of
      % the component container, the assigned value is available
      % only in the regular update cycle.
      component.AppNameUI.Text = "\textbf{" + component.AppName + "}";

      % ------------------------------------------------------------------------
      % hyperlink to app source code

      if component.AppSourceName == ""
        link_ui_width = 0;
        component.SourceLinkUI.Tooltip = "";
      else
        link_ui_width = 'fit';
        component.SourceLinkUI.Tooltip = "Open app source code: " + component.AppSourceName;
      end  % if
      component.base_grid.ColumnWidth{2} = link_ui_width;

    end  % function

    function first_update(component)
      %%
      % This runs only once after the first call to the drawnow,
      % which takes place after the setup method and property assignments finished.

      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("first update")
        bevutil1.FileUtil.displayTimeAndFileLocation("component.AppName: " + component.AppName)
      end  % if

      % ------------------------------------------------------------------------
      % Always-on-top check box

      if not(component.UseCheckBoxForAlwaysOnTop)
        if component.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("not creating always-on-top check box")
        end  % if
        checkbox_ui_width = 0;
        delete(component.AlwaysOnTopUI)

      else
        checkbox_ui_width = 'fit';

        if isempty(component.MainFigure)
          component.AlwaysOnTopUI.MainCheckBox.Enable = "off";
          component.AlwaysOnTopUI.MainCheckBox.Tooltip = bevutil1.CodeUtil.i18n("Main figure is not defined.");
        else
          component.AlwaysOnTopUI.ValueChangedCallback = @() react_CheckBox_ValueChanged(component);
        end  % if
      end  % if

      % The 2nd column of the base grid is used for a hyperlink to app source file.
      % The 'fit' setting below is temporary. It is updated in the regular update.
      % This is to allow an app wrapper function to set a link to its own file.
      component.base_grid.ColumnWidth = {'1x', 'fit', checkbox_ui_width};

    end  % function

  end  % methods

  methods

    function valid = check_AlwaysOnTopUI_IsValid(component)
      %%
      arguments (Output)
        valid (1,1) logical
      end  % arguments

      if not(isvalid(component.AlwaysOnTopUI))
        % ignore
        if component.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("invalid because always-on-top check box was not created")
        end  % if
        valid = false;

        return

      end  % if
      if isempty(component.MainFigure)
        if component.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("invalid because MainFigure is empty")
        end  % if
        valid = false;

        return

      end  % if
      valid = true;
    end  % function

    function on_or_off = get.AlwaysOnTop(component)
      %%
      arguments (Output)
        on_or_off (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      valid = check_AlwaysOnTopUI_IsValid(component);
      if not(valid)
        on_or_off = "off";

        return

      end  % if
      if component.MainFigure.WindowStyle == "alwaysontop"
        on_or_off = "on";
      else
        on_or_off = "off";
      end  % if
    end  % function

    function set.AlwaysOnTop(component, on_or_off)
      %%
      arguments
        component 
        on_or_off (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      valid = check_AlwaysOnTopUI_IsValid(component);
      if not(valid)

        return

      end  % if
      component.AlwaysOnTopUI.Value = on_or_off;
      configureWindowStyle(component, on_or_off)
    end  % function

    function react_CheckBox_ValueChanged(component)
      %%
      valid = check_AlwaysOnTopUI_IsValid(component);
      if not(valid)

        return

      end  % if
      configureWindowStyle(component, not(component.AlwaysOnTop))
    end  % function

    function configureWindowStyle(component, alwasy_on_top)
      %%
      arguments
        component 
        alwasy_on_top (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      if alwasy_on_top
        component.MainFigure.WindowStyle = "alwaysontop";
        if component.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("MainFigure.WindowStyle: alwaysontop")
        end  % if
      else
        component.MainFigure.WindowStyle = "normal";
        if component.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("MainFigure.WindowStyle: normal")
        end  % if
      end  % if
    end  % function

  end  % methods
end  % classdef
