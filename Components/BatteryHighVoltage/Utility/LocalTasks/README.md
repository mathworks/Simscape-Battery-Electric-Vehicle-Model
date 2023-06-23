# Files for local tasks

Many of the tests in this project are executed during
continuous integration
where MATLAB is launched with `-nodesktop` option,
but some of MATLAB commands such as `print` and `edit` are not supported
(i.e., MATLAB erros out)
when MATLAB is launched with that option.

MATLAB code files in this folder use such commands.
Use these code files in your machine
where MATLAB is launched without `-nodesktop` option.

_Copyright 2023 The MathWorks, Inc._
