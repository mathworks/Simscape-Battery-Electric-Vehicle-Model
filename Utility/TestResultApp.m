function App = TestResultApp(TestResultFileName)
% App to view test result and double-click to open a test file
%
% This app takes a test result XML file which the Build Tool generated.
% This function internally builds a table containing TestClass, TestFunction, and
% TestTimeInSeconds columns using the summarizeTestResult function in the TestUtil
% and shows the table. You can double-click a row in the table to open the test file.
%
% If no test result file is specified, the app opens with empty data, and
% the user has to load a test result file using the "Select file" button.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  TestResultFileName (1,1) string = ""
end  % arguments

arguments (Output)
  App struct
end  % arguments

test_result_app = TestUtil1.TestResultAppMain(TestResultFileName=TestResultFileName);

if nargout > 0
  App = struct;
  App.Window = test_result_app.Window;
end  % if
end  % function
