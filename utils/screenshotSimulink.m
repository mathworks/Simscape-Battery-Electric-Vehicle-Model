function result = screenshotSimulink(nvpairs)
%% Saves the screenshot of a Simulink model to an image file.
%
% The simplest way to use this function is to pass the Simulink model name.
%   result = screenshotSimulink(SimulinkModelName="ssc_dcmotor");
% Returned data is a struct containing the file name
% of a produced screenshot image as well as the width and height of it.
%
% You can use options to control the size of the image file,
% subsystem to take a screenshot, and so on.
% For details, see the arguments block.

% Copyright 2021-2022 The MathWorks, Inc.

arguments

  % The name of the model you want to take a screenshot.
  % By default, the screenshot is taken for the top layer.
  % To take the screenshot of a subsystem, use SubsystemPath option.
  nvpairs.SimulinkModelName {mustBeTextScalar}

  % Path to the subsystem to take screenshot,
  % for example, SubsystemPath="/Subsystem1".
  % Default is an empty string "", and the top layer is the target.
  nvpairs.SubsystemPath {mustBeTextScalar} = ""

  % Screenshot file is saved as a PNG file.
  % Default file name of the screenshot is "image_<SimulinkModelName>.png".
  % To specify the image file name, use OutputFileName option.
  % The file name is passed to imwrite function.
  nvpairs.OutputFileName {mustBeTextScalar}

  % Folder path to save image file.
  % If this is empty, image file is saved in the current folder.
  nvpairs.SaveFolder {mustBeTextScalar} = ""

  % Width and height of the image file to produce.
  nvpairs.OutputImageWidth_px (1,1) {mustBeInteger, mustBeNonnegative} = 0
  nvpairs.OutputImageHeight_px (1,1) {mustBeInteger, mustBeNonnegative} = 0

  % You can add a padding around the model image.
  % The screenshot size is adjusted and centered.
  nvpairs.PaddingHorizontal_px (1,1) {mustBeInteger, mustBeNonnegative} = 0
  nvpairs.PaddingVertical_px (1,1) {mustBeInteger, mustBeNonnegative} = 0
  % [0 0 0] is black. [1 1 1] is white.
  nvpairs.PaddingColorRGB (1,3) {mustBeInRange(nvpairs.PaddingColorRGB, 0, 1)} = [1,1,1]

  % Options below are for test purposes.

  % To test this function without using a Simulink model to take screenshot,
  % set StandaloneTest to true.
  % If this is true, SimulinkModelName is ignored.
  nvpairs.StandaloneTest (1,1) logical = false

  % This is for test purpose.
  nvpairs.DoNotSaveImageFile (1,1) logical = false

end

standaloneTest = nvpairs.StandaloneTest;

if isfield(nvpairs, 'SimulinkModelName')
  modelName = nvpairs.SimulinkModelName;
else
  modelName = "";
end
result.SimulinkModelName = modelName;

if isfield(nvpairs, 'OutputFileName')
  outputFileName = nvpairs.OutputFileName;
else
  if modelName == ""
    outputFileName = "Unspecified.png";
  else
    outputFileName = "image_" + modelName + ".png";
  end
end
result.OutputFileName = outputFileName;

outputFullPath = fullfile(nvpairs.SaveFolder, outputFileName);
result.OutputFullPath = outputFullPath;

subsystemPath = nvpairs.SubsystemPath;
if subsystemPath ~= ""
  if not(startsWith(subsystemPath, "/"))
    subsystemPath = "/" + subsystemPath;
  end
end

% The values of these variables can be 0 at this point.
% They are fully determined later.
rows_final = nvpairs.OutputImageHeight_px;
cols_final = nvpairs.OutputImageWidth_px;

padX = nvpairs.PaddingHorizontal_px;
padY = nvpairs.PaddingVertical_px;
padRGB = 256 * nvpairs.PaddingColorRGB;

if standaloneTest
  rows = 600;
  cols = 800;
  screenshotImage = uint8( 255*ones(rows, cols, 3) );  % 0 - 255
  screenshotImage(:,:,1) = screenshotImage(:,:,1)*0.1;  % Red
  screenshotImage(:,:,2) = screenshotImage(:,:,2)*0.4;  % Green
  screenshotImage(:,:,3) = screenshotImage(:,:,3)*0.1;  % Blue
else
  if not(bdIsLoaded(modelName))
    load_system(modelName)
  end
  subsystemFullPath = modelName + subsystemPath;
  listOfBlocks = getfullname(Simulink.findBlocks(modelName));
  tf = contains(listOfBlocks, subsystemFullPath);
  if not(any(tf))
    error("Specified subsystem does not exist: " + subsystemFullPath)
  end
  % Take screenshot. It is saved in a file.
  print("-s" + subsystemFullPath, ...
        "-dpng", outputFullPath)
  screenshotImage = imread(outputFullPath);
end

rows_orig = height(screenshotImage);
cols_orig = width(screenshotImage);
result.OriginalImageWidth = cols_orig;
result.OriginalImageHeight = rows_orig;

if rows_final == 0 && cols_final > 0
  rows_final = ceil(rows_orig * cols_final/cols_orig);
elseif rows_final > 0 && cols_final == 0
  cols_final = ceil(cols_orig * rows_final/rows_orig);
elseif rows_final > 0 && cols_final > 0
  % do nothing.
else
  rows_final = rows_orig;
  cols_final = cols_orig;
end
result.FinalImageWidth = cols_final;
result.FinalImageHeight = rows_final;

% Compute target size to resize the original image.
rows_target = rows_final - padY*2;
cols_target = cols_final - padX*2;

assert(rows_target > 0, "Invalid image height %d", rows_target)
assert(cols_target > 0, "Invalid image width %d", cols_target)

result.ResizedImageWidth = cols_target;
result.ResizedImageHeight = rows_target;

if padX==0 && padY==0 && rows_final==rows_orig && cols_final==cols_orig
  resultImg = screenshotImage;
else
  resizedImage = imresize(screenshotImage, [rows_target, cols_target]);

  % uint8 is necessary to manipulate data as PNG.
  resultImg = uint8( ones(rows_final, cols_final, 3) );
  resultImg(:,:,1) = padRGB(1)*resultImg(:,:,1);
  resultImg(:,:,2) = padRGB(2)*resultImg(:,:,2);
  resultImg(:,:,3) = padRGB(3)*resultImg(:,:,3);

  % Superimpose the screenshot on top of the rectangle.
  % Screenshot is placed at the center.
  resultImg( padY+(1:height(resizedImage)) , padX+(1:width(resizedImage)) , : ) = resizedImage;
end

if nvpairs.DoNotSaveImageFile
  disp("Not saving screenshot image to a file.")
  % print() created a file unless Standalone option is used.
  if isfile(outputFullPath)
    delete(outputFullPath)
  end
else
  imwrite(resultImg, outputFullPath)
end

end  % function
