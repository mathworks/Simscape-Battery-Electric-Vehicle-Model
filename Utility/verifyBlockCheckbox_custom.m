function verifyBlockCheckbox_custom(testCase, blockPath, paramName, expectedState)
%%

% Copyright 2022 The MathWorks, Inc.

arguments
  testCase
  blockPath {mustBeTextScalar}
  paramName {mustBeTextScalar}
  expectedState {mustBeMember(expectedState, ["on", "off"])}
end

actual_priority = get_param(blockPath, paramName);
verifyEqual(testCase, actual_priority, expectedState)

end  % function
