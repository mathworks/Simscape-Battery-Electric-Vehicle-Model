function [indx1,indx2] = getGroupedModelIndexFinal(thermalLUT_selected,calcFinalIndices)
% -------------------------------------------------------------------------
%     calcFinalIndices=[isDataVarPresent_Coolant,indxCell1_CP,indxCell2_CP;...
%                       isDataVarPresent_R0,indxCell1_R0,indxCell2_R0;...
%                       isDataVarPresent_Q,indxCell1_Q,indxCell2_Q;...
%                       isDataVarPresent_Rleak,indxCell1_Rleak,indxCell2_Rleak;...
%                       isDataVarPresent_AH,indxCell1_AH,indxCell2_AH];
% -------------------------------------------------------------------------
% isDataVarPresent_xx = 0 IF NO VARIATION present
% Preference Order :
%                  1) _Coolant = ROW 1 entry
%                  2) _R0 = ROW 2 entry
%                  3) _AH = ROW 5 entry
%                  4) Rleak = ROW 4 entry
%                  5) Q = ROW 3 entry
%                  6) No variation present => Choose based on _Coolant entry
% -------------------------------------------------------------------------
%
% Copyright 2020-2021 The MathWorks, Inc.

if thermalLUT_selected == 1
    if calcFinalIndices(1,1) > 0
        indx1=calcFinalIndices(1,2);
        indx2=calcFinalIndices(1,3);
    else
        if calcFinalIndices(2,1) > 0
            indx1=calcFinalIndices(2,2);
            indx2=calcFinalIndices(2,3);
        else
            if calcFinalIndices(5,1) > 0
                indx1=calcFinalIndices(5,2);
                indx2=calcFinalIndices(5,3);
            else
                if calcFinalIndices(4,1) > 0
                    indx1=calcFinalIndices(4,2);
                    indx2=calcFinalIndices(4,3);
                else
                    if calcFinalIndices(3,1) > 0
                        indx1=calcFinalIndices(3,2);
                        indx2=calcFinalIndices(3,3);
                    else
                        % Default is Cooling Eff. variation
                        indx1=calcFinalIndices(1,2);
                        indx2=calcFinalIndices(1,3);
                    end
                end
            end
        end
    end
else
    % ThermalManagement = Thermal Ports (only lumped thermal ports work 
    % with the Grouped Battery Model and hence Cooling eff. is NOT 
    % checked for) 
    % OR 
    % ThermalManagement = None
    %
    % Worst and best cells selected based on other cell-to-cell variations
    if calcFinalIndices(2,1) > 0
        indx1=calcFinalIndices(2,2);
        indx2=calcFinalIndices(2,3);
    else
        if calcFinalIndices(5,1) > 0
            indx1=calcFinalIndices(5,2);
            indx2=calcFinalIndices(5,3);
        else
            if calcFinalIndices(4,1) > 0
                indx1=calcFinalIndices(4,2);
                indx2=calcFinalIndices(4,3);
            else
                if calcFinalIndices(3,1) > 0
                    indx1=calcFinalIndices(3,2);
                    indx2=calcFinalIndices(3,3);
                else
                    % Default is Resistance variation
                    indx1=calcFinalIndices(2,2);
                    indx2=calcFinalIndices(2,3);
                end
            end
        end
    end
end

end

