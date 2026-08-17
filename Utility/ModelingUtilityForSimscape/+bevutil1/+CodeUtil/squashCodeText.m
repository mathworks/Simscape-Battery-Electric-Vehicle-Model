function SquashedText = squashCodeText(OriginalText)
% Convert text like
%   a,b,  c  ,d , ,,   e
% to
%   a,b,c,d,e
%
% This works with a text string representing a scalar, a vector, or a matrix.
% Conversion is purely textual. No lexical analysis is performed.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  OriginalText (1,1) string
end  % arguments

arguments (Output)
  SquashedText (1,1) string
end  % arguments

ospace = optionalPattern(whitespacePattern);

SquashedText = strip(OriginalText);

% Replace two or more consecutive spaces with one space.
SquashedText = replace(SquashedText, asManyOfPattern(whitespacePattern,2), " ");

% Remove spaces before and after a comma.
SquashedText = replace(SquashedText, ospace + "," + ospace, ",");

% Remove space before and after ";".
SquashedText = replace(SquashedText, ospace + ";" + ospace, ";");

% Remove space after "[".
if startsWith(SquashedText, "[")
  SquashedText = replace(SquashedText, "["+ospace, "[");
end  % if

% Remove space before "]".
if endsWith(SquashedText, "]")
  SquashedText = replace(SquashedText, ospace+"]", "]");
end  %if

% Replace a space or a comma with a comma-space sequence.
SquashedText = replace(SquashedText, (" "|","), ", ");

% Replace a semicolon with a semicolon-space sequence.
SquashedText = replace(SquashedText, ";", "; ");

end  % function
