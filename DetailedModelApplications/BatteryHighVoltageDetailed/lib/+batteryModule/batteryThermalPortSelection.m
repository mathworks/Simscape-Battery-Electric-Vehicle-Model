classdef batteryThermalPortSelection < int32
% Battery Thermal Port Selection
%    
% Copyright 2020-2021 The MathWorks, Inc.
% 
    enumeration
        thermalPortConn  (1)
        thermalPortLumped(2)
        thermalLUT       (3)
        convectionBC     (4)
    end

    methods(Static)
        function map = displayText()
            map = containers.Map;
            map('thermalPortConn')   = 'Detailed thermal output';
            map('thermalPortLumped') = 'Lumped thermal port';
            map('thermalLUT')        = 'Thermal lookup table';
            map('convectionBC')      = 'Convection boundary';
        end
    end
end

