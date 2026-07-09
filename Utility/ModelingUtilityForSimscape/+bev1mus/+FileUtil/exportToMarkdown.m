function exportToMarkdown(LiveScriptFilename, NameValuePair)
% Export a Live Script to a Markdown file.
%
% This is a wrapper function of MALTAB's export command to generate
% a Markdown file from a Live Script.

% Copyright 2024-2025 The mathWorks, Inc.

% In R2024b, this command works with the "*.mlx" binary Live Script.
% In R2025a or newer, this command also works with the "*.m" plain-text Live Script.
%
% If you convert the "mycode1.m" (or .mlx) Live Script with the export command,
% it creates the "mycode1.md" Markdown file. If the Live Script includes
% plots or animations, and if you select to create separate media files,
% export also creates the "mycode1_media" folder in the current folder.
% The "mycode1_media" folder is used to store image files or movie files
% generated from the Live Script and used by the Markdown file.
%
%   pwd >
%       mycode1_media > figure_0.png, figure_1.png, ...
%       mycode1.md
%       mycode1.m
%
% If you convert "mycode2.m" and "mycode3.m" files to Markdown files,
% you have "mycode2_media" and "mycode3_media" folders in the current folder too.
%
%   pwd >
%       mycode1_media > figure_0.png, figure_1.png, ...
%       mycode2_media > figure_0.png, figure_1.png, ...
%       mycode3_media > figure_0.png, figure_1.png, ...
%       mycode1.md
%       mycode1.m
%       mycode2.md
%       mycode2.m
%       mycode3.md
%       mycode3.m
%
% With this wrapper function, by default, Markdown file is saved in
% "markdown" folder in the current folder, and the "media" folder is
% moved below the "markdown > media" folder.
%
%   pwd >
%       markdown >
%           media >
%               mycode1_media > figure_0.png, figure_1.png, ...
%               mycode2_media > figure_0.png, figure_1.png, ...
%               mycode3_media > figure_0.png, figure_1.png, ...
%           mycode1.md
%           mycode2.md
%           mycode3.md
%       mycode1.m
%       mycode2.m
%       mycode3.m

arguments (Input)
  % A Live Script file to convert to a Markdown file.
  % This filename can include either a relative path or a full path.
  LiveScriptFilename (1,1) string {bev1mus.FileUtil.mustBeLiveScript}

  % A path to the folder to store Markdown files.
  % This path can be either relative or full.
  % If the folder does not exist, it is created.
  NameValuePair.MarkdownFolderPath (1,1) string = "markdown"

  % This path is relative to MarkdownFolderPath.
  % If the folder does not exist, it is created.
  NameValuePair.MediaFolderName (1,1) string = "media"

  NameValuePair.HideCode (1,1) logical = false

  NameValuePair.DisplayInfo (1,1) logical = true
end  % arguments

assert(NameValuePair.MarkdownFolderPath ~= ".", "MarkdownFolderPath must not be the current folder.")

assert(NameValuePair.MediaFolderName ~= ".", "MediaFolderName must not be the current folder.")

[~, name_part, ~] = fileparts(LiveScriptFilename);

markdown_destination_folder_path = NameValuePair.MarkdownFolderPath;

if not(isfolder(markdown_destination_folder_path))
  if NameValuePair.DisplayInfo
    disp("Creating destination folder: " + markdown_destination_folder_path)
  end  % if
  mkdir(markdown_destination_folder_path)
end  % if

media_folder_basename = name_part + "_media";

% The *_media folder is created in the current working folder.
media_folder_original_fullpath = fullfile(pwd, media_folder_basename);

media_folder_new_path = fullfile( markdown_destination_folder_path, ...
  NameValuePair.MediaFolderName );

if not(isfolder(media_folder_new_path))
  if NameValuePair.DisplayInfo
    disp("Creating media folder: " + media_folder_new_path)
  end  % if
  mkdir(media_folder_new_path)
end  % if

% Media subfolder does not exist yet. It is created later.
media_subfolder_new_path = fullfile(media_folder_new_path, media_folder_basename);

markdown_file_name = name_part + ".md";

markdown_file_fullpath = fullfile(markdown_destination_folder_path, markdown_file_name);

if NameValuePair.DisplayInfo
  disp("Generating Markdown file from Live Script: " + LiveScriptFilename)
end  % if

export( LiveScriptFilename, ...
  Format = "markdown", ...
  AcceptHTML = true, ...  Must be true to show images
  RenderLaTexOnline = "off", ... Do not access external internet sites from markdown file
  HideCode = NameValuePair.HideCode, ... By default, do not hide MATLAB code.
  Run = true, ... Run script before export. Takes time, but necessary to always get expected result.
  IncludeOutputs = true, ... Include MATLAB output
  EmbedImages = false, ... Save images to individual image files
  FigureFormat = "png", ...
  FigureResolution = 120 );  % This affects the size of image file

%% Update path strings in markdown file to point to the new image file path

% Generated Markdown file is in the current working folder.
assert(isfile(markdown_file_name))
content = fileread(markdown_file_name);
content = string(content);

% File separator must be forward slash.
target_string = "<img src=""" + media_folder_basename + "/";

if contains(content, target_string) && (NameValuePair.MediaFolderName ~= ".")
  if NameValuePair.DisplayInfo
    disp("Updating the path strings in the Markdown file for images.")
  end  % if

  % This path string is used within the generated Markdown
  % where 1) the path must be relative from the Markdown file's folder,
  % and 2) the folder separator must be backslash.
  new_path = NameValuePair.MediaFolderName + "/" + media_folder_basename;

  new_string = "<img src=""" + new_path + "/";

  new_content = replace(content, target_string, new_string);

  % Move media folder and files generated from Live Script
  if NameValuePair.DisplayInfo
    disp("Moving the media folder: " + media_subfolder_new_path)
  end  % if
  copyfile(media_folder_original_fullpath + "/*", media_subfolder_new_path)
  rmdir(media_folder_original_fullpath, "s")

else
  if NameValuePair.DisplayInfo
    disp("There is no medium.")
  end  % if
  new_content = content;
end  % if

%% Move Markdown file to user-specified folder

new_tmp_mdfile = tempname(pwd) + ".md";

fd = fopen(new_tmp_mdfile, "w");
fprintf(fd, "%s", new_content);
fclose(fd);

if NameValuePair.DisplayInfo
  disp("Moving Markdown file: " + markdown_file_fullpath)
end  % if

copyfile(new_tmp_mdfile, markdown_file_fullpath)
delete(new_tmp_mdfile)

if markdown_destination_folder_path ~= string(pwd)
  delete(markdown_file_name)
end

if NameValuePair.DisplayInfo
  disp("done")
end  % if

end  % function
