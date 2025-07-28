
# <span style="color:rgb(213,80,0)">Abstract model of longitudinal vehicle dynamics</span>

Longitudinal vehicle driving/resisting force $F$ as a function of longitudinal vehicle speed $V$ is modelled as follows.

 $$ F(V)=(A_{rl} +B_{rl} V)\cos (\theta )+C_{rl} V^2 +gM_v \sin (\theta ) $$ 

where

-  $A_{rl}$, $B_{rl}$, $C_{rl}$ are road\-load coefficients. 
-  $M_v$ is vehicle mass. 
-  $g$ is the gravitational acceleration. 
-  $\theta$ is road inclination angle. 

On the flat ground $\theta \;$ = 0, the vehicle force becomes $F\left(V\right)=A_{\textrm{rl}} +B_{\textrm{rl}} V+C_{\textrm{rl}} V^2$.


Road\-load coefficient $A_{\textrm{rl}}$ is computed from vehicle parameters ( $C_{\textrm{roll}}$ is tire rolling coefficient) as follows.

 $$ A_{\textrm{rl}} =C_{\textrm{roll}} \;M_v \;g $$ 

Road\-load coefficient $C_{\textrm{rl}}$ is computed from vehicle parameters ( $C_d$ is air drag coefficient, $A_f$ is frontal area, $\rho \;$ is air density) as follows.

 $$ C_{\textrm{rl}} =\frac{1}{2}\;C_d \;A_f \;\rho \; $$ 

Note that road\-load coefficient $B_{\textrm{rl}}$ is not related to any vehicle parameters in this model.


The above model is following Longitudinal Vehicle block in Simscape Driveline. For information about the block and detailed description about the model, see the [documentation](https://www.mathworks.com/help/sdl/ref/longitudinalvehicle.html).


*Copyright 2024\-2025 The MathWorks, Inc.*

