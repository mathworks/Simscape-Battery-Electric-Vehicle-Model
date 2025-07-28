function Result = getNumericValueFromString(TargetString)
%%

% copyright 2025 The MathWorks, Inc.

arguments (Input)

  TargetString (1,1) string {LiteApp6.Utility.mustBeNumericValueStringOrValidNameOrEmpty} = ""

end  % arguments

arguments (Output)

  % The field names of Result struct are tested in the unit test.
  % Modifying the field names result in test failure.
  % See the test method.
  Result (1,1) struct

end  % arguments

Result = struct;
Result.Evaluated = false;
Result.NumericValue = double.empty;  % https://www.mathworks.com/help/matlab/ref/empty.html

if TargetString == ""

  return

end  % if

x = double(TargetString);

if isnan(x)
  Result.Evaluated = true;
  try
    % Evaluate the target string in base workspace.
    % The target string was filtered by the mustBeNumericValueStringOrValidNameOrEmpty
    % function argument validation.
    % Things that arrived here for evaluation are text containing a variable or a struct field.
    % For example, "pi", "myvar1", or "myStruct2.myFieldB" are evaluated here.
    % For more details, see the mustBeNumericValueStringOrValidNameOrEmpty implementation.

    Result.NumericValue = evalin("base", TargetString);

  catch exception

    rethrow(exception)

  end  % try, catch
else
  Result.NumericValue = x;
end  % if

end  % function
