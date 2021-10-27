classdef batteryTypeSelection < int32
% Battery type selection definition.
%    
% Copyright 2020-2021 The MathWorks, Inc.
% 
    enumeration
        pouch              (1)
        can                (2)
        compactCylindrical (3)
        regularCylindrical (4)
    end

    methods(Static)
        function map = displayText()
            map = containers.Map;
            map('pouch') = 'Pouch';
            map('can') = 'Can';
            map('compactCylindrical') = 'Compact cylindrical';
            map('regularCylindrical') = 'Regular cylindrical';
        end
    end
end

