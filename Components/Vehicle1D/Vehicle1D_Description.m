%[text] # Abstract model of longitudinal vehicle dynamics
%[text] Longitudinal vehicle driving/resisting force $F$ as a function of longitudinal vehicle speed $V$ is modeled as follows.
%[text] $F(V) = (A\_{rl} + B\_{rl} V) \\cos(\\theta) + C\_{rl} {V}^2 + g M\_v \\sin(\\theta)$
%[text] where
%[text] - $A\_{rl}$, $B\_{rl}$, $C\_{rl}$ are road-load coefficients.
%[text] - $M\_v$ is vehicle mass.
%[text] - $g$ is the gravitational acceleration.
%[text] - $\\theta$ is road inclination angle. \
%[text] On the flat ground $\\theta \\;${"editStyle":"visual"}= 0, the vehicle force becomes $F\\left(V\\right)=A\_{\\textrm{rl}} +B\_{\\textrm{rl}} V+C\_{\\textrm{rl}} V^2${"editStyle":"visual"}.
%[text] Road-load coefficient $A\_{\\textrm{rl}}${"editStyle":"visual"} is computed from vehicle parameters ($C\_{\\textrm{roll}}${"editStyle":"visual"} is tire rolling coefficient) as follows.
%[text] $A\_{\\textrm{rl}} =C\_{\\textrm{roll}} \\;M\_v \\;g${"editStyle":"visual"}
%[text] Road-load coefficient $C\_{\\textrm{rl}}${"editStyle":"visual"} is computed from vehicle parameters ($C\_d${"editStyle":"visual"} is air drag coefficient, $A\_f${"editStyle":"visual"} is frontal area, $\\rho \\;${"editStyle":"visual"} is air density) as follows.
%[text] $C\_{\\textrm{rl}} =\\frac{1}{2}\\;C\_d \\;A\_f \\;\\rho \\;${"editStyle":"visual"}
%[text] Note that road-load coefficient $B\_{\\textrm{rl}}${"editStyle":"visual"} is not related to any vehicle parameters in this model.
%[text] The above model is following Longitudinal Vehicle block in Simscape Driveline. For information about the block and detailed description about the model, see the [documentation](https://www.mathworks.com/help/sdl/ref/longitudinalvehicle.html).
%[text] *Copyright 2024-2026 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
