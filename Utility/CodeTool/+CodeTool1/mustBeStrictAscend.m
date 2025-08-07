function mustBeStrictAscend(a)

% Copyright 2025 The MathWorks, Inc.

if ~issorted(a, "strictascend")
  id = "mustBeStrictAscend:InvalidVector";
  msg = "Vector elements must be strictly ascending.";

  throw(MException(id, msg))

end  % if
end  % function
