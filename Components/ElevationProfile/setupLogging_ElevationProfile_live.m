%[text] # Logging set up for Elevation Profile harness model
%[text] Set up signal logging for Simscape blocks. For details, see the documentation.
%[text] - [Log Selected Variables Programmatically](https://www.mathworks.com/help/simscape/ug/manage-selective-logging-instrumentation-programmatically.html) \
model_name = "HarnessModel_ElevationProfile";
load_system(model_name)
%%
block_path = model_name + "/Controller/Diff";
logging_settings = simscape.instrumentation.defaultVariableTable(block_path);

logging_settings("O").Logging = "on";
logging_settings("O").Name = "Controller inputs difference";
logging_settings("O").Unit = "m/s";

simscape.instrumentation.setVariableTable(block_path, logging_settings)

new_settings = simscape.instrumentation.getVariableTable(block_path);
disp(new_settings) %[output:783741c4]
%%
block_path = model_name + "/Battery";
logging_settings = simscape.instrumentation.defaultVariableTable(block_path);

logging_settings("charge").Logging = "on";
logging_settings("charge").Name = "Battery charge";
logging_settings("charge").Unit = "A*hr";

logging_settings("i").Logging = "on";
logging_settings("i").Name = "Battery current";
logging_settings("i").Unit = "A";

logging_settings("v").Logging = "on";
logging_settings("v").Name = "Battery voltage";
logging_settings("v").Unit = "V";

simscape.instrumentation.setVariableTable(block_path, logging_settings)

new_settings = simscape.instrumentation.getVariableTable(block_path);
disp(new_settings) %[output:4555a163]
%%
block_path = model_name + "/Motor";
logging_settings = simscape.instrumentation.defaultVariableTable(block_path);

logging_settings("t").Logging = "on";
logging_settings("t").Name = "Motor torque";
logging_settings("t").Unit = "N*m";

logging_settings("w").Logging = "on";
logging_settings("w").Name = "Motor angular speed";
logging_settings("w").Unit = "rpm";

logging_settings("i").Logging = "on";
logging_settings("i").Name = "Motor current";
logging_settings("i").Unit = "A";

logging_settings("v").Logging = "on";
logging_settings("v").Name = "Motor voltage";
logging_settings("v").Unit = "V";

simscape.instrumentation.setVariableTable(block_path, logging_settings)

new_settings = simscape.instrumentation.getVariableTable(block_path);
disp(new_settings) %[output:9a9e1f22]
%%
block_path = model_name + "/Vehicle";
logging_settings = simscape.instrumentation.defaultVariableTable(block_path);

logging_settings("F_total").Logging = "on";
logging_settings("F_total").Name = "Vehicle force";
logging_settings("F_total").Unit = "kN";

simscape.instrumentation.setVariableTable(block_path, logging_settings)

new_settings = simscape.instrumentation.getVariableTable(block_path);
disp(new_settings) %[output:24697039]
%%
save_system(model_name)
%[text] *Copyright 2026 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:783741c4]
%   data: {"dataType":"text","outputData":{"text":"  <a href=\"matlab:helpPopup('simscape.instrumentation.VariableTable')\" style=\"font-weight:bold\">VariableTable<\/a> (<a href=\"matlab:helpPopup('string')\" style=\"font-weight:bold\">string<\/a> ⟼ <a href=\"matlab:helpPopup('simscape.instrumentation.VariableConfiguration')\" style=\"font-weight:bold\">VariableConfiguration<\/a>) with 3 variable(s):\n\n                         <strong>Name<\/strong>                  <strong>Unit<\/strong>      <strong>Logging<\/strong>\n            <strong>______________________________<\/strong>    <strong>_______<\/strong>    <strong>_______<\/strong>\n\n    <strong>I1 ⟼<\/strong>    <missing>                         {[\"\" ]}     false \n    <strong>I2 ⟼<\/strong>    <missing>                         {[\"\" ]}     false \n    <strong>O  ⟼<\/strong>    \"Controller inputs difference\"    {[m\/s]}     true  \n\n","truncated":false}}
%---
%[output:4555a163]
%   data: {"dataType":"text","outputData":{"text":"  <a href=\"matlab:helpPopup('simscape.instrumentation.VariableTable')\" style=\"font-weight:bold\">VariableTable<\/a> (<a href=\"matlab:helpPopup('string')\" style=\"font-weight:bold\">string<\/a> ⟼ <a href=\"matlab:helpPopup('simscape.instrumentation.VariableConfiguration')\" style=\"font-weight:bold\">VariableConfiguration<\/a>) with 7 variable(s):\n\n                           <strong>Name<\/strong>           <strong>Unit<\/strong>    <strong>Logging<\/strong>\n                     <strong>_________________<\/strong>    <strong>____<\/strong>    <strong>_______<\/strong>\n\n    <strong>H.T         ⟼<\/strong>    <missing>            K        false \n    <strong>charge      ⟼<\/strong>    \"Battery charge\"     A*hr     true  \n    <strong>i           ⟼<\/strong>    \"Battery current\"    A        true  \n    <strong>n.v         ⟼<\/strong>    <missing>            V        false \n    <strong>p.v         ⟼<\/strong>    <missing>            V        false \n    <strong>temperature ⟼<\/strong>    <missing>            K        false \n    <strong>v           ⟼<\/strong>    \"Battery voltage\"    V        true  \n\n","truncated":false}}
%---
%[output:9a9e1f22]
%   data: {"dataType":"text","outputData":{"text":"  <a href=\"matlab:helpPopup('simscape.instrumentation.VariableTable')\" style=\"font-weight:bold\">VariableTable<\/a> (<a href=\"matlab:helpPopup('string')\" style=\"font-weight:bold\">string<\/a> ⟼ <a href=\"matlab:helpPopup('simscape.instrumentation.VariableConfiguration')\" style=\"font-weight:bold\">VariableConfiguration<\/a>) with 16 variable(s):\n\n                                  <strong>Name<\/strong>              <strong>Unit<\/strong>      <strong>Logging<\/strong>\n                          <strong>_____________________<\/strong>    <strong>_______<\/strong>    <strong>_______<\/strong>\n\n    <strong>C.w              ⟼<\/strong>    <missing>                rad\/s       false \n    <strong>H.T              ⟼<\/strong>    <missing>                K           false \n    <strong>Omega            ⟼<\/strong>    <missing>                rad\/s       false \n    <strong>R.w              ⟼<\/strong>    <missing>                rad\/s       false \n    <strong>Tr               ⟼<\/strong>    <missing>                N*m         false \n    <strong>Vm.v             ⟼<\/strong>    <missing>                V           false \n    <strong>Vp.v             ⟼<\/strong>    <missing>                V           false \n    <strong>i                ⟼<\/strong>    \"Motor current\"          A           true  \n    <strong>power_dissipated ⟼<\/strong>    <missing>                N*m*rpm     false \n    <strong>t                ⟼<\/strong>    \"Motor torque\"           N*m         true  \n    <strong>temperature      ⟼<\/strong>    <missing>                K           false \n    <strong>torqueLimit      ⟼<\/strong>    <missing>                J           false \n    <strong>torque_elec      ⟼<\/strong>    <missing>                N*m         false \n    <strong>torque_ref       ⟼<\/strong>    <missing>                N*m         false \n    <strong>v                ⟼<\/strong>    \"Motor voltage\"          V           true  \n    <strong>w                ⟼<\/strong>    \"Motor angular speed\"    rpm         true  \n\n","truncated":false}}
%---
%[output:24697039]
%   data: {"dataType":"text","outputData":{"text":"  <a href=\"matlab:helpPopup('simscape.instrumentation.VariableTable')\" style=\"font-weight:bold\">VariableTable<\/a> (<a href=\"matlab:helpPopup('string')\" style=\"font-weight:bold\">string<\/a> ⟼ <a href=\"matlab:helpPopup('simscape.instrumentation.VariableConfiguration')\" style=\"font-weight:bold\">VariableConfiguration<\/a>) with 18 variable(s):\n\n                         <strong>Name<\/strong>            <strong>Unit<\/strong>      <strong>Logging<\/strong>\n                    <strong>_______________<\/strong>    <strong>________<\/strong>    <strong>_______<\/strong>\n\n    <strong>Axle.w     ⟼<\/strong>    <missing>          rad\/s        false \n    <strong>F_air      ⟼<\/strong>    <missing>          kg*m\/s^2     false \n    <strong>F_brake    ⟼<\/strong>    <missing>          N            false \n    <strong>F_drive    ⟼<\/strong>    <missing>          N            false \n    <strong>F_resist   ⟼<\/strong>    <missing>          N            false \n    <strong>F_tire     ⟼<\/strong>    <missing>          N            false \n    <strong>F_total    ⟼<\/strong>    \"Vehicle force\"    kN           true  \n    <strong>G_out      ⟼<\/strong>    <missing>          1            false \n    <strong>V_wind     ⟼<\/strong>    <missing>          m\/s          false \n    <strong>V_x        ⟼<\/strong>    <missing>          m\/s          false \n    <strong>accl       ⟼<\/strong>    <missing>          N\/kg         false \n    <strong>angle_in   ⟼<\/strong>    <missing>          rad          false \n    <strong>brkF       ⟼<\/strong>    <missing>          N            false \n    <strong>grade_norm ⟼<\/strong>    <missing>          1            false \n    <strong>grade_pct  ⟼<\/strong>    <missing>          1            false \n    <strong>trq        ⟼<\/strong>    <missing>          N*m          false \n    <strong>v_out      ⟼<\/strong>    <missing>          m\/s          false \n    <strong>w          ⟼<\/strong>    <missing>          rad\/s        false \n\n","truncated":false}}
%---
