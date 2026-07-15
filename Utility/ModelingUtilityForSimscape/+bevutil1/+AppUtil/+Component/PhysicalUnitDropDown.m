classdef PhysicalUnitDropDown < bevutil1.AppUtil.Component.ComponentBase
  % Drop-down UI component for selecting Simscape physical units.
  %
  % Units are validated as simscape.Unit and must be commensurate.
  % UnitItems can be defined only once; in editable mode, new commensurate units are auto-added.

  % Copyright 2026 The MathWorks, Inc.

  properties (Constant)
    errorID (1,1) string = "PhysicalUnitDropDown:"
  end  % properties
  properties (Dependent)

    % The elements of UnitItems must be commensurate to each other.
    % UnitItems can be defined only once.
    UnitItems (1,:) string

    UnitText (1,1) string

  end  % properties
  properties

    DropDownUI bevutil1.AppUtil.Component.DropDown

    UnitChangedCallback {bevutil1.CodeUtil.mustBeFunctionHandleOrEmpty} = []

    % Do not initialize here because this class is a handle class.
    Editable (1,1) matlab.lang.OnOffSwitchState

    ComponentWidth (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = "1x"
    ComponentHeight (1,:) {bevutil1.CodeUtil.mustBeTextOrPositiveNumber} = bevutil1.AppUtil.Constant.Height{"oneline++"}

  end  % properties
  properties

    UnitSpecified (1,1) logical = false
    CurrentUnitText (1,1) string = ""

    initialized (1,1) logical = false
    main_h_container bevutil1.AppUtil.HorizontalContainer
    main_h_layout matlab.ui.container.GridLayout

  end  % properties
  properties
    % To see outputs from class constructors, you must set Reporting to "on" here.
    % Setting Reporting to "on" in other ways do not enable reporting from constructors.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"
  end  % properties

  events (HasCallbackProperty, NotifyAccess=protected)

    % UnitDropDownChanged event adds UnitDropDownChangedFcn property to this class.
    UnitDropDownChanged

  end  % events

  methods (Access=protected)

    function setup(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if

      setup@bevutil1.AppUtil.Component.ComponentBase(component)

      component.main_h_container = bevutil1.AppUtil.HorizontalContainer(component.main_grid);

      component.main_h_layout = addHorizontalGridLayout(component.main_h_container);

      component.DropDownUI = bevutil1.AppUtil.Component.DropDown(component.main_h_layout);
      component.DropDownUI.ComponentWidth = component.ComponentWidth;
      component.DropDownUI.ValueChangedCallback = @() reactToUnitDropDownChanged(component);

      component.Editable = "on";

      % To avoid triggering callbacks, use the main drop-down's properties.
      component.DropDownUI.MainDropDown.Items = "";
      component.DropDownUI.MainDropDown.Value = "";

    end  % function

    function update(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if
      update@bevutil1.AppUtil.Component.ComponentBase(component)
      if component.initialized
        regular_update(component)

        return

      end  % if
      first_update(component)
      regular_update(component)
      component.initialized = true;
    end  % function

    function regular_update(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("1")
      end  % if

      component.base_grid.ColumnWidth{1} = component.ComponentWidth;
      component.base_grid.RowHeight{1} = component.ComponentHeight;

      component.DropDownUI.ComponentWidth = component.ComponentWidth;
      component.DropDownUI.ComponentHeight = component.ComponentHeight;

      if component.HighlightBackground
        component.DropDownUI.HighlightBackground = "on";
        if component.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("2:ThemeNameForBackGroundHighlight=" + component.ThemeNameForBackGroundHighlight)
        end  % if
        switch component.ThemeNameForBackGroundHighlight
          case "light"
            component.main_h_layout.BackgroundColor = component.LightThemeBackGroundColor;
          case "dark"
            component.main_h_layout.BackgroundColor = component.DarkThemeBackGroundColor;
        end  % switch
      end  % if
    end  % function

    function first_update(component)
      %%
      % This function is called only once after the setup finished and
      % public properties have been updated with the user-specified values.
      % Use this method to freeze property values based on the user-specified ones.
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if

      component.DropDownUI.Editable = component.Editable;

      if not(component.UnitSpecified)
        % The user code of this component did not specify the unit. Fix it with "1".
        if component.Editable
          component.UnitText = "1";
        else
          component.UnitItems = "1";
        end  % if
      end  % if
    end  % function

  end  % methods

  methods

    % --------------------------------------------------------------------------
    % get and set for UnitItems

    function unit_items = get.UnitItems(component)
      %%
      arguments (Output)
        unit_items (1,:) string
      end  % arguments
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if
      unit_items = component.DropDownUI.MainDropDown.Items;
    end  % function

    function set.UnitItems(component, NewUnitItems)
      %%
      arguments (Input)
        component
        NewUnitItems (1,:) string %{ bevutil1.CodeUtil.mustBeAllCommensurateUnit }
      end  % arguments
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("1")
      end  % if

      if component.UnitSpecified
        id = component.errorID + "UnitItemsAlreadyDefined";
        msg = bevutil1.CodeUtil.i18n("UnitItems can be defined only once.");

        throw(MException(id, msg))

      end  % if

      % The new unit items must be valid as simscape.Unit.
      % Accept the new items only if their units are commensurate.
      try
        bevutil1.CodeUtil.mustBePhysicalUnit(NewUnitItems)
        bevutil1.CodeUtil.mustBeAllCommensurateUnit(NewUnitItems)
      catch exception

        msg = exception.message;
        main_figure = ancestor(component, "figure");
        if main_figure.Visible
          % !todo: This branch may be unreachable. Formally verify?
          if component.Reporting
            bevutil1.FileUtil.displayTimeAndFileLocation("2")
          end  % if
          window_title = bevutil1.CodeUtil.i18n("Error");
          uialert(main_figure, msg, window_title)

          return

        else
          if component.Reporting
            bevutil1.FileUtil.displayTimeAndFileLocation("3")
          end  % if
          id = component.errorID + "InvalidUnitItems";

          throw(MException(id, msg))

        end  % if

      end  % try, catch

      component.DropDownUI.MainDropDown.Items = NewUnitItems;
      component.DropDownUI.MainDropDown.Value = NewUnitItems(1);
      component.CurrentUnitText = NewUnitItems(1);
      component.UnitSpecified = true;
      notify(component, "UnitDropDownChanged")
    end  % function

    % --------------------------------------------------------------------------
    % get and set for UnitText

    function unit_text = get.UnitText(component)
      %%
      arguments (Output)
        unit_text (1,1) string
      end  % arguments
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if
      unit_text = component.CurrentUnitText;
    end  % function

    function set.UnitText(component, NewUnitText)
      %%
      arguments (Input)
        component
        NewUnitText (1,1) string
      end  % arguments
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("1")
      end  % if

      current_unit_items = component.UnitItems;

      if component.Editable
        % Editable mode: validate and allow adding new commensurate units.
        try
          bevutil1.CodeUtil.mustBePhysicalUnit(NewUnitText)
        catch exception
          % Remove the new invalid text from the items and the value.
          logical_index = (current_unit_items ~= NewUnitText);
          component.DropDownUI.MainDropDown.Items = current_unit_items(logical_index);
          component.DropDownUI.MainDropDown.Value = component.CurrentUnitText;

          msg = exception.message;
          main_figure = ancestor(component, "figure");
          if main_figure.Visible
            window_title = bevutil1.CodeUtil.i18n("Error");
            uialert(main_figure, msg, window_title)

            return

          else
            id = component.errorID + exception.identifier;

            throw(MException(id, msg))

          end  % if

        end  % try, catch

        if component.UnitSpecified
          if not(simscape.isCommensurateUnit(NewUnitText, current_unit_items{:}))
            logical_index = (current_unit_items ~= NewUnitText);
            component.DropDownUI.MainDropDown.Items = current_unit_items(logical_index);
            component.DropDownUI.MainDropDown.Value = component.CurrentUnitText;

            msg = bevutil1.CodeUtil.i18n("New unit must be commensurate with the defined units.");
            main_figure = ancestor(component, "figure");
            if main_figure.Visible
              window_title = bevutil1.CodeUtil.i18n("Error");
              uialert(main_figure, msg, window_title)

              return

            else
              id = component.errorID + "UnitMustBeCommensurate";

              throw(MException(id, msg))

            end  % if

          end  % if
          if not(ismember(NewUnitText, current_unit_items))
            if component.Reporting
              bevutil1.FileUtil.displayTimeAndFileLocation("2:add:" + NewUnitText)
            end  % if
            component.DropDownUI.MainDropDown.Items{end + 1} = char(NewUnitText);
          end  % if
          component.DropDownUI.MainDropDown.Value = NewUnitText;

        else
          if component.Reporting
            bevutil1.FileUtil.displayTimeAndFileLocation("3:new:" + NewUnitText)
          end  % if
          component.DropDownUI.MainDropDown.Items = NewUnitText;
          component.DropDownUI.MainDropDown.Value = NewUnitText;
        end  % if

      else
        % Non-editable mode: UnitText must be one of existing UnitItems.
        if not(component.UnitSpecified)
          msg = bevutil1.CodeUtil.i18n("UnitItems must be defined before assigning a value to UnitText.");
          main_figure = ancestor(component, "figure");
          if main_figure.Visible
            window_title = bevutil1.CodeUtil.i18n("Error");
            uialert(main_figure, msg, window_title)

            return

          else
            id = component.errorID + "UnitItemsNotDefinedYet";

            throw(MException(id, msg))

          end  % if
        end  % if

        if not(ismember(NewUnitText, current_unit_items))
          % Strict string match failed, but check at the simscape.Unit level.
          new_unit = simscape.Unit(NewUnitText);
          match_found = false;
          for k = 1:numel(current_unit_items)
            if new_unit == simscape.Unit(current_unit_items(k))
              % The new unit text is indeed commensurate with one of the defined units.
              NewUnitText = current_unit_items(k);
              match_found = true;
              break
            end  % if
          end  % for
          if not(match_found)
            msg = bevutil1.CodeUtil.i18n("UnitText must be one of UnitItems: ") + NewUnitText;
            main_figure = ancestor(component, "figure");
            if main_figure.Visible
              window_title = bevutil1.CodeUtil.i18n("Error");
              uialert(main_figure, msg, window_title)

              return

            else
              id = component.errorID + "InvalidUnitText";

              throw(MException(id, msg))

            end  % if
          end  % if
        end  % if
        component.DropDownUI.MainDropDown.Value = NewUnitText;
      end  % if

      component.CurrentUnitText = NewUnitText;
      component.UnitSpecified = true;
      notify(component, "UnitDropDownChanged")
    end  % function

  end  % methods

  methods (Access=private)

    function reactToUnitDropDownChanged(component)
      %%
      if component.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation
      end  % if

      % When this function starts, the items in the drop down already contain the new item.
      new_unit_text = string(component.DropDownUI.MainDropDown.Value);

      % This assignment triggers set.UnitText where all the checks and updates are done.
      component.UnitText = new_unit_text;

      if not(isempty(component.UnitChangedCallback))
        % If not empty, the property validation guarantees that it is a function handle.
        component.UnitChangedCallback()
      end  % if
    end  % function

  end  % methods
end  % classdef
