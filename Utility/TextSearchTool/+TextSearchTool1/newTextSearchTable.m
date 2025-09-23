function tstable = newTextSearchTable(FilePath, LineNumber, LineText, NameValuePair)
% Create a new table for searching text in files.
%
% This function creates a table which is customized for storing the result
% of searching text in files. The created table has three columns and custom
% properties specifically designed for storing the search text result.
%
% If this function is called without arguments, it creates an empty table with
% custom columns and custom properties.
%
% If arguments are passed to this function, all arguments must have the same length.
%
% As an example, if tstable is a table created by this function, custom properties
% are available as tstable.Properties.CustomProperties. For more information about
% table custom properties, see the documentation.
% https://www.mathworks.com/help/matlab/ref/table.addprop.html

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  FilePath (:,1) string = ""
  LineNumber (:,1) {mustBeInteger, mustBePositive} = 1
  LineText (:,1) string = ""
  NameValuePair.IncludeStyledFilePath (1,1) logical = false
end

arguments (Output)
  tstable table
end  % arguments

errorID = "newTextSearchTable:";

if (isscalar(FilePath) && FilePath=="") && ...
    (isscalar(LineNumber) && LineNumber==1) && ...
    (isscalar(LineText) && LineText=="")
  if NameValuePair.IncludeStyledFilePath
    tstable = table([], [], [], [], VariableNames=["StyledFilePath", "FilePath", "LineNumber", "LineText"]);
  else
    tstable = table([], [], [], VariableNames=["FilePath", "LineNumber", "LineText"]);
  end  % if

else
  same_numel = numel(FilePath) == numel(LineNumber) && numel(LineNumber) == numel(LineText);
  if not(same_numel)
    id = errorID + "NotSameSize";
    msg = CodeTool1.i18n("The number of elements of all columns must be the same.");

    throw(MException(id, msg))

  else
    if NameValuePair.IncludeStyledFilePath
      StyledFilePath = replace(FilePath, ("/"|"\"), " > ");
      tstable = table(StyledFilePath, FilePath, LineNumber, LineText);
    else
      tstable = table(FilePath, LineNumber, LineText);
    end  % if
  end  % if
end  % if

% The custom properties correspond to the options for the searchText function.
%
% FileTypesString and TextPatternString properties correspond to
% FileTypes and TextPattern options for the searchText function.
%
% FileTypes for searchText is an array of string, e.g., ["*.m", "*.mdl"].
% FileTypesString must be a string, e.g. "*.m, *.mdl", which you can get
% from FileTypes, i.e., FileTypesString = join(FileTypes, ", ").
%
% TextPattern for searchText is a pattern, e.g.,
%   TextPattern = textBoundary + "some text" + textBoundary;
% TextPatternString is just a string, e.g.,
%   TextPatternString = "some text";
% This is a limitation at this moment.

custom_properties = [
  "TargetFolder"
  "IncludeSubfolders"
  "FileTypesString"
  "FileTypes"
  "ExcludeLiveScript"
  "ExcludeMATLABCodeFile"
  "TextPatternString"
  "TextPattern"
  "IgnoreCase"
  "MatchWholeWord"
  "IncludeStyledFilePath"
  ]';

tstable = addprop(tstable, custom_properties, repmat("table", 1, numel(custom_properties)));

tstable.Properties.CustomProperties.TargetFolder = "";
tstable.Properties.CustomProperties.IncludeSubfolders = false;
tstable.Properties.CustomProperties.FileTypesString = "*.m, *.mdl";
tstable.Properties.CustomProperties.FileTypes = ["*.m", "*.mdl"];
tstable.Properties.CustomProperties.ExcludeLiveScript = false;
tstable.Properties.CustomProperties.ExcludeMATLABCodeFile = false;
tstable.Properties.CustomProperties.TextPatternString = "Copyright";
tstable.Properties.CustomProperties.TextPattern = alphanumericBoundary + "Copyright" + alphanumericBoundary;
tstable.Properties.CustomProperties.IgnoreCase = true;
tstable.Properties.CustomProperties.MatchWholeWord = false;
tstable.Properties.CustomProperties.IncludeStyledFilePath = NameValuePair.IncludeStyledFilePath;

end  % function
