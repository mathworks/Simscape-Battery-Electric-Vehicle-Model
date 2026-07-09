function converted = generateMarkdownsFromLiveScripts(LiveScriptFilenames, NameValuePair)
% Generate Markdown files from Live Scripts
%
% This function can take multiple Live Scripts.
%
% Use DisplayInfo option to see or hide conversion information.
%
% If Markdown file already exists and its time stamp is newer than
% the source Live Script, this function skips generating a new Markdown.
% To force generate a new Markdown, specify ForceExport=true.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  % One or more Live Script files to convert to Markdown files.
  % Filenames can include either a relative or full path.
  LiveScriptFilenames (:,1) string {bev1mus.FileUtil.mustBeLiveScript}

  % A path to the folder to store Markdown files.
  % This path can be either relative or full.
  % If the folder does not exist, it is created.
  NameValuePair.MarkdownFolderPath (1,1) string = "markdown"

  % This path is relative to MarkdownFolderPath.
  % If the folder does not exist, it is created.
  NameValuePair.MediaFolderName (1,1) string = "media"

  NameValuePair.DisplayInfo (1,1) logical = true

  NameValuePair.ForceExport (1,1) logical = false
end  % arguments

arguments (Output)
  % An array of true or false values, representing generated (true) or skipped (false)
  % for the specified Live Scripts.
  converted (1,:) logical
end  % arguments

assert(NameValuePair.MarkdownFolderPath ~= ".", "MarkdownFolderPath must not be the current folder.")

assert(NameValuePair.MediaFolderName ~= ".", "MediaFolderName must not be the current folder.")

source_files = LiveScriptFilenames;

[~, name_part, ~] = fileparts(LiveScriptFilenames);
markdown_file_name = name_part + ".md";
markdown_file_path = fullfile(NameValuePair.MarkdownFolderPath, markdown_file_name);

dest_files = markdown_file_path;

numSourceFiles = numel(source_files);
converted = false(1, numSourceFiles);

for idx = 1 : numSourceFiles
  src = source_files(idx);
  dst = dest_files(idx);

  if NameValuePair.DisplayInfo
    disp("Source: " + src)
    disp("Destination: " + dst)
  end

  do_generate = bev1mus.FileUtil.sourceFileIsNewer( ...
    Source = src, ...
    Destination = dst, ...
    DisplayInfo = NameValuePair.DisplayInfo );

  if NameValuePair.ForceExport || do_generate
    if NameValuePair.DisplayInfo
      disp("--> Exporting markdown from " + source_files(idx))
    end  % if

    mlxfile = source_files(idx);

    bev1mus.FileUtil.exportToMarkdown( ...
      mlxfile, ...
      MarkdownFolderPath = NameValuePair.MarkdownFolderPath, ...
      MediaFolderName = NameValuePair.MediaFolderName, ...
      DisplayInfo = NameValuePair.DisplayInfo )

    converted(idx) = true;
  else
    if NameValuePair.DisplayInfo
      disp("--> Skip. Markdown file is up to date for " + source_files(idx))
    end  % if
  end  % if
end  % for
end  % function
