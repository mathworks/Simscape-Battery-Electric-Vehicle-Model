function SimscapeValue = getSimscapeValueFromBlockPropertyDictionary(PropDict, TargetName)
% This function takes a dictionary as the first argument containing
% Simscape block properties and a string as the second argument representing
% a Simscape block property name in the specified dictionary.
% Then this function returns a simscape.Value object for the specified property.
%
% The dictionary in the first argument must have a "_unit" key for
% the specified block property. For example, if the property name specified in
% the second argument is "mass", there must exist not only the "mass" key but
% also the "mass_unit" key in the dictionary.

% Copyright 2025 The Mathwroks, Inc.

arguments (Input)
  PropDict (1,1) dictionary = configureDictionary("string", "string")
  TargetName (1,1) string {LiteApp6.Utility.mustBeNumericValueStringOrValidNameOrEmpty} = ""
end  % arguments

arguments (Output)
  SimscapeValue (1,1) simscape.Value
end  % arguments

try
  result = LiteApp6.Utility.getNumericValueFromString(PropDict(TargetName));
catch exception

  rethrow(exception)

end  % try, catch

x = result.NumericValue;

u = string(PropDict(TargetName + "_unit"));

try
  SimscapeValue = simscape.Value(x, u);
catch exception

  rethrow(exception)

end  % try, catch

end  % function
