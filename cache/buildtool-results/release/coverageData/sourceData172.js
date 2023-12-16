var sourceData172 = {"FileName":"C:\\local\\github-issacito12\\fork-bev\\Utility\\LocalTasks\\LiveScript_Utility.m","RawFileContents":["classdef LiveScript_Utility\r","\r","  % Copyright 2023 The MathWorks, Inc.\r","\r","  methods (Static)\r","\r","    function RunLiveScript_and_GenerateMarkdown(LiveScriptFilenames, nvpairs)\r","      %% Export Live Script to Markdown file\r","      % Use browser to view exported Markdown file.\r","      arguments (Input)\r","        % Live scripts to export\r","        LiveScriptFilenames (:,1) string {mustBeFile}\r","\r","        % Relative top the current working folder.\r","        nvpairs.ImageFileFolderName (1,1) string {mustBeFolder} = \"Images\"\r","\r","        nvpairs.ForceExport (1,1) logical = false\r","      end\r","\r","      assert(all(endsWith(LiveScriptFilenames, \".mlx\")), \"Filename must end with \"\".mlx\"\"\")\r","      sourcefiles = LiveScriptFilenames;\r","      destfiles = replace(LiveScriptFilenames, \".mlx\", \".md\");\r","\r","      for idx = 1 : numel(sourcefiles)\r","        if nvpairs.ForceExport || ...\r","            LiveScript_Utility.SourceFile_isNewerThan_destinationFile(Source=sourcefiles(idx), Destination=destfiles(idx))\r","          disp(\"Exporting markdown from \" + sourcefiles(idx))\r","\r","          LiveScript_Utility.GenerateMarkdown( ...\r","            sourcefiles(idx), ...\r","            ImageFileFolderName = nvpairs.ImageFileFolderName)\r","\r","        else\r","          disp(\"Skipped because markdown file is up to date for \" + sourcefiles(idx))\r","        end  % if\r","      end  % for\r","    end  % function\r","\r","\r","    function source_is_newer = SourceFile_isNewerThan_destinationFile(nvpairs)\r","      arguments (Input)\r","        % Source file must exist.\r","        nvpairs.Source (1,1) {mustBeFile}\r","\r","        % Destination file may not exist.\r","        nvpairs.Destination (1,1) string\r","      end\r","      arguments (Output)\r","        % True if you want to take action because...\r","        % - Source file is newer than destination file. You want to update destination file.\r","        % - Destination file does not exist. You want to create destination file.\r","        source_is_newer (1,1) logical\r","      end\r","      source_is_newer = false;\r","      sourcefile_info = dir(nvpairs.Source);\r","      % As of R2022b, serial date numbers are not recommended.\r","      % Convert the serial date number to a datetime value by using the datetime function.\r","      sourcefile_datetime = datetime(sourcefile_info.datenum, ConvertFrom=\"datenum\");\r","      if isfile(nvpairs.Destination)\r","        destfile_info = dir(nvpairs.Destination);\r","        destfile_datetime = datetime(destfile_info.datenum, ConvertFrom=\"datenum\");\r","        if sourcefile_datetime > destfile_datetime\r","          source_is_newer = true;\r","        end  % if\r","      else\r","        % Destination file does not exist.\r","        source_is_newer = true;\r","      end  % if\r","    end  % function\r","\r","\r","    function GenerateMarkdown(LiveScriptFileName, nvpairs)\r","      %% Generates a Markdown file from a Live Script.\r","\r","      % This function uses MATLAB's `export` command to generate a Markdown file\r","      % from a Live Script. `export` was first released in R2022a.\r","      %\r","      % This function applies a few changes to the `export`s behavior as follows.\r","      %\r","      % 1. Image folder\r","      %\r","      % `export` generates a folder to store image files created from\r","      % a Live Script for use in a Markdown file, but\r","      % separate folders are created for separate Live Scripts.\r","      % This can result in many folders in the working folder\r","      % if many Live Scripts are exported to Markdown.\r","      %\r","      % This function moves the image folder under a folder called \"Images\"\r","      % and updates the path strings in the Markdown file.\r","      % With this function, you can collect image folders for multiple Markdown files\r","      % under the same folder to keep the working folder clean.\r","      % Optionally, you can specify the image folder name.\r","      %\r","      % 2. Title line\r","      %\r","      % `export` generates a Markdown file which has an empty line at line 1 and\r","      % a span tag in line 2.\r","      % This function removes the top empty line and the span tag.\r","      % The resulting style is more typical as a title line for Markdown files.\r","\r","      arguments\r","        LiveScriptFileName (1,1) string {mustBeFile} = \"MyLiveScript.mlx\"\r","\r","        % Relative top the current working folder.\r","        nvpairs.ImageFileFolderName (1,1) string {mustBeFolder} = \"Images\"\r","      end\r","\r","      assert(endsWith(LiveScriptFileName, \".mlx\"))\r","\r","      %{=\r","      export( LiveScriptFileName, ...\r","        Format = \"markdown\", ...\r","        AcceptHTML = true, ...  Must be true to show images\r","        RenderLaTexOnline = \"off\", ... Do not access external internet sites from markdown file\r","        HideCode = false, ...\r","        Run = true, ... Run script before export. Takes time, but necessary to always get expected result.\r","        IncludeOutputs = true, ... Include MATLAB output\r","        FigureFormat = \"png\", ...\r","        EmbedImages = false, ... Save images to individual image files\r","        FigureResolution = 120 ); ... This affects the size of image file\r","        %}\r","\r","      %% Move image files generated from live script for use in markdown file\r","\r","      [~, name_part, ~] = fileparts(LiveScriptFileName);\r","\r","      image_folder_basename = name_part + \"_media\";\r","\r","      image_folder_original_path = image_folder_basename;\r","\r","      image_folder_new_path = nvpairs.ImageFileFolderName + \"/\" + image_folder_basename;\r","\r","      %{=\r","      copyfile(image_folder_original_path + \"/*\", image_folder_new_path)\r","\r","      rmdir(image_folder_original_path, \"s\")\r","      %}\r","\r","      %% Update path strings in markdown file to point to the new image file path\r","\r","      markdown_file_name = name_part + \".md\";\r","\r","      markdown_file_path = markdown_file_name;\r","\r","      disp(\"Generating a Markdown file: \" + markdown_file_path)\r","\r","      content = fileread(markdown_file_path);\r","\r","      content = string(content);\r","\r","      % File separator must be forward slash.\r","      target_string = \"<img src=\"\"\" + image_folder_basename + \"/\";\r","\r","      if contains(content, target_string)\r","        disp(\"Updating the path string for images.\")\r","      else\r","        warning(\"The \"\"img\"\" tag string did not match.\")\r","      end\r","\r","      new_string = \"<img src=\"\"\" + image_folder_new_path + \"/\";\r","\r","      new_content = replace(content, target_string, new_string);\r","\r","      %% Clean up the title line\r","\r","      % 1. Remove the empty line at line 1.\r","      % 2. Remove the \"span\" HTML tag from the title at line 2.\r","      new_content = replace(new_content, newline + \"# <span style=\"\"color:rgb(213,80,0)\"\">\", \"# \");\r","      new_content = replace(new_content, \"</span>\", \"\");\r","\r","      %% Save the updated markdown file\r","\r","      new_tmp_mdfile = tempname(pwd) + \".md\";\r","\r","      fd = fopen(new_tmp_mdfile, \"w\");\r","      fprintf(fd, \"%s\", new_content);\r","      fclose(fd);\r","\r","      %{=\r","      copyfile(new_tmp_mdfile, markdown_file_name)\r","      delete(new_tmp_mdfile)\r","      %}\r","\r","      disp(\"done\")\r","\r","    end  % function\r","\r","  end  % methods\r","end  % classdef\r",""],"CoverageDisplayDataPerLine":{"Function":[{"LineNumber":7,"Hits":0,"StartColumnNumbers":4,"EndColumnNumbers":77,"ContinuedLine":false},{"LineNumber":40,"Hits":0,"StartColumnNumbers":4,"EndColumnNumbers":78,"ContinuedLine":false},{"LineNumber":72,"Hits":0,"StartColumnNumbers":4,"EndColumnNumbers":58,"ContinuedLine":false}],"Statement":[{"LineNumber":12,"Hits":0,"StartColumnNumbers":42,"EndColumnNumbers":52,"ContinuedLine":false},{"LineNumber":15,"Hits":[0,0],"StartColumnNumbers":[50,66],"EndColumnNumbers":[62,74],"ContinuedLine":false},{"LineNumber":17,"Hits":0,"StartColumnNumbers":44,"EndColumnNumbers":49,"ContinuedLine":false},{"LineNumber":20,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":91,"ContinuedLine":false},{"LineNumber":21,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":40,"ContinuedLine":false},{"LineNumber":22,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":62,"ContinuedLine":false},{"LineNumber":24,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":38,"ContinuedLine":false},{"LineNumber":25,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":32,"ContinuedLine":false},{"LineNumber":26,"Hits":0,"StartColumnNumbers":12,"EndColumnNumbers":122,"ContinuedLine":true},{"LineNumber":27,"Hits":0,"StartColumnNumbers":10,"EndColumnNumbers":61,"ContinuedLine":false},{"LineNumber":29,"Hits":0,"StartColumnNumbers":10,"EndColumnNumbers":46,"ContinuedLine":false},{"LineNumber":30,"Hits":0,"StartColumnNumbers":12,"EndColumnNumbers":28,"ContinuedLine":true},{"LineNumber":31,"Hits":0,"StartColumnNumbers":12,"EndColumnNumbers":62,"ContinuedLine":true},{"LineNumber":34,"Hits":0,"StartColumnNumbers":10,"EndColumnNumbers":85,"ContinuedLine":false},{"LineNumber":43,"Hits":0,"StartColumnNumbers":30,"EndColumnNumbers":40,"ContinuedLine":false},{"LineNumber":54,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":30,"ContinuedLine":false},{"LineNumber":55,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":44,"ContinuedLine":false},{"LineNumber":58,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":85,"ContinuedLine":false},{"LineNumber":59,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":36,"ContinuedLine":false},{"LineNumber":60,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":49,"ContinuedLine":false},{"LineNumber":61,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":83,"ContinuedLine":false},{"LineNumber":62,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":50,"ContinuedLine":false},{"LineNumber":63,"Hits":0,"StartColumnNumbers":10,"EndColumnNumbers":33,"ContinuedLine":false},{"LineNumber":67,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":31,"ContinuedLine":false},{"LineNumber":102,"Hits":[0,0],"StartColumnNumbers":[41,55],"EndColumnNumbers":[51,73],"ContinuedLine":false},{"LineNumber":105,"Hits":[0,0],"StartColumnNumbers":[50,66],"EndColumnNumbers":[62,74],"ContinuedLine":false},{"LineNumber":108,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":50,"ContinuedLine":false},{"LineNumber":111,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":32,"ContinuedLine":false},{"LineNumber":112,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":27,"ContinuedLine":true},{"LineNumber":113,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":25,"ContinuedLine":true},{"LineNumber":114,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":33,"ContinuedLine":true},{"LineNumber":115,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":24,"ContinuedLine":true},{"LineNumber":116,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":18,"ContinuedLine":true},{"LineNumber":117,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":29,"ContinuedLine":true},{"LineNumber":118,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":28,"ContinuedLine":true},{"LineNumber":119,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":27,"ContinuedLine":true},{"LineNumber":120,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":33,"ContinuedLine":true},{"LineNumber":125,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":56,"ContinuedLine":false},{"LineNumber":127,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":51,"ContinuedLine":false},{"LineNumber":129,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":57,"ContinuedLine":false},{"LineNumber":131,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":88,"ContinuedLine":false},{"LineNumber":134,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":72,"ContinuedLine":false},{"LineNumber":136,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":44,"ContinuedLine":false},{"LineNumber":141,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":45,"ContinuedLine":false},{"LineNumber":143,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":46,"ContinuedLine":false},{"LineNumber":145,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":63,"ContinuedLine":false},{"LineNumber":147,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":45,"ContinuedLine":false},{"LineNumber":149,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":32,"ContinuedLine":false},{"LineNumber":152,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":66,"ContinuedLine":false},{"LineNumber":154,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":41,"ContinuedLine":false},{"LineNumber":155,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":52,"ContinuedLine":false},{"LineNumber":157,"Hits":0,"StartColumnNumbers":8,"EndColumnNumbers":56,"ContinuedLine":false},{"LineNumber":160,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":63,"ContinuedLine":false},{"LineNumber":162,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":64,"ContinuedLine":false},{"LineNumber":168,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":99,"ContinuedLine":false},{"LineNumber":169,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":56,"ContinuedLine":false},{"LineNumber":173,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":45,"ContinuedLine":false},{"LineNumber":175,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":38,"ContinuedLine":false},{"LineNumber":176,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":37,"ContinuedLine":false},{"LineNumber":177,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":17,"ContinuedLine":false},{"LineNumber":180,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":50,"ContinuedLine":false},{"LineNumber":181,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":28,"ContinuedLine":false},{"LineNumber":184,"Hits":0,"StartColumnNumbers":6,"EndColumnNumbers":18,"ContinuedLine":false}]}}