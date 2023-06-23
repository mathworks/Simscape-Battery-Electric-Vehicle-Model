function verifyBlockParameter_custom(testCase, blockPath, paramName, expectedVar, expectedUnit)
%%

% Copyright 2022 The MathWorks, Inc.

actual_entry = get_param(blockPath, paramName);
verifyEqual(testCase, actual_entry, expectedVar)

actual_unit = get_param(blockPath, paramName+"_unit");
One_in_actual_unit = simscape.Value(1, actual_unit);
value_in_expected_unit = value(One_in_actual_unit, expectedUnit);
verifyEqual(testCase, value_in_expected_unit, 1)

end  % function
