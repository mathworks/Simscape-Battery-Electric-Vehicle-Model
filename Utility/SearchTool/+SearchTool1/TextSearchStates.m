classdef TextSearchStates

  % Copyright 2025 The MathWorks, Inc.

  properties

    TargetFolder (1,1) string = ""
    IncludeSubfolders (1,1) logical = false

    FileTypes (1,:) string = ""

    SelectAll (1,1) logical = false
    SelectMATLAB (1,1) logical = false
    SelectMarkdown (1,1) logical = false
    SelectSimulink (1,1) logical = false
    SelectSimscape (1,1) logical = false
    SelectSVG (1,1) logical = false

    CustomFileTypes (1,:) string = ""

    ExcludeLiveScript (1,1) logical = false
    ExcludeMATLABCodeFile (1,1) logical = false

    IgnoreCase (1,1) logical = false
    MatchWholeWord (1,1) logical = false
    SearchText (1,1) logical = false

    Filter (:,1) {CodeTool1.mustBeFunctionHandleOrEmpty} = []

    IncludeStyledFilePath (1,1) logical = false

    DisplayInfo (1,1) logical = false

  end  % properties

  methods

    function states = TextSearchStates
    end  % function

    function tbl = addTextSearchStates(States, tbl)

      mc = metaclass(States);
      custom_properties = string({mc.PropertyList.Name}');

      tbl = addprop(tbl, custom_properties, repmat("table", 1, numel(custom_properties)));

      tbl.Properties.CustomProperties.TargetFolder = States.TargetFolder;
      tbl.Properties.CustomProperties.IncludeSubfolders = States.IncludeSubfolders;

      tbl.Properties.CustomProperties.FileTypes = States.FileTypes;

      tbl.Properties.CustomProperties.SelectAll = States.SelectAll;
      tbl.Properties.CustomProperties.SelectMATLAB = States.SelectMATLAB;
      tbl.Properties.CustomProperties.SelectMarkdown = States.SelectMarkdown;
      tbl.Properties.CustomProperties.SelectSimulink = States.SelectSimulink;
      tbl.Properties.CustomProperties.SelectSimscape = States.SelectSimscape;
      tbl.Properties.CustomProperties.SelectSVG = States.SelectSVG;

      tbl.Properties.CustomProperties.CustomFileTypes = States.CustomFileTypes;

      tbl.Properties.CustomProperties.ExcludeLiveScript = States.ExcludeLiveScript;
      tbl.Properties.CustomProperties.ExcludeMATLABCodeFile = States.ExcludeMATLABCodeFile;

      tbl.Properties.CustomProperties.IgnoreCase = States.IgnoreCase;
      tbl.Properties.CustomProperties.MatchWholeWord = States.MatchWholeWord;
      tbl.Properties.CustomProperties.SearchText = States.SearchText;

      tbl.Properties.CustomProperties.Filter = States.Filter;

      tbl.Properties.CustomProperties.IncludeStyledFilePath = States.IncludeStyledFilePath;

      tbl.Properties.CustomProperties.DisplayInfo = States.DisplayInfo;

    end  % function

  end  % methods
end  % classdef
