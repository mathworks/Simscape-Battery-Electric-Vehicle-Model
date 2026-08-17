classdef PhysicalValue < handle
  % A class for handling numeric values with physical units, expressions, and the base workspace.
  %
  % Use texts to represent a numeric value with physical unit, which corresponds to a simscape.Value object.
  % For example,
  %{
        physval = bevutil1.CodeUtil.PhysicalValue;
        physval.UnitText = "kg";
        physval.ValueText = "[2, 4, 6] + 10"  % Specify value after unit.
  %}
  % The ValueText can contain a MATLAB expression which must evaluate to either
  % a numeric value (as in the above example,) or a simscape.Value (as follows.)
  %{
        physval = bevutil1.CodeUtil.PhysicalValue;
        physval.ValueText = "simscape.Value([3 4; 5 6], ""N*m"")"
  %}
  % Once the unit is determined, subsequent changes in ValueText or UnitText must satisfy
  % the simscape.Unit's unit consistency.
  %
  % The ValueText can access variables in the base workspace.
  % For example, the following code works.
  % (To see it working, select the code and evaluate.)
  %{
        params = struct;
        params.motor.MaxTorque = simscape.Value(150, "N*m");
        physval = bevutil1.CodeUtil.PhysicalValue;
        physval.ValueText = "params.motor.MaxTorque"
  %}

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Constant, Access=private)
    classID (1,1) string = "PhysicalValue:"
  end  % properties

  % Make properties "set"-observable with event listeners.
  % See the documentation for the details.
  % Set Property Attributes to Enable Property Events
  % https://www.mathworks.com/help/matlab/matlab_oop/listening-for-changes-to-property-values.html#brkimdj-1

  properties (Dependent, SetObservable)

    % A textual representation of the unit of the data.
    % The unit must conform to the simscape.Unit.
    UnitText (1,1) string

  end  % properties

  properties (Dependent)

    % An alternative textual representation of the unit of the data.
    % This works only if the unit is "1".
    UnitAlias (1,1) string

  end  % properties

  properties (Dependent, SetObservable)

    % A textual representation of numeric data such as a scalar, a vector, a matrix,
    % or any MATLAB expression. The data type must be either double or simscape.Value.
    % If the data type is simscape.Value, the unit must be commensurate with the current unit.
    ValueText (1,1) string

  end  % properties

  % Make properties "get"-observable with event listeners.
  properties (Dependent, GetObservable)

    SimscapeValue simscape.Value

  end  % properties

  properties

    % The type of ValueText is either double or simscape.Value.
    % ValueTextIsSimscapeValue is false if ValueText is of type double.
    ValueTextIsSimscapeValue (1,1) logical

    current_unit_text (1,1) string = "1"
    current_unit_alias (1,1) string = ""

    % Value can be a scalar, a vector, or a matrix.
    current_value_text string = ""
    current_simscape_value simscape.Value = simscape.Value(nan, "1")

    % If initialized is true, unit and alias are determined and not allowed to change.
    initialized (1,1) logical = false

  end

  properties
    % The Reporting property is for testing purpose only.
    %
    % To see outputs from class constructors, set Reporting to "on" here.
    % Setting Reporting to "on" in other ways does not enable reporting from the constructor.
    Reporting (1,1) matlab.lang.OnOffSwitchState = "off"
  end  % properties

  methods

    function physval = PhysicalValue(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.UnitText (1,1) string = ""
        NameValuePair.UnitAlias (1,1) string = ""
        NameValuePair.ValueText (1,1) string = ""
      end  % arguments

      functionID = "PhysicalValue:";

      if (NameValuePair.UnitText == "") && (NameValuePair.UnitAlias == "") && (NameValuePair.ValueText == "")
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("1:ok")
        end  % if
        return

      elseif (NameValuePair.UnitText ~= "") && (NameValuePair.UnitAlias ~= "")
        % Specify alias first. Then check that unit is "1". Then specify value text.
        physval.UnitAlias = NameValuePair.UnitAlias;
        if NameValuePair.UnitText ~= "1"
          if physval.Reporting
            bevutil1.FileUtil.displayTimeAndFileLocation("2.1:error")
          end  % if
          id = physval.classID + functionID + "InvalidUnitTextForUnitAlias";
          msg = bevutil1.CodeUtil.i18n("UnitText must be ""1"" when UnitAlias is specified.");

          throw(MException(id, msg))

        end  % if
        if NameValuePair.ValueText == ""
          if physval.Reporting
            bevutil1.FileUtil.displayTimeAndFileLocation("2.2:ok")
          end  % if
          return

        else
          % NameValuePair.ValueText ~= ""
          try
            physval.ValueText = NameValuePair.ValueText;
          catch exception
            if physval.Reporting
              bevutil1.FileUtil.displayTimeAndFileLocation("2.3:error")
            end  % if

            rethrow(exception)

          end  % try, catch
          if physval.Reporting
            bevutil1.FileUtil.displayTimeAndFileLocation("2.4:ok")
          end  % if
        end  % if
        return

      elseif (NameValuePair.UnitText ~= "") && (NameValuePair.UnitAlias == "") && (NameValuePair.ValueText == "")
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("3:ok")
        end  % if
        physval.UnitText = NameValuePair.UnitText;
        return

      elseif (NameValuePair.UnitText == "") && (NameValuePair.UnitAlias ~= "") && (NameValuePair.ValueText == "")
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("4:ok")
        end  % if
        physval.UnitAlias = NameValuePair.UnitAlias;
        return

      elseif (NameValuePair.UnitText == "") && (NameValuePair.UnitAlias == "") && (NameValuePair.ValueText ~= "")
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("5:ok")
        end  % if
        physval.ValueText = NameValuePair.ValueText;
        return

      elseif (NameValuePair.UnitText ~= "") && (NameValuePair.UnitAlias == "") && (NameValuePair.ValueText ~= "")
        physval.UnitText = NameValuePair.UnitText;
        try
          physval.ValueText = NameValuePair.ValueText;
        catch exception
          if physval.Reporting
            bevutil1.FileUtil.displayTimeAndFileLocation("6.1:error")
          end  % if

          rethrow(exception)

        end  % try, catch
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("6.2:ok")
        end  % if
        return

      elseif (NameValuePair.UnitText == "") && (NameValuePair.UnitAlias ~= "") && (NameValuePair.ValueText ~= "")
        physval.UnitAlias = NameValuePair.UnitAlias;
        try
          physval.ValueText = NameValuePair.ValueText;
        catch exception
          if physval.Reporting
            bevutil1.FileUtil.displayTimeAndFileLocation("7.1:error")
          end  % if

          rethrow(exception)

        end  % try, catch
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("7.2:ok")
        end  % if
        return

      end  % if
    end  % function

    function processValueText(physval, value_text)
      %%
      % This is used in the following locations:
      %   set.ValueText
      %   get.UnitText
      %   get.SimscapeValue

      if physval.Reporting
        bevutil1.FileUtil.displayTimeAndFileLocation("1")
      end  % if

      functionID = physval.classID + "processValueText:";

      if physval.initialized && isscalar(value_text) && (value_text == "")
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("2:nan:" + physval.current_unit_text)
        end  % if
        % Reset the simscape.Value object with nan as its value.
        physval.ValueTextIsSimscapeValue = false;
        physval.current_simscape_value = simscape.Value(nan, physval.current_unit_text);

        return

      end  % if

      x = double(value_text);

      if not(isnan(x))
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("3:numeric:" + physval.current_unit_text)
        end  % if
        % Value text was properly converted to a numeric value.
        physval.ValueTextIsSimscapeValue = false;
        physval.current_simscape_value = simscape.Value(x, physval.current_unit_text);

        return

      end  % if

      % Value text is not a numeric value.
      try
        % getDoubleOrSimscapeValueFromText returns either a double or a simscape.Value.
        % Other types are not returned.
        result = bevutil1.CodeUtil.getDoubleOrSimscapeValueFromText(value_text);
      catch exception
        id = functionID + "InvalidValueText";
        msg = bevutil1.CodeUtil.i18n("Invalid ValueText. ") + exception.message;

        throw(MException(id, msg))

      end  % try, catch
      if isa(result, "double")
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("4:numeric:" + physval.current_unit_text)
        end  % if
        physval.ValueTextIsSimscapeValue = false;
        % Do not modify physval.current_unit_text.
        physval.current_simscape_value = simscape.Value(result, physval.current_unit_text);
      else
        % The result is a simscape.Value object.
        physval.ValueTextIsSimscapeValue = true;
        new_unit = unit(result);
        if physval.Reporting
          bevutil1.FileUtil.displayTimeAndFileLocation("5:simscape.Value:" + new_unit)
        end  % if
        if physval.initialized && not(simscape.isCommensurateUnit(new_unit, physval.current_unit_text))
          id = functionID + "UnitIsNotCommensurate";
          msg = bevutil1.CodeUtil.i18n("Unit must be commensurate with the currently defined unit.");

          throw(MException(id, msg))

        end  % if
        physval.current_unit_text = new_unit;
        physval.current_simscape_value = result;
      end  % if
    end  % function

    function x = get.ValueText(physval)
      %%
      arguments (Output)
        x (1,1) string
      end  % arguments
      x = physval.current_value_text;
    end  % function

    function set.ValueText(physval, value_text)
      %%
      arguments (Input)
        physval
        value_text (1,1) string
      end  % arguments
      if not(physval.initialized)
        physval.current_unit_text = "1";
        physval.current_unit_alias = "";
      end  % if
      processValueText(physval, value_text)
      physval.current_value_text = value_text;
      physval.initialized = true;
    end  % function

    function x = get.UnitText(physval)
      %%
      arguments (Output)
        x (1,1) string
      end  % arguments
      processValueText(physval, physval.current_value_text)
      x = physval.current_unit_text;
    end  % function

    function set.UnitText(physval, NewUnitText)
      %%
      arguments (Input)
        physval
        NewUnitText (1,1) string
      end  % arguments
      functionID = physval.classID + "set_UnitText:";
      try
        % Check that the new unit text is valid as simscape.Unit.
        simscape.Unit(NewUnitText);
      catch exception
        id = functionID + "InvalidUnit";
        msg = bevutil1.CodeUtil.i18n("Invalid unit: ") + exception.message;

        throw(MException(id, msg))

      end  % try, catch
      if physval.initialized && not(simscape.isCommensurateUnit(NewUnitText, physval.current_unit_text))
        id = functionID + "UnitIsNotCommensurate";
        msg = bevutil1.CodeUtil.i18n("New unit must be commensurate with the currently defined unit.");

        throw(MException(id, msg))

      end  % if
      physval.current_unit_text = NewUnitText;
      if physval.current_unit_text ~= "1"
        physval.current_unit_alias = "";
      end  % if
      if physval.initialized
        physval.current_simscape_value = convert(physval.current_simscape_value, NewUnitText);
      else
        physval.current_simscape_value = simscape.Value(nan, NewUnitText);
      end  % if
      physval.initialized = true;
    end  % function

    function x = get.UnitAlias(physval)
      %%
      arguments (Output)
        x (1,1) string
      end  % arguments
      x = physval.current_unit_alias;
    end  % function

    function set.UnitAlias(physval, NewUnitAlias)
      %%
      arguments (Input)
        physval
        NewUnitAlias (1,1) string
      end  % arguments

      functionID = physval.classID + "set_UnitAlias:";

      if physval.initialized && (physval.current_unit_text ~= "1")
        id = functionID + "UnitAliasIsNotAllowed";
        msg = bevutil1.CodeUtil.i18n("Unit alias is allowed only if UnitText is ""1"".");

        throw(MException(id, msg))

      end  % if

      physval.current_unit_alias = NewUnitAlias;
      physval.UnitText = "1";

    end  % function

    function x = get.SimscapeValue(physval)
      %%
      arguments (Output)
        x simscape.Value
      end  % arguments
      if not(physval.initialized)
        x = simscape.Value(nan);

        return

      end  % if
      processValueText(physval, physval.current_value_text)
      x = physval.current_simscape_value;
    end  % function

    function set.SimscapeValue(physval, x)
      %%
      arguments (Input)
        physval
        x simscape.Value
      end  % arguments

      functionID = physval.classID + "set_SimscapeValue:";

      if not(physval.initialized)
        physval.current_unit_text = string(unit(x));
        physval.current_unit_alias = "";
        physval.current_value_text = value(x);
        physval.current_simscape_value = x;
        physval.initialized = true;

        return

      end  % if

      new_unit_text = unit(x);

      % If unit alias is already defined, the new unit must be "1".
      if physval.current_unit_alias ~= "" && new_unit_text ~= "1"
        id = functionID + "UnitIsNotCompatibleWithAlias";
        msg = bevutil1.CodeUtil.i18n("The unit must be ""1"" because unit alias is defined.");

        throw(MException(id, msg))

      end  % if

      % Unit must be commensurate.
      if not(simscape.isCommensurateUnit(new_unit_text, physval.current_unit_text))
        id = functionID + "UnitIsNotCommensurate";
        msg = bevutil1.CodeUtil.i18n("The unit of the specified SimscapeValue is not commensurate with the current unit.");

        throw(MException(id, msg))

      end  % if

      % At this point, unit is commensurate. Alias is not defined.
      physval.current_unit_text = new_unit_text;
      physval.current_value_text = value(x);
      physval.current_simscape_value = x;
      physval.initialized = true;

    end  % function

  end  % methods
end  % classdef
