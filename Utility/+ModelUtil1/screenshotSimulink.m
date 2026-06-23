function Result = screenshotSimulink(NameValuePair)
%% Save the screenshot of a Simulink model to a PNG file.
%
% The simplest way to use this function is to pass the Simulink model name.
% This saves a screenshot image in PNG format in the current folder.
%   result = screenshotSimulink(SimulinkModelName="my_model");
% Returned data is a struct containing the file name
% of a produced screenshot image as well as the width and height of it.
%
% You can use options to control the size of the image file,
% subsystem to take a screenshot, and so on.
% For details, see the arguments block below.

% Copyright 2021-2026 The MathWorks, Inc.

arguments (Input)

  % The name of the model you want to take a screenshot.
  % By default, the screenshot is taken for the top layer.
  % To take the screenshot of a subsystem, use the SubsystemPath option.
  NameValuePair.SimulinkModelName {mustBeTextScalar}

  % Path to the subsystem to take screenshot,
  % for example, SubsystemPath="/Subsystem1".
  % Default is an empty string "", and the top layer is the target.
  NameValuePair.SubsystemPath {mustBeTextScalar} = ""

  % Screenshot file is saved as a PNG file.
  % Default file name of the screenshot is "screenshot-<SimulinkModelName>.png".
  % To specify the image file name, use OutputFileName option.
  % The file name is passed to imwrite function.
  NameValuePair.OutputFileName {mustBeTextScalar}

  % Folder path to save image file.
  % If this is empty, image file is saved in the current working folder.
  NameValuePair.SaveFolder {mustBeTextScalar} = ""

  % ---------------------------------------------------------------------------
  % Additional options - safe to ignore

  % Width and height of the image file to produce.
  NameValuePair.OutputImageWidth_px (1,1) {mustBeInteger, mustBeNonnegative} = 0
  NameValuePair.OutputImageHeight_px (1,1) {mustBeInteger, mustBeNonnegative} = 0

  % Add paddings around the model image.
  % The screenshot size is maintained while the model image size is reduced and centered.
  % To keep the aspect ratio of the model image, set the same value for both paddings.
  % !todo: Add an option to add paddings while keeping the original size of the model image.
  NameValuePair.PaddingHorizontal_px (1,1) {mustBeInteger, mustBeNonnegative} = 0
  NameValuePair.PaddingVertical_px (1,1) {mustBeInteger, mustBeNonnegative} = 0

  % [0 0 0] is black. [1 1 1] is white.
  NameValuePair.PaddingColorRGB (1,3) {mustBeInRange(NameValuePair.PaddingColorRGB, 0, 1)} = [1,1,1]  %#ok<MUSTINRANGE>

  % Options below are for test purposes.

  % To test this function without using a Simulink model to take screenshot,
  % set StandaloneTest to true.
  % If this is true, SimulinkModelName is ignored.
  NameValuePair.StandaloneTest (1,1) logical = false

  % This is for test purpose.
  NameValuePair.DoNotSaveImageFile (1,1) logical = false

end  % arguments

arguments (Output)
  Result (1,1) struct
end  % arguments

standalone_test = NameValuePair.StandaloneTest;

if isfield(NameValuePair, "SimulinkModelName")
  model_name = NameValuePair.SimulinkModelName;
else
  model_name = "";
end
Result.SimulinkModelName = model_name;

if isfield(NameValuePair, "OutputFileName")
  output_filename = NameValuePair.OutputFileName;
else
  if model_name == ""
    output_filename = "screenshot-untitled.png";
  else
    output_filename = "screenshot-" + model_name + ".png";
  end
end
Result.OutputFileName = output_filename;

output_fullpath = fullfile(NameValuePair.SaveFolder, output_filename);
Result.OutputFullPath = output_fullpath;

subsystem_path = NameValuePair.SubsystemPath;
if subsystem_path ~= ""
  if not(startsWith(subsystem_path, "/"))
    subsystem_path = "/" + subsystem_path;
  end
end

% The values of these variables can be 0 at this point.
% They are fully determined later.
rows_final = NameValuePair.OutputImageHeight_px;
cols_final = NameValuePair.OutputImageWidth_px;

pad_vert = NameValuePair.PaddingVertical_px;
pad_horr = NameValuePair.PaddingHorizontal_px;
pad_RGB = 256 * NameValuePair.PaddingColorRGB;

if standalone_test
  rows = 600;
  cols = 800;
  screenshot_image = uint8( 255*ones(rows, cols, 3) );  % 0 - 255
  screenshot_image(:,:,1) = screenshot_image(:,:,1)*0.1;  % Red
  screenshot_image(:,:,2) = screenshot_image(:,:,2)*0.4;  % Green
  screenshot_image(:,:,3) = screenshot_image(:,:,3)*0.1;  % Blue
else
  if not(bdIsLoaded(model_name))
    load_system(model_name)
  end
  subsystem_fullpath = model_name + subsystem_path;
  list_of_blocks = getfullname(Simulink.findBlocks(model_name));
  found_blocks = contains(list_of_blocks, subsystem_fullpath);
  if not(any(found_blocks))
    error("Specified subsystem does not exist: " + subsystem_fullpath)
  end
  % Take screenshot. It is saved in a file.
  print("-s" + subsystem_fullpath, ...
        "-dpng", output_fullpath)
  screenshot_image = imread(output_fullpath);
end  % if

rows_orig = height(screenshot_image);
cols_orig = width(screenshot_image);
Result.OriginalImageWidth = cols_orig;
Result.OriginalImageHeight = rows_orig;

if rows_final == 0 && cols_final > 0
  rows_final = ceil(rows_orig * cols_final/cols_orig);
elseif rows_final > 0 && cols_final == 0
  cols_final = ceil(cols_orig * rows_final/rows_orig);
elseif rows_final > 0 && cols_final > 0
  % do nothing.
else
  rows_final = rows_orig;
  cols_final = cols_orig;
end  % if
Result.FinalImageWidth = cols_final;
Result.FinalImageHeight = rows_final;

% Compute target size to resize the original image.
rows_target = rows_final - pad_vert*2;
cols_target = cols_final - pad_horr*2;

assert(rows_target > 0, "Invalid image height %d", rows_target)
assert(cols_target > 0, "Invalid image width %d", cols_target)

Result.ResizedImageWidth = cols_target;
Result.ResizedImageHeight = rows_target;

if pad_horr==0 && pad_vert==0 && rows_final==rows_orig && cols_final==cols_orig
  result_image = screenshot_image;
else
  resized_image = imresize(screenshot_image, [rows_target, cols_target]);

  % uint8 is necessary to manipulate data as PNG.
  result_image = uint8( ones(rows_final, cols_final, 3) );
  result_image(:,:,1) = pad_RGB(1)*result_image(:,:,1);
  result_image(:,:,2) = pad_RGB(2)*result_image(:,:,2);
  result_image(:,:,3) = pad_RGB(3)*result_image(:,:,3);

  % Superimpose the screenshot on top of the rectangle.
  % Screenshot is placed at the center.
  result_image( pad_vert+(1:height(resized_image)) , pad_horr+(1:width(resized_image)) , : ) = resized_image;
end  % if

if NameValuePair.DoNotSaveImageFile
  disp("Not saving screenshot image to a file.")
  % print() created a file unless Standalone option is used.
  if isfile(output_fullpath)
    delete(output_fullpath)
  end  % if
else
  imwrite(result_image, output_fullpath)
end  % if
end  % function
