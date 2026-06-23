classdef AppWindow < handle
  % App Window class

  % App icon
  %
  % Vertical container
  % Window header UI
  % App name
  % Hyperlink to the app source file
  % "Always on top" check box

  % Copyright 2023-2026 The MathWorks, Inc.

  properties
    MainFigure matlab.ui.Figure {mustBeScalarOrEmpty}

    MainVerticalContainer AppUtil1.VerticalContainer

    HeaderUI AppUtil1.Component.WindowHeader

    % To see outputs from class constructors, you must set Reporting to "on" here.
    % Setting Reporting to "on" in other ways do not enable reporting from constructors.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"
  end  % properties

  properties (Dependent)
    Name (1,1) string

    Width (1,1) {mustBeInteger, mustBePositive}
    Height (1,1) {mustBeInteger, mustBePositive}

    AlwaysOnTop matlab.lang.OnOffSwitchState

    % PNG file
    Icon (1,1) string
  end  % properties

  properties (Access=private)
    % The default icon file must exist in the "+AppUtil1" namespace folder.
    DefaultIcon (1,1) string = "AppUtil-icon-150x150.png"
  end  % properties

  methods

    function AppWindow = AppWindow(MainFigure, NameValuePair)
      %%
      arguments (Input)
        MainFigure (1,1) matlab.ui.Figure

        % The "Source" hyperlink is created to this string at the top right of the app window.
        % Typically, you want to use mfilename for this argument.
        % If this is empty, the Source hyperlink is not added to the app window.
        NameValuePair.SourceFile (1,1) string = ""

        NameValuePair.Reporting (1,1) matlab.lang.OnOffSwitchState = "off"
      end  % arguments

      arguments (Output)
        AppWindow (1,1)
      end  % arguments

      AppWindow.Reporting = NameValuePair.Reporting;

      if AppWindow.Reporting
        FileUtil1.displayTimeAndFileLocation("Constructor")
      end  % if

      AppWindow.MainFigure = MainFigure;

      AppWindow.MainVerticalContainer = AppUtil1.VerticalContainer(MainFigure);

      AppWindow.Icon = "AppUtil-icon-150x150.png";

      v_gridlayout = addVerticalGridLayout(AppWindow.MainVerticalContainer);
      AppWindow.HeaderUI = AppUtil1.Component.WindowHeader(v_gridlayout);
      AppWindow.HeaderUI.AppSourceName = NameValuePair.SourceFile;
      AppWindow.HeaderUI.Reporting = NameValuePair.Reporting;
    end  % function

    % -------------------------------------------------------------------------
    % Name

    function AppName = get.Name(AppWindow)
      arguments (Output)
        AppName (1,1) string
      end  % arguments
      AppName = AppWindow.MainFigure.Name;
    end  % function

    function set.Name(AppWindow, AppName)
      arguments (Input)
        AppWindow
        AppName (1,1) string
      end  % arguments
      AppWindow.MainFigure.Name = AppName;
      AppWindow.HeaderUI.AppName = AppName;
    end  % function

    % -------------------------------------------------------------------------
    % Always on top

    function on_off = get.AlwaysOnTop(AppWindow)
      arguments (Output)
        on_off (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      on_off = AppWindow.HeaderUI.AlwaysOnTop;
    end  % function

    function set.AlwaysOnTop(AppWindow, on_or_off)
      arguments (Input)
        AppWindow
        on_or_off (1,1) matlab.lang.OnOffSwitchState
      end  % arguments
      AppWindow.HeaderUI.AlwaysOnTop = on_or_off;
    end  % function

    % -------------------------------------------------------------------------
    % Width

    function width_pixel = get.Width(AppWindow)
      width_pixel = AppWindow.MainFigure.Position(3);
    end  % function

    function set.Width(AppWindow, width_pixel)
      arguments (Input)
        AppWindow
        width_pixel (1,1) {mustBeInteger, mustBePositive}
      end  % arguments
      AppWindow.MainFigure.Position(3) = width_pixel;
    end  % function

    % -------------------------------------------------------------------------
    % Height

    function height_pixel = get.Height(AppWindow)
      height_pixel = AppWindow.MainFigure.Position(4);
    end  % function

    function set.Height(AppWindow, height_pixel)
      arguments (Input)
        AppWindow
        height_pixel (1,1) {mustBeInteger, mustBePositive}
      end  % arguments
      AppWindow.MainFigure.Position(4) = height_pixel;
    end  % function

    % -------------------------------------------------------------------------
    % Icon

    function Icon = get.Icon(AppWindow)
      Icon = AppWindow.MainFigure.Icon;
    end  % function

    function set.Icon(AppWindow, PNGFilename)
      arguments (Input)
        AppWindow
        PNGFilename (1,1) string
      end  % arguments

      if PNGFilename == AppWindow.DefaultIcon
        try
          AppUtil_folder_fullpath = FileUtil1.getFolderFullPath("+AppUtil1");
        catch exception
          if AppWindow.MainFigure.Visible
            title_word = CodeUtil1.i18n("Error");

            uialert(AppWindow.MainFigure, exception.message, title_word)

          else

            rethrow(exception)

          end  % if
        end  % try, catch
        % The default icon file must exist in the "+AppUtil1" namespace folder.
        icon_fullpath = fullfile(AppUtil_folder_fullpath, PNGFilename);

      else
        % Custom icon
        try
          icon_fullpath = FileUtil1.getFileFullPath(PNGFilename);
        catch exception
          if AppWindow.MainFigure.Visible
            title_word = CodeUtil1.i18n("Error");

            uialert(AppWindow.MainFigure, exception.message, title_word)

          else

            rethrow(exception)

          end  % if
        end  % try, catch
      end  % if

      AppWindow.MainFigure.Icon = icon_fullpath;

    end  % function

  end  % methods
end  % classdef
