function result = cleanupCodeText(codetext)
% Clean up code text by removing leading spaces, trailing spaces, comment lines, and empty lines.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  codetext (:,1) string = ["first line  ", " ", " third line", " % comment"]
end  % arguments

arguments (Output)
  result (:,1) string
end  % arguments

lines = strip( splitlines(codetext));

% Remove comment lines and empty lines.
logical_index = startsWith(lines, optionalPattern(whitespacePattern)+"%") | (lines == "");
result = lines(not(logical_index));

end  % fucntion
