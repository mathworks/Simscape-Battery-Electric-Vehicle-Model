function [LUTpointsTemp_coolant,LUTpointsFlowrate,moduleCooling,thermalLUT_selected] = ...
    getThermalLUTfromSideDefinition(thermalManagement,thermal_moduleBottom,thermal_moduleTop,...
    thermal_moduleLeft,thermal_moduleRight,thermal_modulePos,thermal_moduleNeg,...
    LUTpointsFlowrate_b,moduleCooling_b,LUTpointsTemp_b,...
    LUTpointsFlowrate_t,moduleCooling_t,LUTpointsTemp_t,...
    LUTpointsFlowrate_l,moduleCooling_l,LUTpointsTemp_l,...
    LUTpointsFlowrate_r,moduleCooling_r,LUTpointsTemp_r,...
    LUTpointsFlowrate_p,moduleCooling_p,LUTpointsTemp_p,...
    LUTpointsFlowrate_n,moduleCooling_n,LUTpointsTemp_n)


    % Copyright 2020-2021 The MathWorks, Inc.

    thermalLUT_selected=0;
    if thermalManagement == batteryModule.batteryCoolingSystem.none
        % No thermal model, LUT based cooling option selection not possible
        % Default = LUTpointsFlowrate_b,moduleCooling_b
        LUTpointsFlowrate=LUTpointsFlowrate_b;
        moduleCooling=moduleCooling_b;
        LUTpointsTemp_coolant=LUTpointsTemp_b;
    else
        % Thermal model ON
        if thermal_moduleBottom == batteryModule.batteryThermalPortSelection.thermalLUT
            LUTpointsFlowrate=LUTpointsFlowrate_b;
            moduleCooling=moduleCooling_b;
            LUTpointsTemp_coolant=LUTpointsTemp_b;
            thermalLUT_selected=1;
        elseif thermal_moduleTop == batteryModule.batteryThermalPortSelection.thermalLUT
            LUTpointsFlowrate=LUTpointsFlowrate_t;
            moduleCooling=moduleCooling_t;
            LUTpointsTemp_coolant=LUTpointsTemp_t;
            thermalLUT_selected=1;
        elseif thermal_moduleLeft == batteryModule.batteryThermalPortSelection.thermalLUT
            LUTpointsFlowrate=LUTpointsFlowrate_l;
            moduleCooling=moduleCooling_l;
            LUTpointsTemp_coolant=LUTpointsTemp_l;
            thermalLUT_selected=1;
        elseif thermal_moduleRight == batteryModule.batteryThermalPortSelection.thermalLUT
            LUTpointsFlowrate=LUTpointsFlowrate_r;
            moduleCooling=moduleCooling_r;
            LUTpointsTemp_coolant=LUTpointsTemp_r;
            thermalLUT_selected=1;
        elseif thermal_modulePos == batteryModule.batteryThermalPortSelection.thermalLUT
            LUTpointsFlowrate=LUTpointsFlowrate_p;
            moduleCooling=moduleCooling_p;
            LUTpointsTemp_coolant=LUTpointsTemp_p;
            thermalLUT_selected=1;
        elseif thermal_moduleNeg == batteryModule.batteryThermalPortSelection.thermalLUT
            LUTpointsFlowrate=LUTpointsFlowrate_n;
            moduleCooling=moduleCooling_n;
            LUTpointsTemp_coolant=LUTpointsTemp_n;
            thermalLUT_selected=1;
        else
            % Default = LUTpointsFlowrate_b,moduleCooling_b
            LUTpointsFlowrate=LUTpointsFlowrate_b;
            moduleCooling=moduleCooling_b;
            LUTpointsTemp_coolant=LUTpointsTemp_b;
        end
    end
end

