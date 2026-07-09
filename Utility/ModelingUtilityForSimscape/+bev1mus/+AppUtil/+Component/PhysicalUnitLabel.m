classdef PhysicalUnitLabel < bev1mus.AppUtil.Component.ComponentBase
  % Label UI component for displaying a physical unit.
  %
  % The text must be valid as Simscape's physical unit or a custom alias when unit is "1".

  % Copyright 2026 The MathWorks, Inc.

  properties (Constant)
    errorID (1,1) string = "PhysicalUnitLabel:"
  end  % properties
  properties (Dependent)

    % UnitText corresponds to simscape.Unit's unit text.
    % When this is "1", a custom alias can be defined (but optional).
    UnitText (1,1) string

    % UnitAlias is an alternative text for the unit "1".
    % Units that are not "1" do not support alias.
    UnitAlias (1,1) string

  end  % properties
  properties

    LabelUI bev1mus.AppUtil.Component.Label

    UnitChangedCallback {bev1mus.CodeUtil.mustBeFunctionHandleOrEmpty} = []

    ComponentWidth (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = "1x"
    ComponentHeight (1,:) {bev1mus.CodeUtil.mustBeTextOrPositiveNumber} = bev1mus.AppUtil.Constant.Height{"oneline++"}

  end  % properties
  properties

    UnitSpecified (1,1) logical = false
    AliasSpecified (1,1) logical = false

    % If unit alias is specified, this is "1".
    CurrentUnitText (1,1) string = ""

  end  % properties
  properties
    % The Reporting property is for testing purpose only.
    %
    % To use the reporting within the class constructor, set Reporting to "on" here.
    % Setting Reporting to "on" in other ways does not enable reporting from the constructor.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"
  end  % properties

  events (HasCallbackProperty, NotifyAccess=protected)

    % UnitLabelChanged event adds UnitLabelChangedFcn property to this class.
    UnitLabelChanged

  end  % events

  methods (Access=protected)

    function setup(component)
      %%
      setup@bev1mus.AppUtil.Component.ComponentBase(component)

      component.LabelUI = bev1mus.AppUtil.Component.Label(component.main_grid);

      % Use semicolon to ignore and suppress the return value.
      addlistener(component, "UnitLabelChanged", ...
        @(sourceObject, eventData) reactToUnitLabelChanged(component));

      % Default settings.
      component.ComponentWidth = "1x";
      component.ComponentHeight = bev1mus.AppUtil.Constant.Height{"oneline++"};

      component.LabelUI.Text = "1";
      component.CurrentUnitText = "1";

    end  % function

    function update(component)
      %%
      update@bev1mus.AppUtil.Component.ComponentBase(component)

      component.base_grid.ColumnWidth{1} = component.ComponentWidth;
      component.base_grid.RowHeight{1} = component.ComponentHeight;

      component.LabelUI.ComponentWidth = component.ComponentWidth;
      component.LabelUI.ComponentHeight = component.ComponentHeight;
    end  % function

  end  % methods

  methods

    % --------------------------------------------------------------------------
    % get or set UnitText

    function unit_text = get.UnitText(component)
      %%
      arguments (Output)
        unit_text (1,1) string
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
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
        bev1mus.FileUtil.displayTimeAndFileLocation("1")
      end  % if
      % This method must continue to work after the first_update so that
      % the UniText can be modified with a commensurate unit.
      if component.UnitSpecified
        if component.AliasSpecified
          % Case 1: Unit alias is defined, which implies the unit must be "1".
          if component.Reporting
            bev1mus.FileUtil.displayTimeAndFileLocation("2:alias")
          end  % if
          if NewUnitText ~= "1"
            id = component.errorID + "InvalidUnitForAlias";
            msg = bev1mus.CodeUtil.i18n("Unit alias is defined. ""1"" is the only allowed unit: " + NewUnitText);

            throw(MException(id, msg))

          end  % if
          % At this point, NewUnitText is "1".
          % Do not modify the unit text (component.LabelUI.Text) if alias is set.
          % Practically, this branch does nothing.
          component.CurrentUnitText = "1";
          notify(component, "UnitLabelChanged")

          return

        else
          % Case 2: Unit is defined. Alias is not defined.
          % Allow changing the unit if it is commensurate.
          % Do not allow specifying alias.
          if component.Reporting
            bev1mus.FileUtil.displayTimeAndFileLocation("3:modify:" + NewUnitText)
          end  % if
          if not(simscape.isCommensurateUnit(NewUnitText, component.CurrentUnitText))
            id = component.errorID + "UnitMustBeCommensurate";
            msg = bev1mus.CodeUtil.i18n("New unit must be commensurate with the current unit.");

            throw(MException(id, msg))

          end  % if
          component.CurrentUnitText = NewUnitText;
          component.LabelUI.Text = NewUnitText;
          notify(component, "UnitLabelChanged")

        end  % if alias is specified or not

      else
        % Case 3: Unit is not specified yet.
        if component.Reporting
          bev1mus.FileUtil.displayTimeAndFileLocation("4:new:" + NewUnitText)
        end  % if
        try
          % Validate the provided string.
          simscape.Unit(NewUnitText);
        catch exception
          id = component.errorID + "UnitMustBeCommensurate";
          msg = exception.message;

          throw(MException(id, msg))

        end  % try, catch
        component.CurrentUnitText = NewUnitText;
        component.LabelUI.Text = NewUnitText;
        notify(component, "UnitLabelChanged")

        component.UnitSpecified = true;

        return

      end  % if unit is specified or not
    end  % function

    % --------------------------------------------------------------------------
    % get or set UnitAlias

    function AliasText = get.UnitAlias(component)
      %%
      arguments (Output)
        AliasText (1,1) string
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation
      end  % if
      if component.AliasSpecified
        AliasText = component.LabelUI.Text;
      else
        AliasText = "";        
      end  % if
    end  % function

    function set.UnitAlias(component, NewAliasString)
      %%
      arguments (Input)
        component
        NewAliasString (1,1) string
      end  % arguments
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("1")
      end  % if

      if not(component.UnitSpecified)
        if component.Reporting
          bev1mus.FileUtil.displayTimeAndFileLocation("2:specify:" + NewAliasString)
        end  % if
        % Unit is not specified yet.
        % Specifying alias implies that the unit is "1".
        component.CurrentUnitText = "1";
        component.LabelUI.Text = NewAliasString;
        component.UnitSpecified = true;
        component.AliasSpecified = true;
        notify(component, "UnitLabelChanged")

        return

      end  % if

      % Unit is already specified.
      % Allow modifying alias only if the unit is "1".
      if component.CurrentUnitText ~= "1"
        if component.Reporting
          bev1mus.FileUtil.displayTimeAndFileLocation("3:error")
        end  % if
        id = component.errorID + "CannotSpecifyAlias";
        msg = bev1mus.CodeUtil.i18n("Specifying alias is supported only if unit is ""1"".");

        throw(MException(id, msg))

      end  % if
      if component.Reporting
        bev1mus.FileUtil.displayTimeAndFileLocation("4:modify:" + NewAliasString)
      end  % if
      component.LabelUI.Text = NewAliasString;
      component.AliasSpecified = true;
      notify(component, "UnitLabelChanged")
    end  % function

  end  % methods

  methods (Access=private)

    function reactToUnitLabelChanged(component)
      if not(isempty(component.UnitChangedCallback))
        % If not empty, the property validation guarantees it is a function handle.
        component.UnitChangedCallback()
      end  % if
    end  % function

  end  % methods
end  % classdef
