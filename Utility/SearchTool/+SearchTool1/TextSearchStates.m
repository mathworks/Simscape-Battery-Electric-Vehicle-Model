classdef TextSearchStates
  % States of the text searcher.
  %
  % For the states to be ready for search, at least these three states
  % must be set up: SearchTextPattern, TargetFolder, and FileTypes.

  % Copyright 2025 The MathWorks, Inc.

  properties

    SearchTextPattern (1,:) pattern
    IgnoreCase (1,1) logical = false
    MatchWholeWord (1,1) logical = false

    TargetFolder (1,1) string = ""
    IncludeSubfolders (1,1) logical = false

    % Array or scalar of string, e.g., ["*.m", "*.mdl"]
    FileTypes (1,:) string = ""

    SearchAll (1,1) logical = false
    SearchMATLAB (1,1) logical = false
    SearchMarkdown (1,1) logical = false
    SearchSimulink (1,1) logical = false
    SearchSimscape (1,1) logical = false
    SearchSVG (1,1) logical = false

    % Array or scalar of string, e.g., ["*.m", "*.mdl"]
    CustomFileTypes (1,:) string = ""

    ExcludeLiveScript (1,1) logical = false
    ExcludeMATLABCodeFile (1,1) logical = false

    Filter (:,1) {CodeTool1.mustBeFunctionHandleOrEmpty} = []

  end  % properties
end  % classdef
