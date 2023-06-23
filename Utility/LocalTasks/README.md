# Files for local tasks

Some MATLAB commands such as `print` and `edit` are not supported
when MATLAB is launched with `-nodesktop` option.
When running tests in MATLAB with `-nodesktop` option
(for example in continuous integration),
we must avoid calling those commands to avoid test failures.

MATLAB code files in this folder use such commands,
and they should not be used in automated tests
that are run in MATLAB with `-nodesktop` option.

_Copyright 2023 The MathWorks, Inc._
