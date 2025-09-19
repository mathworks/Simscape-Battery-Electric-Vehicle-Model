function TrueOrFalse = isTextSearchTable(TSTable)
% Check that the specified table is a table created by the newTextSearchTable function.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  TSTable table
end  % arguments

arguments (Output)
  TrueOrFalse (:,1) logical
end  % arguments

expected_table = FileTool3.newTextSearchTable;

expected_varnames = sort(string(properties(expected_table.Properties.VariableNames)));
actual_varnames = sort(string(properties(TSTable.Properties.VariableNames)));

if numel(expected_varnames) ~= numel(actual_varnames)
  TrueOrFalse = false;

  return

end  % if

logical_index = actual_varnames == expected_varnames;
if not(all(logical_index))
  TrueOrFalse = false;

  return

end  % if

if not(isprop(TSTable.Properties, "CustomProperties"))
  TrueOrFalse = false;

  return

end  % if

expected_customprops = sort(string(properties(expected_table.Properties.CustomProperties)));
actual_customprops = sort(string(properties(TSTable.Properties.CustomProperties)));

if numel(expected_customprops) ~= numel(actual_customprops)
  TrueOrFalse = false;

  return

end  % if

logical_index = actual_customprops == expected_customprops;
if not(all(logical_index))
  TrueOrFalse = false;

  return

end  % if

TrueOrFalse = true;
end  % function
