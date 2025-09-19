function mustBeAllCommensurateUnit(units)
% Check that specified physical units are all commensurate to each other.
%
% The units argument must be of type simscape.Unit.
%
% Use this function as a validation function for function argument validation.
% https://www.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html

% Copyright 2024-2025 The MathWorks, Inc.

% To avoid a confluence of error messages, custom validation functions
% must avoid using function argument validation.

if numel(units) > 1
  units_cell = num2cell(units);
  simscape.mustBeCommensurateUnit(units_cell{:});
end  % if
end  % function
