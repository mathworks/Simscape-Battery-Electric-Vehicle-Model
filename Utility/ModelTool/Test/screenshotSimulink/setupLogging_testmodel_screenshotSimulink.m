%[text] # Setup Simscape data logging
%[text] Set up signal logging for Simscape blocks. For details, see the documentation.
%[text] - [Log Selected Variables Programmatically](https://www.mathworks.com/help/simscape/ug/manage-selective-logging-instrumentation-programmatically.html) \
model_name = "testmodel_screenshotSimulink";
load_system(model_name)
block_path = model_name + "/Subsystem1/Rotational Spring";

logging_settings = simscape.instrumentation.defaultVariableTable(block_path);

logging_settings("phi").Logging = "on";
logging_settings("phi").Name = "Spring angle";
logging_settings("phi").Unit = "deg";

logging_settings("w").Logging = "on";
logging_settings("w").Name = "Spring angular speed";
logging_settings("w").Unit = "rpm";

simscape.instrumentation.setVariableTable(block_path, logging_settings)

new_settings = simscape.instrumentation.getVariableTable(block_path);
disp(new_settings) %[output:6b80c497]
%[text] 
%{
save_system(model_name)
bdclose(model_name)
%}
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:6b80c497]
%   data: {"dataType":"text","outputData":{"text":"  <a href=\"matlab:helpPopup('simscape.instrumentation.VariableTable')\" style=\"font-weight:bold\">VariableTable<\/a> (<a href=\"matlab:helpPopup('string')\" style=\"font-weight:bold\">string<\/a> ⟼ <a href=\"matlab:helpPopup('simscape.instrumentation.VariableConfiguration')\" style=\"font-weight:bold\">VariableConfiguration<\/a>) with 5 variable(s):\n\n                      <strong>Name<\/strong>             <strong>Unit<\/strong>     <strong>Logging<\/strong>\n             <strong>______________________<\/strong>    <strong>_____<\/strong>    <strong>_______<\/strong>\n\n    <strong>C.w ⟼<\/strong>    <missing>                 rad\/s     false \n    <strong>R.w ⟼<\/strong>    <missing>                 rad\/s     false \n    <strong>phi ⟼<\/strong>    \"Spring angle\"            deg       true  \n    <strong>t   ⟼<\/strong>    <missing>                 N*m       false \n    <strong>w   ⟼<\/strong>    \"Spring angular speed\"    rpm       true  \n\n","truncated":false}}
%---
