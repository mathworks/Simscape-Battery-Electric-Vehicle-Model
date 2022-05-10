classdef batteryCellVoltages < int32
% Battery type selection definition.
    
% Copyright 2020-2021 The MathWorks, Inc.
    enumeration
        no     (1)
        yes    (2)
    end

    methods(Static)
        function map = displayText()
            map = containers.Map;
            map('no') = 'No';
            map('yes') = 'Yes';
        end
    end
end

