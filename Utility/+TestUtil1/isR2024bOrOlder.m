function TrueOrFalse = isR2024bOrOlder
% Check if MATLAB Release is R2024b or older.

% Copyright 2026 The MathWorks, Inc.

arguments (Output)
  TrueOrFalse (1,1) logical
end  % arguments

if not(isMATLABReleaseOlderThan("R2025a"))
  % R2025a or newer
  TrueOrFalse = false;

  return

end  % if

% R2024b or older
TrueOrFalse = true;

end  % function
