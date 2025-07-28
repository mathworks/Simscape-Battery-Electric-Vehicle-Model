function Printable = stringifySimscapeValue(SimscapeValueObject)
%% Returns a printable string given a simscape.Value object.
%
%   x = simscape.Value(1, "m")
%   1 (m)
%
%   x = simscape.Value([1, 2], "m")
%   [1,2] (m)
%
%   x = simscape.Value([1; 2], "m")
%   [1;2] (m)
%
%   x = simscape.Value([1, 2, 3; 4, 5, 6], "m")
%   [1,2,3;4,5,6] (m)
%
%   x = simscape.Value(rand(4,3,2), "m")
%   4x3x2 (m)
 
% Copyright 2024-2025 The MathWorks, Inc.

arguments (Input)
  SimscapeValueObject simscape.Value = simscape.Value(0)
end  % arguments

arguments (Output)
  Printable string
end  % arguments
 
val = value(SimscapeValueObject);
value_string = string(val);

if isscalar(val)
  % do nothing
  % This branch is necessary to avoid isvector(val) branch for scalar values.

elseif isvector(val)
  if isrow(val)
    value_string = "[" + join(value_string, ",") + "]";
  else
    value_string = "[" + join(value_string, ";") + "]";
  end  % if

elseif ismatrix(val)
  matsize = numel(size(val));
  if matsize == 2
    value_string = "[" + join(join(value_string, ","), ";") + "]";
  else
    value_string = join(size(val), ",");
  end  % if
end  % if

Printable = value_string + " (" + string(unit(SimscapeValueObject)) + ")";

end  % function
