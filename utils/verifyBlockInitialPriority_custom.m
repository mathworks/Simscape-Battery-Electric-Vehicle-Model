function verifyBlockInitialPriority_custom(testCase, blockPath, paramName, expectedPriority)
%%

% Copyright 2022 The MathWorks, Inc.

arguments
  testCase
  blockPath {mustBeTextScalar}
  paramName {mustBeTextScalar}
  expectedPriority {mustBeMember(expectedPriority, ["High", "Low", "None"])}
end

actual_priority = get_param(blockPath, paramName);
verifyEqual(testCase, actual_priority, expectedPriority)

end  % function
