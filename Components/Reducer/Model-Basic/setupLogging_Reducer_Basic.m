%[text] # Logging set up for Reducer Basic model
%[text] Set up signal logging for Simscape blocks. For details, see the documentation.
%[text] - [Log Selected Variables Programmatically](https://www.mathworks.com/help/simscape/ug/manage-selective-logging-instrumentation-programmatically.html) \
model_name = "Reducer_Basic_refsub";
load_system(model_name)
block_path = model_name + "/Reduction gear";

logging_settings = simscape.instrumentation.defaultVariableTable(block_path);

logging_settings("B.w").Logging = "on";
logging_settings("B.w").Name = "Motor side angular speed";
logging_settings("B.w").Unit = "rpm";

logging_settings("tB").Logging = "on";
logging_settings("tB").Name = "Motor side torque";
logging_settings("tB").Unit = "N*m";

logging_settings("F.w").Logging = "on";
logging_settings("F.w").Name = "Axle side angular speed";
logging_settings("F.w").Unit = "rpm";

logging_settings("tF").Logging = "on";
logging_settings("tF").Name = "Axle side torque";
logging_settings("tF").Unit = "N*m";

simscape.instrumentation.setVariableTable(block_path, logging_settings)

new_settings = simscape.instrumentation.getVariableTable(block_path);
disp(new_settings) %[output:43939b40]
%[text] 
save_system(model_name)
%[text] *Copyright 2025-2026 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:43939b40]
%   data: {"dataType":"text","outputData":{"text":"  <a href=\"matlab:helpPopup('simscape.instrumentation.VariableTable')\" style=\"font-weight:bold\">VariableTable<\/a> (<a href=\"matlab:helpPopup('string')\" style=\"font-weight:bold\">string<\/a> ⟼ <a href=\"matlab:helpPopup('simscape.instrumentation.VariableConfiguration')\" style=\"font-weight:bold\">VariableConfiguration<\/a>) with 8 variable(s):\n\n                                <strong>Name<\/strong>               <strong>Unit<\/strong>    <strong>Logging<\/strong>\n                     <strong>__________________________<\/strong>    <strong>____<\/strong>    <strong>_______<\/strong>\n\n    <strong>B.w         ⟼<\/strong>    \"Motor side angular speed\"    rpm      true  \n    <strong>F.w         ⟼<\/strong>    \"Axle side angular speed\"     rpm      true  \n    <strong>H.T         ⟼<\/strong>    <missing>                     K        false \n    <strong>f_hardstop  ⟼<\/strong>    <missing>                     N        false \n    <strong>tB          ⟼<\/strong>    \"Motor side torque\"           N*m      true  \n    <strong>tF          ⟼<\/strong>    \"Axle side torque\"            N*m      true  \n    <strong>temperature ⟼<\/strong>    <missing>                     K        false \n    <strong>x_backlash  ⟼<\/strong>    <missing>                     mm       false \n\n","truncated":false}}
%---
