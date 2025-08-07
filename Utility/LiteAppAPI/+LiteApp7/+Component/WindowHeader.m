classdef WindowHeader < LiteApp7.Component.LiteAppComponentBase
  %% LiteApp Window Header component

  % Copyright 2024-2025 The MathWorks, Inc.

  properties

    AppName (1,1) string = "LiteApp"

    % If you want a hyperlink to the app source code,
    % assign mfilename to this property in your app code.
    % Leave this "" if you don't need the hyperlink.
    AppSourceName (1,1) string = ""

    Show_AlwaysOnTop_CheckBox (1,1) matlab.lang.OnOffSwitchState = "off"

    % Set a uifigure object to this if you want to use alwas-on-top check box.
    % Don't assign anything if you don't use the check box.
    ParentFigure matlab.ui.Figure {mustBeScalarOrEmpty}

    % This turns on at the end of the first_setup method.
    Ready (1,1) logical = false

    AppNameUI LiteApp7.Component.Label
    SourceLinkUI LiteApp7.Component.Hyperlink
    AlwaysOnTopUI LiteApp7.Component.CheckBox

    % To see outputs from the setup method, you must set Reporting to "on" here.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"

  end  % properties

  properties (Dependent)
    AlwaysOnTop (1,1) matlab.lang.OnOffSwitchState
  end  % properties

  properties (Constant)
    common_height = LiteApp7.Constant.Height{"oneline++"}
  end  % properties

  properties (Access=private)
    initialized (1,1) logical = false
  end  % properties

  methods (Access=protected)

    function setup(component)
      %%
      setup@LiteApp7.Component.LiteAppComponentBase(component)

      if component.Reporting
        % This if-branch runs only when the default value of Reporting is "on".
        % Changing the value of Reporting via constructor name-value pair argument
        % or individual assignment takes effect after the setup method ends.
        FileTool2.displayTimeAndFileLocation("Within setup")
      end  % if

      % Create two rows.
      component.baseGridObject.RowHeight = {component.common_height, 'fit'};

      % Create three columns.
      % The setting of each element is overridden in the update method.
      component.baseGridObject.ColumnWidth = {'1x', 'fit', 'fit'};

      % -----------------------------------------------------------------------
      % App name

      component.AppNameUI = LiteApp7.Component.Label(component.baseGridObject);
      component.AppNameUI.Layout.Row = 1;
      component.AppNameUI.Layout.Column = 1;
      component.AppNameUI.WordWrap = "off";

      % -----------------------------------------------------------------------
      % Hyperlink to app source code

      component.SourceLinkUI = LiteApp7.Component.Hyperlink(component.baseGridObject);
      component.SourceLinkUI.Layout.Row = 1;
      component.SourceLinkUI.Layout.Column = 2;
      component.SourceLinkUI.ComponentHeight = component.common_height;
      component.SourceLinkUI.VerticalAlignment = "center";

      component.SourceLinkUI.HyperlinkText = "Source";
      % component.SourceLinkUI.Tooltip = "Open app source code: " + component.AppSourceName;
      component.SourceLinkUI.HyperlinkClickedCallback = @() edit(component.AppSourceName);

      % -----------------------------------------------------------------------
      % Always-on-top check box

      component.AlwaysOnTopUI = LiteApp7.Component.CheckBox(component.baseGridObject);
      component.AlwaysOnTopUI.Layout.Row = 1;
      component.AlwaysOnTopUI.Layout.Column = 3;
      component.AlwaysOnTopUI.ComponentHeight = component.common_height;
      component.AlwaysOnTopUI.VerticalAlignment = "center";
      component.AlwaysOnTopUI.Text = "Always on top";

      % -----------------------------------------------------------------------
      % Horizontal line

      component.baseGridObject.RowHeight{2} = 1;  % thicknesss of the line
      hline = uipanel(component.baseGridObject);
      hline.Layout.Row = 2;  % second row
      hline.Layout.Column = [1 3];
      hline.BorderType = "none";
      hline.BorderWidth = 0;
      hline.BackgroundColor = 0.5*ones(1,3);  % !todo: Use an abstract color name.

    end  % function

    function update(component)
      %%
      update@LiteApp7.Component.LiteAppComponentBase(component)

      if component.initialized
        regular_update(component)

        return

      end  % if

      first_update(component)
      component.Ready = true;
      component.initialized = true;
    end  % function

    function regular_update(component)
      %%
      if component.Reporting
        FileTool2.displayTimeAndFileLocation("regular update")
        FileTool2.displayTimeAndFileLocation("component.AppName: " + component.AppName)
      end  % if

      % AppName can be defined by the user, first as the Name property of LiteApp7.LiteAppWindow.
      % Then it is passed to the AppName property of this class.
      % Because LiteApp7.LiteAppWindow class is a regular MATLAB class, not a child class of
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
      component.baseGridObject.ColumnWidth{2} = link_ui_width;

    end  % function

    function first_update(component)
      %%
      % This runs only once after the first call to the drawnow,
      % which takes place after the setup method and property assignments finished.

      if component.Reporting
        FileTool2.displayTimeAndFileLocation("first update")
        FileTool2.displayTimeAndFileLocation("component.AppName: " + component.AppName)
      end  % if

      % ------------------------------------------------------------------------
      % Always-on-top check box

      if not(component.Show_AlwaysOnTop_CheckBox)
        if component.Reporting
          FileTool2.displayTimeAndFileLocation("not creating always-on-top check box")
        end  % if
        checkbox_ui_width = 0;
        delete(component.AlwaysOnTopUI)

      else
        checkbox_ui_width = 'fit';

        if isempty(component.ParentFigure)
          component.AlwaysOnTopUI.MainCheckBox.Enable = "off";
          component.AlwaysOnTopUI.MainCheckBox.Tooltip = "Parent figure is undefined";
        else
          component.AlwaysOnTopUI.ValueChangedCallback = @() toggleAlwaysOnTop(component);
        end  % if
      end  % if

      % The 2nd column of baseGridObject is used for a hyperlink to app source file.
      % The 'fit' setting below is temporary. It is updated in the regular_update method.
      % This is to allow an app wrapper function to set a link to its own file.
      component.baseGridObject.ColumnWidth = {'1x', 'fit', checkbox_ui_width};

    end  % function

  end  % methods

  methods

    function valid = check_AlwaysOnTopUI_IsValid(component)
      %%
      arguments (Output)
        valid (1,1) logical
      end

      if not(isvalid(component.AlwaysOnTopUI))
        % ignore
        if component.Reporting
          FileTool2.displayTimeAndFileLocation("invalid because always-on-top check box was not created")
        end  % if

        valid = false;

        return

      end  % if

      if isempty(component.ParentFigure)
        if component.Reporting
          FileTool2.displayTimeAndFileLocation("invalid because ParentFigure is empty")
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
      end

      valid = check_AlwaysOnTopUI_IsValid(component);
      if not(valid)
        on_or_off = "off";

        return

      end  % if

      if component.ParentFigure.WindowStyle == "alwaysontop"
        on_or_off = "on";
      else
        on_or_off = "off";
      end  % if

    end  % function

    function RawSetAlwaysOnTop(component, on_flag)
      %%
      arguments
        component 
        on_flag (1,1) matlab.lang.OnOffSwitchState
      end
      if on_flag
        component.ParentFigure.WindowStyle = "alwaysontop";
        if component.Reporting
          FileTool2.displayTimeAndFileLocation("ParentFigure.WindowStyle: alwaysontop")
        end  % if
      else
        component.ParentFigure.WindowStyle = "normal";
        if component.Reporting
          FileTool2.displayTimeAndFileLocation("ParentFigure.WindowStyle: normal")
        end  % if
      end  % if
    end  % function

    function set.AlwaysOnTop(component, on_or_off)
      %%
      arguments
        component 
        on_or_off (1,1) matlab.lang.OnOffSwitchState
      end

      valid = check_AlwaysOnTopUI_IsValid(component);
      if not(valid)

        return

      end  % if

      component.AlwaysOnTopUI.Value = on_or_off;

      RawSetAlwaysOnTop(component, on_or_off)

    end  % function

    function toggleAlwaysOnTop(component)
      %%
      valid = check_AlwaysOnTopUI_IsValid(component);
      if not(valid)

        return

      end  % if

      RawSetAlwaysOnTop(component, not(component.AlwaysOnTop))

    end  % function

  end  % methods

end  % classdef
