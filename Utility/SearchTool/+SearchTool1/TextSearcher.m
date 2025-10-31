classdef TextSearch < handle

  % Copyright 2025 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearch:"
  end  % properties

  properties
    States (1,1) SearchTool1.TextSearchStates = SearchTool1.TextSearchStates
    DisplayInfo (1,1) logical = false
  end  % properties

  methods

    function App = TextSearch()
    end  % function

    function setDefaults(searchObject)
      %%
      searchObject.States.SearchTextPattern = "Copyright";
      searchObject.States.IgnoreCase = true;
      searchObject.States.MatchWholeWord = false;

      searchObject.States.TargetFolder = pwd;
      searchObject.States.IncludeSubfolders = false;

      searchObject.States.FileTypes = "*.m";

      searchObject.States.SearchAll = false;
      searchObject.States.SearchMATLAB = true;
      searchObject.States.SearchMarkdown = false;
      searchObject.States.SearchSimulink = false;
      searchObject.States.SearchSimscape = false;
      searchObject.States.SearchSVG = false;

      searchObject.States.CustomFileTypes = "";

      searchObject.States.ExcludeLiveScript = false;
      searchObject.States.ExcludeMATLABCodeFile = false;
    end  % function

    function true_or_false = ready(searchObject)
      %%
      true_or_false = false;
      if isempty(searchObject.States.SearchTextPattern) || (string(searchObject.States.SearchTextPattern) == "")

        return

      end  % if
      if searchObject.States.TargetFolder == ""

        return

      end  % if
      if isscalar(searchObject.States.FileTypes) && searchObject.States.FileTypes == "" ...
          && isscalar(searchObject.States.CustomFileTypes) && searchObject.States.CustomFileTypes == ""

        return

      end  % if
      true_or_false = true;
    end  % if

    function buildFileTypes(searchObject)
      %%

      if any(searchObject.States.FileTypes == "")
        id = searchObject.errorID + "InvalidFileTypes";
        msg = CodeTool1.i18n("Empty file type is not allowed.");

        throw(MException(id, msg))

      end  % if

      if not(isempty(searchObject.States.FileTypes)) && all(searchObject.States.FileTypes ~= "")
        file_types = searchObject.States.FileTypes;

      else
        if searchObject.States.SearchAll
          searchObject.States.SearchMATLAB = true;
          searchObject.States.SearchMarkdown = true;
          searchObject.States.SearchSimulink = true;
          searchObject.States.SearchSimscape = true;
          searchObject.States.SearchSVG = true;
        end  % if

        file_types = [];
        if searchObject.States.SearchMATLAB
          file_types = [file_types, "*.m"];
        end  % if
        if searchObject.States.SearchMarkdown
          file_types = [file_types, "*.md"];
        end  % if
        if searchObject.States.SearchSimulink
          file_types = [file_types, "*.mdl"];
        end  % if
        if searchObject.States.SearchSimscape
          file_types = [file_types, "*.ssc"];
        end  % if
        if searchObject.States.SearchSVG
          file_types = [file_types, "*.svg"];
        end  % if
        if searchObject.States.CustomFileTypes ~= ""
          file_types = [file_types, searchObject.States.CustomFileTypes];
        end  % if
      end  % if

      if isempty(file_types) || (isscalar(file_types) && file_types == "")
        id = searchObject.errorID + "InvalidFileTypes";
        msg = CodeTool1.i18n("File types must be specified.");

        throw(MException(id, msg))

      end  % if

      % Make file_types a column vector by applying (:).
      searchObject.States.FileTypes = file_types(:);
    end  % if

    function argumentText = getCommandArgumentText(searchObject)
      %%

      % The Filter option is not suported.

      if not(ready(searchObject))
        id = searchObject.errorID + "SearchIsNotReady";
        msg = CodeTool1.i18n("Search is not ready. Specify all required options.");

        throw(MException(id, msg))

      end  % if

      upper_bound = 100;
      k = 0;
      opts = strings(upper_bound, 1);

      k = k+1;
      opts(k) = searchObject.States.SearchTextPattern;

      k = k+1;
      opts(k) = sprintf("TargetFolder = ""%s""", searchObject.States.TargetFolder);
      k = k+1;
      opts(k) = sprintf("IncludeSubfolders = %s", string(searchObject.States.IncludeSubfolders));

      if searchObject.States.FileTypes ~= ""
        file_types = "[""" + join(searchObject.States.FileTypes, """, """) + """]";
      else
        file_types = '""';
      end  % if
      k = k+1;
      opts(k) = sprintf("FileTypes = %s", file_types);

      k = k+1;
      opts(k) = sprintf("SearchAll = %s", string(searchObject.States.SearchAll));
      k = k+1;
      opts(k) = sprintf("SearchMATLAB = %s", string(searchObject.States.SearchMATLAB));
      k = k+1;
      opts(k) = sprintf("SearchMarkdown = %s", string(searchObject.States.SearchMarkdown));
      k = k+1;
      opts(k) = sprintf("SearchSimulink = %s", string(searchObject.States.SearchSimulink));
      k = k+1;
      opts(k) = sprintf("SearchSimscape = %s", string(searchObject.States.SearchSimscape));
      k = k+1;
      opts(k) = sprintf("SearchSVG = %s", string(searchObject.States.SearchSVG));

      if searchObject.States.CustomFileTypes ~= ""
        custom_file_types = "[""" + join(searchObject.States.CustomFileTypes, """, """) + """]";
      else
        custom_file_types = '""';
      end  % if
      k = k+1;
      opts(k) = sprintf("CustomFileTypes = %s", custom_file_types);

      k = k+1;
      opts(k) = sprintf("ExcludeLiveScript = %s", string(searchObject.States.ExcludeLiveScript));
      k = k+1;
      opts(k) = sprintf("ExcludeMATLABCodeFile = %s", string(searchObject.States.ExcludeMATLABCodeFile));

      k = k+1;
      opts(k) = sprintf("IgnoreCase = %s", string(searchObject.States.IgnoreCase));
      k = k+1;
      opts(k) = sprintf("MatchWholeWord = %s", string(searchObject.States.MatchWholeWord));

      assert(k < upper_bound, searchObject.errorID+"FatalError", CodeTool1.i18n("Fatal error"))

      opts(k+1 : end) = [];
      argumentText = join(opts, ", ");
    end  % function

    function result = runSearch(searchObject)
      %%
      arguments (Output)
        result (:,3) table
      end  % arguments

      if not(ready(searchObject))
        id = searchObject.errorID + "NotReady";
        msg = CodeTool1.i18n("Search is nto ready. Specify all required options.");

        throw(MException(id, msg))

      end  % if

      buildFileTypes(searchObject);

      % -----------------------------------------------------------------------
      % First pass: Find files as matlab.buildtool.io.FileCollection

      if searchObject.States.IncludeSubfolders
        collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(searchObject.States.TargetFolder, "**", searchObject.States.FileTypes));
      else
        collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(searchObject.States.TargetFolder, searchObject.States.FileTypes));
      end  % if

      if searchObject.DisplayInfo
        disp("File collection:")
        disp(collection)
      end  % if

      % Apply file filters.
      % Use the select function to apply filters to the collection. See the documentation for details.
      % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html

      if searchObject.States.ExcludeLiveScript
        collection = select(collection, @(x) not(FileTool3.isPlainTextLiveScript(x)));
      end  %if

      if searchObject.States.ExcludeMATLABCodeFile
        collection = select(collection, @(x) endsWith(x, ".m") & FileTool3.isPlainTextLiveScript(x));
      end  %if

      if not(isempty(searchObject.States.Filter))
        collection = select(collection, @(x) searchObject.States.Filter(x));
      end  % if

      % -----------------------------------------------------------------------
      % Number of files found
      found_files = paths(collection)';
      num_files = numel(found_files);
      if num_files == 0
        if searchObject.DisplayInfo
          disp("No files matched with specified file types.")
        end  % if
        result = table([], [], [], 'VariableNames', ["FilePath", "LineNumber", "LineText"]);

        return

      end  % if

      % -----------------------------------------------------------------------
      % Second pass: Determine the number of rows necessary for a table.

      if searchObject.States.MatchWholeWord
        b = (lineBoundary|textBoundary|whitespaceBoundary|alphanumericBoundary);
        search_text = b + searchObject.States.SearchTextPattern + b;
      else
        search_text = searchObject.States.SearchTextPattern;
      end  % if

      file_path = strings(num_files, 1);
      num_rows = 0;
      for ii = 1 : num_files
        target_file = found_files(ii);
        lines = readlines(target_file);
        logical_index = contains(lines, search_text, IgnoreCase = searchObject.States.IgnoreCase);
        num_lines = nnz(logical_index);
        if num_lines == 0

          continue

        end  % if
        file_path(ii) = target_file;
        num_rows = num_rows + num_lines;
      end  % for

      if num_rows == 0
        if searchObject.DisplayInfo
          disp("Specified search text was not found.")
        end  % if
        result = table([], [], [], 'VariableNames', ["FilePath", "LineNumber", "LineText"]);

        return

      end  % if

      logical_index = file_path ~= "";
      file_path = file_path(logical_index);

      % -----------------------------------------------------------------------
      % Third pass: Build a table containing matched lines.

      FilePath = strings(num_rows, 1);
      LineNumber = nan(num_rows, 1);
      LineText = strings(num_rows, 1);

      num_files = numel(file_path);
      cnt = 0;
      for ii = 1 : num_files
        target_file = file_path(ii);
        lines = readlines(target_file);
        logical_index = contains(lines, search_text, IgnoreCase = searchObject.States.IgnoreCase);
        line_number = find(logical_index);
        line_text = lines(logical_index);
        for jj = 1 : numel(line_text)
          cnt = cnt + 1;
          if searchObject.States.TargetFolder == ""
            FilePath(cnt) = target_file;
          else
            FilePath(cnt) = extractAfter(target_file, searchObject.States.TargetFolder + ("/"|"\"));
          end  % if
          LineNumber(cnt) = line_number(jj);
          LineText(cnt) = line_text(jj);
        end  % for
      end  % for
      result = table(FilePath, LineNumber, LineText);
    end  % function

  end  % methods
end  % classdef
