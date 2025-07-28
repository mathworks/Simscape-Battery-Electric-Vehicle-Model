classdef LiteAppWindow < handle
  %% Lite App Window

  % Copyright 2023-2025 The MathWorks, Inc.

  properties

    MainFigure matlab.ui.Figure {mustBeScalarOrEmpty}

    Name (1,1) string

    MainLayout LiteApp6.LiteAppLayout

    HeaderUI LiteApp6.Component.WindowHeader
    Show_AlwaysOnTop_CheckBox matlab.lang.OnOffSwitchState = "on"

    % To see outputs from class constructors, you must set Reporting to "on" here.
    % Setting Reporting to "on" in other ways do not enable reporting from constructors.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"

  end  % properties

  properties (Dependent)
    Width (1,1) {mustBeInteger, mustBePositive}
    Height (1,1) {mustBeInteger, mustBePositive}

    AlwaysOnTop matlab.lang.OnOffSwitchState

    % PNG file
    Icon (1,1) string
  end  % properties

  properties (Access = private)
    useWindowHeader matlab.lang.OnOffSwitchState = "on"
  end  % properties

  properties (Access=private)
    % The default icon file must exist in the "+LiteApp6" namespace folder.
    DefaultIcon (1,1) string = "LiteApp-icon-150x150.png"
  end  % properties

  methods

    function delete(AppWindow)
      delete(AppWindow.MainFigure)
    end  % function

    function AppWindow = LiteAppWindow(NameValuePair)
      %%
      arguments (Input)
        % The "Source" hyperlink is created to this string at the top right of the app window.
        % Typically, you want to use mfilename for this argument.
        % If this is empty, the Source hyperlink is not added to the app window.
        NameValuePair.SourceFilename (1,1) string = ""

        NameValuePair.UseWindowHeader (1,1) matlab.lang.OnOffSwitchState = "on"

        NameValuePair.Reporting (1,1) matlab.lang.OnOffSwitchState = "off"
      end  % arguments

      arguments (Output)
        AppWindow (1,1)
      end  % arguments

      AppWindow.Reporting = NameValuePair.Reporting;
      if AppWindow.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("Constructor")
      end  % if

      AppWindow.MainFigure = uifigure(Visible = "off");

      AppWindow.MainLayout = LiteApp6.LiteAppLayout(AppWindow.MainFigure);

      AppWindow.Icon = "LiteApp-icon-150x150.png";

      AppWindow.useWindowHeader = NameValuePair.UseWindowHeader;
      if AppWindow.useWindowHeader
        if AppWindow.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("Using window header")
        end  % if
        AppWindow.HeaderUI = LiteApp6.Component.WindowHeader(NewArea(AppWindow.MainLayout));
        AppWindow.HeaderUI.ParentFigure = AppWindow.MainFigure;
        AppWindow.HeaderUI.AppSourceName = NameValuePair.SourceFilename;
        AppWindow.HeaderUI.Show_AlwaysOnTop_CheckBox = "on";
        AppWindow.HeaderUI.Reporting = AppWindow.Reporting;
      else
        AppWindow.Show_AlwaysOnTop_CheckBox = "off";
      end  % if
    end  % function

    function Show(AppWindow)
      %%
      AppWindow.MainFigure.Position(3) = AppWindow.Width;
      AppWindow.MainFigure.Position(4) = AppWindow.Height;

      if AppWindow.Reporting
        LiteApp6.Utility.displayTimeAndFileLocation("Visible has been set to ""on""")
      end  % if

      if AppWindow.Name == ""
        AppWindow.MainFigure.Name = "LiteApp";
      else
        AppWindow.MainFigure.Name = AppWindow.Name;
      end  % if

      if AppWindow.useWindowHeader
        if AppWindow.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("Updating window header")
        end  % if

        AppWindow.HeaderUI.AppName = AppWindow.MainFigure.Name;

        if AppWindow.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("AppWindow.MainFigure.Name: " + AppWindow.MainFigure.Name)
        end  % if

        AppWindow.HeaderUI.Show_AlwaysOnTop_CheckBox = AppWindow.Show_AlwaysOnTop_CheckBox;

        if AppWindow.Show_AlwaysOnTop_CheckBox
          AppWindow.HeaderUI.AlwaysOnTop = AppWindow.AlwaysOnTop;
        else
          % If the always-on-top check box is hidden, alwas-on-top must be off.
          AppWindow.HeaderUI.AlwaysOnTopUI.Value = "off";
        end  % if
      end  % if, use window header

      movegui(AppWindow.MainFigure, "center")
      AppWindow.MainFigure.Visible = "on";
      drawnow
    end  % function

    % -------------------------------------------------------------------------
    % width

    function width_pixel = get.Width(AppWindow)
      width_pixel = AppWindow.MainFigure.Position(3);
    end  % function

    function set.Width(AppWindow, width_pixel)
      arguments (Input)
        AppWindow
        width_pixel (1,1) {mustBeInteger, mustBePositive}
      end
      AppWindow.MainFigure.Position(3) = width_pixel;
    end  % function

    % -------------------------------------------------------------------------
    % height

    function height_pixel = get.Height(AppWindow)
      height_pixel = AppWindow.MainFigure.Position(4);
    end  % function

    function set.Height(AppWindow, height_pixel)
      arguments (Input)
        AppWindow
        height_pixel (1,1) {mustBeInteger, mustBePositive}
      end
      AppWindow.MainFigure.Position(4) = height_pixel;
    end  % function

    % -------------------------------------------------------------------------
    % icon

    function Icon = get.Icon(AppWindow)
      Icon = AppWindow.MainFigure.Icon;
    end  % function

    function set.Icon(AppWindow, PNGFilename)
      arguments (Input)
        AppWindow
        PNGFilename (1,1) string
      end

      if PNGFilename == AppWindow.DefaultIcon
        try
          liteapp_folder_fullpath = LiteApp6.Utility.getFolderFullPath("+LiteApp6");
        catch exception
          if AppWindow.MainFigure.Visible
            title_word = LiteApp6.Utility.i18n("Error");

            uialert(AppWindow.MainFigure, exception.message, title_word)

          else

            rethrow(exception)

          end  % if
        end  % try, catch
        % The default icon file must exist in the "+LiteApp6" namespace folder.
        icon_fullpath = fullfile(liteapp_folder_fullpath, PNGFilename);

      else
        % Custom icon
        try
          icon_fullpath = LiteApp6.Utility.getFileFullPath(PNGFilename);
        catch exception
          if AppWindow.MainFigure.Visible
            title_word = LiteApp6.Utility.i18n("Error");

            uialert(AppWindow.MainFigure, exception.message, title_word)

          else

            rethrow(exception)

          end  % if
        end  % try, catch
      end  % if

      AppWindow.MainFigure.Icon = icon_fullpath;

    end  % function

    % -------------------------------------------------------------------------
    % always on top

    function on_off = get.AlwaysOnTop(AppWindow)
      %%
      arguments (Output)
        on_off (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      on_off = AppWindow.HeaderUI.AlwaysOnTop;
    end  % function

    function set.AlwaysOnTop(AppWindow, on_or_off)
      %%
      % This method works if the header UI is used and the always-on-top check box is visible.
      % For other cases, this method does nothing.
      arguments (Input)
        AppWindow
        on_or_off (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      if AppWindow.Show_AlwaysOnTop_CheckBox
        AppWindow.HeaderUI.AlwaysOnTop = on_or_off;
        if AppWindow.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("AppWindow.HeaderUI.AlwaysOnTop: " + on_or_off)
        end  % if
      else
        if AppWindow.Reporting
          LiteApp6.Utility.displayTimeAndFileLocation("AppWindow.Show_AlwaysOnTop_CheckBox: " + AppWindow.Show_AlwaysOnTop_CheckBox)
          LiteApp6.Utility.displayTimeAndFileLocation("AppWindow.HeaderUI.AlwaysOnTop: " + on_or_off)
        end  % if
      end  % if
    end  % function

  end  % methods

end  % classdef
