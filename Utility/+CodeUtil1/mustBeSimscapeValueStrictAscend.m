function mustBeSimscapeValueStrictAscend(simscapeValueVector)
% Check that the values of simscape.Value elements is sorted in strictly ascending order.
% The argument is assumed to be a vector of type simscape.Value.
%
% Use this function as a validation function for function argument validation.
% https://www.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html

% Copyright 2025 The MathWorks, Inc.

% To avoid a confluence of error messages, custom validation functions
% must avoid using function argument validation.

if ~issorted(value(simscapeValueVector), "strictascend")
  id = "mustBeStrictAscend:NotStrictAscend";
  msg = "Vector elements must be strictly ascending.";

  throw(MException(id, msg))

end  % if
end  % function
