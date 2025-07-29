# MATLAB Testing Framework

## Interactive or programmatic testing in MATLAB

This project includes tests which check that
models and scripts run without errors and warnings.
The main product feature used for testing is
[MATLAB Testing Frameworks][url-test].
Specifically, [class-based unit test][url-classbased] is implemented
for each component, BEV system model, and the project.

[url-test]: https://mathworks.com/help/matlab/matlab-unit-test-framework.html
[url-classbased]: https://mathworks.com/help/matlab/class-based-unit-tests.html

You can run tests interactively in MATLAB Editor.
Open [Test Browser][url-testbrowser] to see pass/fail status of the tests
as you run tests.
Test Browser also lets you measure code coverage.

[url-testbrowser]: https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

For MATLAB projects, you can also use
[MATLAB Test Manager][url-testmanager] to run tests and measure code coverage.
(It requires the MATLAB Test license.)
MATLAB Test Manager can find test files in the project
and lets you run them all at once or individually.

[url-testmanager]: https://www.mathworks.com/help/matlab-test/ref/matlabtestmanager-app.html

You can run tests programmatically or interactively.
To run tests programmatically, use the `buildtool` command
provided by the [MATLAB Build Tool][url-buildtool].
To run tests interactively, open the `buildfile.m` file in MATLAB Editor
and use the Run Build button in the Editor toolstrip.
The Project toolstrip also has a Run Build button which is linked to
the `buildfile.m` file in the project root folder.
MATLAB Build Tool supports not only unit test,
but also code coverage measurement,
code issues checking, custom tasks,
building task dependencies, and more.

[url-buildtool]: https://mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html

[Code Analyzer app][url-analyzer] can identify issues in the code files.

[url-analyzer]: https://mathworks.com/help/matlab/ref/codeanalyzer-app.html

For more information about testing,
see the documentation linked below.

- [Testing Framework][url-test]
- [MATLAB Build Tool][url-buildtool]
- [Code Analyzer app][url-analyzer]
- [Class-Based Unit Test][url-classbased]
- [Generate Code Coverage Report in HTML Format][url-covrep]

## Automated testing in continuous integration

Test files introduced above can be used locally in your machine
where you run a test runner script in MATLAB.
If you also have a remote repository server for source control
(such as GitHub or GitLab),
you can use the same test files to automatically test
the project when you push local changes to the remote.

If your repository is a public repository in github.com,
you can use MATLAB and other toolboxes for free
in GitHub Actions Continuous Integration service.
For more information, see the documentation linked below.

- [Continuous Integration (CI)][url-ci]
- [GitHub Actions][url-gh-actions] (github.com)
- [MATLAB Actions][url-ml-actions] (github.com)

<hr>

Go to [README](../README.md) at the project top folder.

_Copyright 2023-2024 The MathWorks, Inc._

[url-covrep]: https://mathworks.com/help/matlab/matlab_prog/generate-code-coverage-report-in-html-format.html
[url-ci]: https://mathworks.com/help/matlab/continuous-integration.html
[url-gh-actions]: https://docs.github.com/en/actions
[url-ml-actions]: https://github.com/matlab-actions/overview
