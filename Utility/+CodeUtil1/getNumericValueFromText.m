function val = getNumericValueFromText(TargetString)
% Get a value from a text representing numeric value

% copyright 2025 The MathWorks, Inc.

arguments (Input)
  TargetString (1,1) string {CodeUtil1.mustBeNumericValueStringOrValidNameOrEmpty} = ""
end  % arguments

arguments (Output)
  val double
end  % arguments

if TargetString == ""
  val = nan;

  return

end  % if

val = double(TargetString);
if isnan(val)
  try
    % Evaluate the target string in the base workspace.
    % The target string was filtered by the mustBeNumericValueStringOrValidNameOrEmpty
    % function argument validation.
    % Things that arrived here for evaluation are text containing a variable or a struct field.
    % For example, "pi", "myvar1", or "myStruct2.myFieldB" are evaluated here.
    % For more details, see the mustBeNumericValueStringOrValidNameOrEmpty implementation.

    val = evalin("base", TargetString);

  catch exception

    rethrow(exception)

  end  % try, catch
end  % if
end  % function
