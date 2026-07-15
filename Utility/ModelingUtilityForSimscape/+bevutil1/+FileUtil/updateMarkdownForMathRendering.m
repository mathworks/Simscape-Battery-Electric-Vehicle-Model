function NumLines = updateMarkdownForMathRendering(FileName)

% The function reads all lines, identifies those ending with "$$ " (trailing space after $$),
% strips that final space, writes the file back, and returns how many lines were fixed.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  FileName (1,1) string {mustBeFile}
end

arguments (Output)
  NumLines (1,1) {mustBeInteger, mustBeNonnegative}
end

lines = readlines(FileName);
mask = endsWith(lines, "$$ ");
lines(mask) = replaceBetween(lines(mask), strlength(lines(mask)), strlength(lines(mask)), "");
NumLines = nnz(mask);

if NumLines > 0
  writelines(lines, FileName);
end  % if

end  % function
