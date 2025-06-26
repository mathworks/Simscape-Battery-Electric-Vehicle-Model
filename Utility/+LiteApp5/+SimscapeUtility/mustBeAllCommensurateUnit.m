function mustBeAllCommensurateUnit(units)
% This function takes a simscape.Value object and checks that its value is positive.
%
% You can use this function as a validation function for function argument validation.
% For more information, see the documentation.
% https://www.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html

% Copyright 2024 The MathWorks, Inc.

% The units argument must be of type simscape.Unit.
% To avoid a confluence of error messages, custom validation functions
% must avoid using function argument validation.
if numel(units) > 1
  units_cell = num2cell(units);
  simscape.mustBeCommensurateUnit(units_cell{:});
end  % if

end  % function
