function TestSummary = summarizeTestResult(TestResultsFile)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  TestResultsFile (1,1) string {mustBeFile}
end  % arguments

arguments (Output)
  TestSummary table
end  % arguments

result = readstruct(TestResultsFile);
result_table = struct2table(result.testsuite);

num_tests = sum(result_table.testsAttribute);

% Table columns
TestClass = strings(num_tests, 1);
TestFunction = strings(num_tests, 1);
TestTimeInSeconds = zeros(num_tests, 1);

test_count = 1;
for ii = 1 : height(result_table)
  if height(result_table) == 1
    subresult_table = struct2table(result_table.testcase);
  else
    subresult_table = struct2table(result_table.testcase{ii});
  end  % if
  num_subresult = result_table.testsAttribute(ii);

  TestClass(test_count : test_count + num_subresult - 1) = result_table.nameAttribute(ii);

  for jj = 1 : num_subresult

    TestFunction(test_count) = subresult_table.nameAttribute(jj);
    TestTimeInSeconds(test_count) = double(subresult_table.timeAttribute(jj));

    test_count = test_count + 1;
  end  % for
end  % for

TestSummary = sortrows(table(TestClass, TestFunction, TestTimeInSeconds), 'TestTimeInSeconds', 'descend');

TestSummary = addprop(TestSummary, ...
  ["NumberOfTests", "TotalTestTimeInSeconds", "MeanTestTimeInSeconds", "MedianTestTimeInSeconds"], ...
  ["table",         "table",                  "table",                 "table"]);

TestSummary.Properties.CustomProperties.NumberOfTests = num_tests;
TestSummary.Properties.CustomProperties.TotalTestTimeInSeconds = sum(TestTimeInSeconds);
TestSummary.Properties.CustomProperties.MeanTestTimeInSeconds = mean(TestTimeInSeconds);
TestSummary.Properties.CustomProperties.MedianTestTimeInSeconds = median(TestTimeInSeconds);

end  % function
