%[text] # setSystemMaskIcon
%[text] Set and save an icon in a system mask. The text set to IconText appears at the center of the block. Top left and bottom right corners of the block is decorated to indicate that the block is Referenced Subsystem.
%[text] This function returns the model name if it is used on the right hand side of an assignment. This function does not return anything otherwise.
%[text] To edit a system mask icon, use the System Mask Editor. (From Simulink Toolstrip \> Subsystem \> Edit System Mask.)
%[text] If the ModelName is not specified, this function creates and saves a referenced subsystem model with a default name.
function ReturnModelName = setSystemMaskIcon(ModelName, IconText)

arguments (Input)
  ModelName (1,1) string = ""
  IconText (1,1) string = "IconText"
end  % arguments

arguments (Output)
  ReturnModelName (1,:) string
end  % arguments

if ModelName == ""
  filename = FileTool2.getUnusedFilename("default_refsub.mdl");
  [~, ModelName, ~] = fileparts(filename);

  % Create a referenced subsystem file.
  new_system(ModelName, "Subsystem")
  save_system(ModelName)

  % Mask has to be added before editting it.
  Simulink.Mask.create(ModelName);
end  % if

load_system(ModelName)

% If the system has no mask yet, this fails.
mask = Simulink.Mask.get(ModelName);

icon_code_string = join([
  "pos = get_param(gcb, ""Position"");"
  "blockWidth = pos(3) - pos(1);"
  "blockHeight = pos(4) - pos(2);"
  ""
  "text(blockWidth*0.5, blockHeight*0.5, ..."
  "  """ + IconText + """, ..."
  "  HorizontalAlignment = 'center');"
  "%% Corner decorations for subsystem reference"
  ""
  "% size of corner triangle"
  "L = 10;"
  ""
  "% lower right corner"
  "plot([blockWidth - L, blockWidth], [0, L])"
  ""
  "% top left corner"
  "plot([0, L], [blockHeight - L, blockHeight])"
  ], newline);

mask.Display = icon_code_string;

save_system(ModelName)

if nargout > 0
  ReturnModelName = ModelName;
end  % if
end  % function
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
