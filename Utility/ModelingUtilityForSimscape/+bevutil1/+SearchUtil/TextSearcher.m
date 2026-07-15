classdef TextSearcher < handle
  % Search text files for the specified text pattern.
  %
  % This class is designed to be used by tools such as
  % the bevutil1.SearchUtil.searchText command or the TextSearchApp.
  %
  % By default, search states in this class are created but not initialized for use.
  % To create an object of this class which is ready for use right away,
  % use the Initialization option with "default" or "states".
  %
  % If you specify Initialization="states", you must also specify the States option.
  % The States option is ignored if the Initialization is not "states".

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "TextSearcher:"
  end  % properties

  properties
    States (1,1) bevutil1.SearchUtil.TextSearchStates = bevutil1.SearchUtil.TextSearchStates
    DisplayInfo (1,1) logical = false
  end  % properties

  methods

    function App = TextSearcher(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.Initialization (1,1) string {mustBeMember(NameValuePair.Initialization, ["none", "default", "states"])} = "none"
        NameValuePair.States (1,:) bevutil1.SearchUtil.TextSearchStates
      end  % arguments

      switch NameValuePair.Initialization
        case "none"
          % Do nothing.

        case "default"
          setDefaults(App)

        case "states"
          setStates(App, NameValuePair.States)
      end  % if
    end  % function

    function setDefaults(searcher)
      %% Initialize states with simple values.
      searcher.States.SearchTextPattern = "Copyright";
      searcher.States.IgnoreCase = true;
      searcher.States.MatchWholeWord = false;

      searcher.States.TargetFolder = pwd;
      searcher.States.IncludeSubfolders = false;

      searcher.States.FileTypes = "*.m";

      searcher.States.SearchAll = false;
      searcher.States.SearchMATLAB = true;
      searcher.States.SearchMarkdown = false;
      searcher.States.SearchSimulink = false;
      searcher.States.SearchSimscape = false;
      searcher.States.SearchSVG = false;

      searcher.States.CustomFileTypes = "";

      searcher.States.ExcludeLiveScript = false;
      searcher.States.ExcludeMATLABCodeFile = false;
    end  % function

    function setStates(searcher, states)
      %% Set up states using the specified data.
      arguments (Input)
        searcher
        states (1,1) bevutil1.SearchUtil.TextSearchStates
      end  % arguments

      searcher.States.SearchTextPattern = states.SearchTextPattern;
      searcher.States.IgnoreCase = states.IgnoreCase;
      searcher.States.MatchWholeWord = states.MatchWholeWord;

      searcher.States.TargetFolder = states.TargetFolder;
      searcher.States.IncludeSubfolders = states.IncludeSubfolders;

      searcher.States.FileTypes = states.FileTypes;

      searcher.States.SearchAll = states.SearchAll;
      searcher.States.SearchMATLAB = states.SearchMATLAB;
      searcher.States.SearchMarkdown = states.SearchMarkdown;
      searcher.States.SearchSimulink = states.SearchSimulink;
      searcher.States.SearchSimscape = states.SearchSimscape;
      searcher.States.SearchSVG = states.SearchSVG;

      searcher.States.CustomFileTypes = states.CustomFileTypes;

      searcher.States.ExcludeLiveScript = states.ExcludeLiveScript;
      searcher.States.ExcludeMATLABCodeFile = states.ExcludeMATLABCodeFile;
    end  % function

    function [true_or_false, reason] = ready(searcher)
      %% Check that states are ready for running search.
      % Check is made only for essential states: SearchTextPattern, TargetFolder, and FileTypes.
      % If not ready, the name of the state which is not ready for search is returned as the reason.
      arguments (Output)
        true_or_false (1,1) logical
        reason (1,1) string
      end  % arguments

      true_or_false = false;
      reason = "";

      if isempty(searcher.States.SearchTextPattern) || (string(searcher.States.SearchTextPattern) == "")
        reason = "SearchTextPattern";

        return

      end  % if
      if searcher.States.TargetFolder == ""
        reason = "TargetFolder";

        return

      end  % if
      if isscalar(searcher.States.FileTypes) && searcher.States.FileTypes == ""
        reason = "FileTypes";

        return

      end  % if
      true_or_false = true;
    end  % if

    function buildFileTypes(searcher)
      %% Build the FileTypes state from other states.
      % FileTypes is a string scalar, e.g, "*.m", or a string array, e.g., ["*.m", "demo*.mdl"].

      if not(isempty(searcher.States.FileTypes)) && all(searcher.States.FileTypes ~= "")
        file_types = searcher.States.FileTypes;

      else
        if searcher.States.SearchAll
          searcher.States.SearchMATLAB = true;
          searcher.States.SearchMarkdown = true;
          searcher.States.SearchSimulink = true;
          searcher.States.SearchSimscape = true;
          searcher.States.SearchSVG = true;
        end  % if

        file_types = [];
        if searcher.States.SearchMATLAB
          file_types = [file_types, "*.m"];
        end  % if
        if searcher.States.SearchMarkdown
          file_types = [file_types, "*.md"];
        end  % if
        if searcher.States.SearchSimulink
          file_types = [file_types, "*.mdl"];
        end  % if
        if searcher.States.SearchSimscape
          file_types = [file_types, "*.ssc"];
        end  % if
        if searcher.States.SearchSVG
          file_types = [file_types, "*.svg"];
        end  % if
        if searcher.States.CustomFileTypes ~= ""
          file_types = [file_types, searcher.States.CustomFileTypes];
        end  % if
      end  % if

      if isempty(file_types) || (isscalar(file_types) && file_types == "")
        id = searcher.errorID + "InvalidFileTypes";
        msg = bevutil1.CodeUtil.i18n("File types must be specified.");

        throw(MException(id, msg))

      end  % if

      % Make file_types a column vector by applying (:).
      searcher.States.FileTypes = file_types(:);
    end  % if

    function argumentText = getCommandArgumentText(searcher)
      %%

      % The Filter option is not supported.

      if not(ready(searcher))
        id = searcher.errorID + "SearchIsNotReady";
        msg = bevutil1.CodeUtil.i18n("Search is not ready. Specify all required options.");

        throw(MException(id, msg))

      end  % if

      upper_bound = 100;
      k = 0;
      opts = strings(upper_bound, 1);

      k = k+1;
      opts(k) = searcher.States.SearchTextPattern;

      k = k+1;
      opts(k) = sprintf("IgnoreCase = %s", string(searcher.States.IgnoreCase));
      k = k+1;
      opts(k) = sprintf("MatchWholeWord = %s", string(searcher.States.MatchWholeWord));

      k = k+1;
      opts(k) = sprintf("TargetFolder = ""%s""", searcher.States.TargetFolder);
      k = k+1;
      opts(k) = sprintf("IncludeSubfolders = %s", string(searcher.States.IncludeSubfolders));

      if searcher.States.FileTypes ~= ""
        file_types = "[""" + join(searcher.States.FileTypes, """, """) + """]";
        k = k+1;
        opts(k) = sprintf("FileTypes = %s", file_types);

      else
        k = k+1;
        opts(k) = sprintf("SearchAll = %s", string(searcher.States.SearchAll));
        k = k+1;
        opts(k) = sprintf("SearchMATLAB = %s", string(searcher.States.SearchMATLAB));
        k = k+1;
        opts(k) = sprintf("SearchMarkdown = %s", string(searcher.States.SearchMarkdown));
        k = k+1;
        opts(k) = sprintf("SearchSimulink = %s", string(searcher.States.SearchSimulink));
        k = k+1;
        opts(k) = sprintf("SearchSimscape = %s", string(searcher.States.SearchSimscape));
        k = k+1;
        opts(k) = sprintf("SearchSVG = %s", string(searcher.States.SearchSVG));

        if searcher.States.CustomFileTypes ~= ""
          custom_file_types = "[""" + join(searcher.States.CustomFileTypes, """, """) + """]";
        else
          custom_file_types = '""';
        end  % if
        k = k+1;
        opts(k) = sprintf("CustomFileTypes = %s", custom_file_types);

      end  % if

      k = k+1;
      opts(k) = sprintf("ExcludeLiveScript = %s", string(searcher.States.ExcludeLiveScript));
      k = k+1;
      opts(k) = sprintf("ExcludeMATLABCodeFile = %s", string(searcher.States.ExcludeMATLABCodeFile));

      assert(k < upper_bound, searcher.errorID+"FatalError", bevutil1.CodeUtil.i18n("Fatal error"))

      opts(k+1 : end) = [];
      argumentText = join(opts, ", ");
    end  % function

    function result = runSearch(searcher)
      %%
      arguments (Output)
        result (:,3) table
      end  % arguments

      if not(ready(searcher))
        id = searcher.errorID + "NotReady";
        msg = bevutil1.CodeUtil.i18n("Search is not ready. Specify all required options.");

        throw(MException(id, msg))

      end  % if

      buildFileTypes(searcher);

      % -----------------------------------------------------------------------
      % First pass: Find files as matlab.buildtool.io.FileCollection

      if searcher.States.IncludeSubfolders
        collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(searcher.States.TargetFolder, "**", searcher.States.FileTypes));
      else
        collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(searcher.States.TargetFolder, searcher.States.FileTypes));
      end  % if

      if searcher.DisplayInfo
        disp("File collection:")
        disp(collection)
      end  % if

      % Apply file filters.
      % Use the select function to apply filters to the collection. See the documentation for details.
      % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html

      if searcher.States.ExcludeLiveScript
        collection = select(collection, @(x) not(bevutil1.FileUtil.isPlainTextLiveScript(x)));
      end  %if

      if searcher.States.ExcludeMATLABCodeFile
        collection = select(collection, @(x) endsWith(x, ".m") & bevutil1.FileUtil.isPlainTextLiveScript(x));
      end  %if

      if not(isempty(searcher.States.Filter))
        collection = select(collection, @(x) searcher.States.Filter(x));
      end  % if

      % -----------------------------------------------------------------------
      % Number of files found
      found_files = paths(collection)';
      num_files = numel(found_files);
      if num_files == 0
        if searcher.DisplayInfo
          disp("No files matched with specified file types.")
        end  % if
        result = table([], [], [], 'VariableNames', ["FilePath", "LineNumber", "LineText"]);

        return

      end  % if

      % -----------------------------------------------------------------------
      % Second pass: Determine the number of rows necessary for a table.

      if searcher.States.MatchWholeWord
        % Use alphanumericBoundary, not letterBoundary.
        % There is a letter boundary between "c" and "2" in "abc12".
        %
        % Examples:
        %
        %   replace("abc12", letterBoundary, "|")
        %   "|abc|12"
        %
        %   replace("abc12", alphanumericBoundary, "|")
        %   "|abc12|"
        %
        search_text = alphanumericBoundary + searcher.States.SearchTextPattern + alphanumericBoundary;
      else
        search_text = searcher.States.SearchTextPattern;
      end  % if

      file_path = strings(num_files, 1);
      num_rows = 0;
      for ii = 1 : num_files
        target_file = found_files(ii);
        lines = readlines(target_file);
        logical_index = contains(lines, search_text, IgnoreCase = searcher.States.IgnoreCase);
        num_lines = nnz(logical_index);
        if num_lines == 0

          continue

        end  % if
        file_path(ii) = target_file;
        num_rows = num_rows + num_lines;
      end  % for

      if num_rows == 0
        if searcher.DisplayInfo
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
      item_count = 0;
      for ii = 1 : num_files
        target_file = file_path(ii);
        lines = readlines(target_file);
        logical_index = contains(lines, search_text, IgnoreCase = searcher.States.IgnoreCase);
        line_number = find(logical_index);
        line_text = lines(logical_index);
        for jj = 1 : numel(line_text)
          item_count = item_count + 1;
          if searcher.States.TargetFolder == ""
            FilePath(item_count) = target_file;
          else
            FilePath(item_count) = extractAfter(target_file, searcher.States.TargetFolder + ("/"|"\"));
          end  % if
          LineNumber(item_count) = line_number(jj);
          LineText(item_count) = line_text(jj);
        end  % for
      end  % for
      result = table(FilePath, LineNumber, LineText);
    end  % function

  end  % methods
end  % classdef
