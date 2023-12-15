classdef LiveScript_Utility

  % Copyright 2023 The MathWorks, Inc.

  methods (Static)

    function RunLiveScript_and_GenerateMarkdown(LiveScriptFilenames, nvpairs)
      %% Export Live Script to Markdown file
      % Use browser to view exported Markdown file.
      arguments (Input)
        % Live scripts to export
        LiveScriptFilenames (:,1) string {mustBeFile}

        % Relative top the current working folder.
        nvpairs.ImageFileFolderName (1,1) string {mustBeFolder} = "Images"

        nvpairs.ForceExport (1,1) logical = false
      end

      assert(all(endsWith(LiveScriptFilenames, ".mlx")), "Filename must end with "".mlx""")
      sourcefiles = LiveScriptFilenames;
      destfiles = replace(LiveScriptFilenames, ".mlx", ".md");

      for idx = 1 : numel(sourcefiles)
        if nvpairs.ForceExport || ...
            LiveScript_Utility.SourceFile_isNewerThan_destinationFile(Source=sourcefiles(idx), Destination=destfiles(idx))
          disp("Exporting markdown from " + sourcefiles(idx))

          LiveScript_Utility.GenerateMarkdown( ...
            sourcefiles(idx), ...
            ImageFileFolderName = nvpairs.ImageFileFolderName)

        else
          disp("Skipped because markdown file is up to date for " + sourcefiles(idx))
        end  % if
      end  % for
    end  % function


    function source_is_newer = SourceFile_isNewerThan_destinationFile(nvpairs)
      arguments (Input)
        % Source file must exist.
        nvpairs.Source (1,1) {mustBeFile}

        % Destination file may not exist.
        nvpairs.Destination (1,1) string
      end
      arguments (Output)
        % True if you want to take action because...
        % - Source file is newer than destination file. You want to update destination file.
        % - Destination file does not exist. You want to create destination file.
        source_is_newer (1,1) logical
      end
      source_is_newer = false;
      sourcefile_info = dir(nvpairs.Source);
      % As of R2022b, serial date numbers are not recommended.
      % Convert the serial date number to a datetime value by using the datetime function.
      sourcefile_datetime = datetime(sourcefile_info.datenum, ConvertFrom="datenum");
      if isfile(nvpairs.Destination)
        destfile_info = dir(nvpairs.Destination);
        destfile_datetime = datetime(destfile_info.datenum, ConvertFrom="datenum");
        if sourcefile_datetime > destfile_datetime
          source_is_newer = true;
        end  % if
      else
        % Destination file does not exist.
        source_is_newer = true;
      end  % if
    end  % function


    function GenerateMarkdown(LiveScriptFileName, nvpairs)
      %% Generates a Markdown file from a Live Script.

      % This function uses MATLAB's `export` command to generate a Markdown file
      % from a Live Script. `export` was first released in R2022a.
      %
      % This function applies a few changes to the `export`s behavior as follows.
      %
      % 1. Image folder
      %
      % `export` generates a folder to store image files created from
      % a Live Script for use in a Markdown file, but
      % separate folders are created for separate Live Scripts.
      % This can result in many folders in the working folder
      % if many Live Scripts are exported to Markdown.
      %
      % This function moves the image folder under a folder called "Images"
      % and updates the path strings in the Markdown file.
      % With this function, you can collect image folders for multiple Markdown files
      % under the same folder to keep the working folder clean.
      % Optionally, you can specify the image folder name.
      %
      % 2. Title line
      %
      % `export` generates a Markdown file which has an empty line at line 1 and
      % a span tag in line 2.
      % This function removes the top empty line and the span tag.
      % The resulting style is more typical as a title line for Markdown files.

      arguments
        LiveScriptFileName (1,1) string {mustBeFile} = "MyLiveScript.mlx"

        % Relative top the current working folder.
        nvpairs.ImageFileFolderName (1,1) string {mustBeFolder} = "Images"
      end

      assert(endsWith(LiveScriptFileName, ".mlx"))

      %{=
      export( LiveScriptFileName, ...
        Format = "markdown", ...
        AcceptHTML = true, ...  Must be true to show images
        RenderLaTexOnline = "off", ... Do not access external internet sites from markdown file
        HideCode = false, ...
        Run = true, ... Run script before export. Takes time, but necessary to always get expected result.
        IncludeOutputs = true, ... Include MATLAB output
        FigureFormat = "png", ...
        EmbedImages = false, ... Save images to individual image files
        FigureResolution = 120 ); ... This affects the size of image file
        %}

      %% Move image files generated from live script for use in markdown file

      [~, name_part, ~] = fileparts(LiveScriptFileName);

      image_folder_basename = name_part + "_media";

      image_folder_original_path = image_folder_basename;

      image_folder_new_path = nvpairs.ImageFileFolderName + "/" + image_folder_basename;

      %{=
      copyfile(image_folder_original_path + "/*", image_folder_new_path)

      rmdir(image_folder_original_path, "s")
      %}

      %% Update path strings in markdown file to point to the new image file path

      markdown_file_name = name_part + ".md";

      markdown_file_path = markdown_file_name;

      disp("Generating a Markdown file: " + markdown_file_path)

      content = fileread(markdown_file_path);

      content = string(content);

      % File separator must be forward slash.
      target_string = "<img src=""" + image_folder_basename + "/";

      if contains(content, target_string)
        disp("Updating the path string for images.")
      else
        warning("The ""img"" tag string did not match.")
      end

      new_string = "<img src=""" + image_folder_new_path + "/";

      new_content = replace(content, target_string, new_string);

      %% Clean up the title line

      % 1. Remove the empty line at line 1.
      % 2. Remove the "span" HTML tag from the title at line 2.
      new_content = replace(new_content, newline + "# <span style=""color:rgb(213,80,0)"">", "# ");
      new_content = replace(new_content, "</span>", "");

      %% Save the updated markdown file

      new_tmp_mdfile = tempname(pwd) + ".md";

      fd = fopen(new_tmp_mdfile, "w");
      fprintf(fd, "%s", new_content);
      fclose(fd);

      %{=
      copyfile(new_tmp_mdfile, markdown_file_name)
      delete(new_tmp_mdfile)
      %}

      disp("done")

    end  % function

  end  % methods
end  % classdef
