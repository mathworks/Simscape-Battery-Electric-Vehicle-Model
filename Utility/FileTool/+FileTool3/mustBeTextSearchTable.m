function mustBeTextSearchTable(x)

% Copyright 2025 The MathWorks, Inc.

if ~FileTool3.isTextSearchTable(x)
  id = "mustBeTextSearchTable:InvalidTable";
  msg = "Table must be text search table.";

  throw(MException(id, msg))

end  % if
end  % function
