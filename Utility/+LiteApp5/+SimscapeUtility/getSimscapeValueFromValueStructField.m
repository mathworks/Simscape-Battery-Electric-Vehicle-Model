function Result = getSimscapeValueFromValueStructField(TargetData, MainMemberName)
%%
% This function creates a simscape.Value object from arguments by assuming
% that the first argument is a struct or a class which has a field name
% or a property name built from the second argument followed by "_Value":
%
%   TargetData.(MainMemberName + "_Value")
%
% For example, if TargetData is myApp and MainMemberName is "Parameter1",
% the following field or property must exist:
%
%   myApp.Parameter1_Value
%
% This function tries to avoid evalin, but if it decides that evalin is necessary
% for the TargetData.(MainMemberName + "_Value"),
% the function assumes that the following struct field or a class property also exists:
%
%   TargetData.(MainMemberName + "_Unit")
%
% For example, for the previous example for Value, the following field
% or a property must exist:
%
%   myApp.Parameter1_Unit

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  TargetData (1,1)  % struct or class
  MainMemberName (1,1) string = ""
end  % arguments

arguments (Output)

  % The field names of Result struct are tested in the unit test.
  % Modifying the field names result in test failure.
  % See the test method.
  Result (1,1) struct

end  % arguments

errorID = "getSimscapeValueFromValueStructField:";

% Do not modify this struct definition unless you modify the corresponding unit test.
Result = struct;
Result.Evaluated = false;
Result.SimscapeValue = simscape.Value;

if MainMemberName == ""
  msg = LiteApp5.Utility.i18n("MainMemberName must be non-empty.");

  throw(MException(errorID + "InvalidArgument", msg))

end  % if

target_member_name = MainMemberName + "_Value";


if string(class(TargetData)) == "struct"
  % struct
  field_or_property = "Struct field ";
  test_membership = @isfield;
  get_member_names = @fieldnames;
else
  % class
  field_or_property = "Class property ";
  test_membership = @isprop;
  get_member_names = @properties;
end

% !todo: Make this function standalone.
function msg = errmsg(name)
  % !todo: Add the "{1}" placeholder support in LiteApp5.Utility.i18n and use it.
  msg = field_or_property + name + " must exist but was not found.";
end  % nested function

if not(test_membership(TargetData, target_member_name))

  throw(MException(errorID + "", errmsg(target_member_name)))

end  % if

target_string = TargetData.(MainMemberName + "_Value");

if class(target_string) == "string" && startsWith(target_string, "simscape.Value")

  value_string = extractBetween(target_string, regexpPattern("^simscape.Value\("), regexpPattern("\)$"));

  if contains(value_string, ",")
    words = split(value_string, "," + optionalPattern(whitespacePattern));
    value_string = words(1);
    physical_unit_string = extractBetween(words(2), """", """");
  else    
    physical_unit_string = "1";
  end  % if

  try
    value_result = LiteApp5.Utility.getNumericValueFromString(value_string);
  catch exception

    rethrow(exception)

  end  % try, catch
  Result.Evaluated = value_result.Evaluated;

  try
    Result.SimscapeValue = simscape.Value(value_result.NumericValue, physical_unit_string);
  catch exception

    rethrow(exception)

  end  % try, catch

else

  value_numeric = double(target_string);

  if isnan(value_numeric)
    % value_numeric is not a valid number. target_string needs evaluation.
    % target_string may contain a simscape.Value object, or
    % a call to the value method of simscape.Value like this: value(myVar1, "m"), or
    % anything else.

    Result.Evaluated = true;
    try
      eval_result = evalin("base", target_string);
    catch exception

      rethrow(exception)

    end  % try, catch

    if string(class(eval_result)) == "simscape.Value"
      Result.SimscapeValue = eval_result;

    else
      target_member_name = MainMemberName + "_Unit";
      if not(any(target_member_name == get_member_names(TargetData)))

        throw(MException(errorID + "InvalidUnit", errmsg(target_member_name)))

      end  % if

      unit_string = TargetData.(target_member_name);

      if unit_string == ""
        % The evaluation result was of type double (not a simscape.Value), and the physical unit was "".
        % This is an error case because there is no way of knowing the physical unit.
        id = errorID + "InvalidPhysicalUnit";
        msg = LiteApp5.Utility.i18n("Physical unit is required to create a simscape.Value object for a number: ") + eval_result;

        throw(MException(id, msg))

      end  % if

      try
        Result.SimscapeValue = simscape.Value(eval_result, unit_string);
      catch exception

        rethrow(exception)

      end  % try, catch
    end  % if

  else
    target_member_name = MainMemberName + "_Unit";
    if not(any(target_member_name == fieldnames(TargetData)))

      throw(MException(errorID + "InvalidUnit", errmsg(target_member_name)))

    end  % if
    unit_string = TargetData.(target_member_name);
    try
      Result.SimscapeValue = simscape.Value(value_numeric, unit_string);
    catch exception

      rethrow(exception)

    end  % try, catch
  end  % if
end  % if

end  % function
