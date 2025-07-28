function verifyBlockDropdown_custom(testCase, blockPath, paramName, expectedSelection)
%%

% Copyright 2022 The MathWorks, Inc.

arguments
  testCase
  blockPath {mustBeTextScalar}
  paramName {mustBeTextScalar}
  expectedSelection {mustBeTextScalar}
end

actual_priority = get_param(blockPath, paramName);
verifyEqual(testCase, actual_priority, expectedSelection)

end  % function
