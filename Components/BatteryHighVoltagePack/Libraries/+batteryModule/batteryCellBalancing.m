classdef batteryCellBalancing < int32
% Battery type selection definition.
    
% Copyright 2020-2021 The MathWorks, Inc.
    enumeration
        none              (1)
        passive           (2)
    end

    methods(Static)
        function map = displayText()
            map = containers.Map;
            map('none') = 'None';
            map('passive') = 'Passive';
        end
    end
end

