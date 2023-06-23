# MATLAB Testing Framework and Beyond

This project includes tests which check that
models and scripts run without errors and warnings.
The main product feature used for testing is
MATLAB Testing Framework.

Specifically, class-based unit test is implemented
for each component, BEV system model, and project.
Each unit test comes with a test runner script (`*_runtests.m`).
These test files are stored in the `Test` folders.

Test runner runs tests and reports pass/fail summary.
It also measures MATLAB Code coverage for files listed in
the test runner script and generates a coverage report.

For more information about testing,
see the documentation linked below.

- [Testing Framework][url-test]
- [Class-Based Unit Test][url-classbased]
- [Generate Code Coverage Report in HTML Format][url-covrep]

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

_Copyright 2023 The MathWorks, Inc._

[url-test]: https://www.mathworks.com/help/matlab/matlab-unit-test-framework.html
[url-classbased]: https://www.mathworks.com/help/matlab/class-based-unit-tests.html
[url-covrep]: https://www.mathworks.com/help/matlab/matlab_prog/generate-code-coverage-report-in-html-format.html
[url-ci]: https://www.mathworks.com/help/matlab/continuous-integration.html
[url-gh-actions]: https://docs.github.com/en/actions
[url-ml-actions]: https://github.com/matlab-actions/overview
