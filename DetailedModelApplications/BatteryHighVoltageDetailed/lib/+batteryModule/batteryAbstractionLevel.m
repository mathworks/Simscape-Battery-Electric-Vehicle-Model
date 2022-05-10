classdef batteryAbstractionLevel < int32
% Battery abstraction selection definition.
    
% Copyright 2020-2021 The MathWorks, Inc.
    enumeration
        lumped   (1)
        grouped  (2)
        detailed (3)
    end

    methods(Static)
        function map = displayText()
            map = containers.Map;
            map('lumped') = 'Lumped';
            map('grouped') = 'Grouped';
            map('detailed') = 'Detailed';
        end
    end
end

