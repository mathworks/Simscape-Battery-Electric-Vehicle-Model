function mustBeNumericValueStringOrValidNameOrEmpty(x)

% x must be of type string.
% Do not accept a struct with field depth greater than 1.

% Copyright 2025 The MathWorks, Inc.

if isstring(x) && x == ""

  return

end  % if

not_numeric = isstring(x) && isnan(double(x));

variable_name_pattern = lettersPattern + optionalPattern(asManyOfPattern(lettersPattern | digitsPattern | "_"));
not_var = isstring(x) && not(matches(x, variable_name_pattern));

% Accept single-depth struct only. For example, myStruct1.myFieldA is accepted, but
% myStruct1.myFieldB.anotherFieldC is not.
struct_field_pattern = variable_name_pattern + "." + variable_name_pattern;

not_struct_field = isstring(x) && not(matches(x, struct_field_pattern));

% Accept "value(<struct1>.<field1>, ""<unit_string>"")" as a valid string.
% Simscape unit string pattern below is to refuse bad strings as simscape.Unit, rather than to check the validity as simscape.Unit.
simscape_unit_string_pattern = lettersPattern + optionalPattern(asManyOfPattern(lettersPattern|digitsPattern|"/"|"*"|"^"|"("|")"));

value_function_pattern = "value(" + (variable_name_pattern|struct_field_pattern) + "," + whitespacePattern +  """" + simscape_unit_string_pattern + """)";

not_value_function_pattern = isstring(x) && not(matches(x, value_function_pattern));

if not_numeric && not_var && not_struct_field && not_value_function_pattern
  errorID = "mustBeNumericValueStringOrValidName:validationFailed";
  error_text = CodeTool1.i18n("Data string must be convertible to either a numeric value, a variable, or a struct field.");

  throw(MException(errorID, error_text))

end  % if
end  % function
