function [indx1,indx2] = getGroupedModelIndexCheck(vector1D,Np,isItForCooling)
% Copyright 2020-2021 The MathWorks, Inc.

    val1=max(vector1D);
    res1=find(val1==vector1D);
    trackCellNum1=res1(1);
    val2=min(vector1D);
    res2=find(val2==vector1D);
    trackCellNum2=res2(end);
    indx1=min(trackCellNum1,trackCellNum2);
    indx2=max(trackCellNum1,trackCellNum2);
    % Check is Grouped Model contraint is satisfied, else choose new
    % data or index
    testGap=indx2-indx1-2*Np;
    isDataVarPresent=sum(abs(diff(vector1D)));
    % 
    if testGap<0 && isDataVarPresent>0 && isItForCooling==1
        % Enter this loop only for LUT based cooling (isItForCooling==1)
        % Need to re-work indx1 and indx2 if (testGap<0 && isDataVarPresent>0)
        vector1D_ascending=sort(vector1D);
        loopSize=max(size(vector1D));
        indxFound=0;
        indx1_try=indx1;
        indx2_try=indx2;
        for i = 2:loopSize
            if indxFound==0
                val_minIndx=find(vector1D_ascending(i)==vector1D);
                val_maxIndx=find(vector1D_ascending(loopSize)==vector1D);
                indx1_try=min(val_minIndx(end),val_maxIndx(1));
                indx2_try=max(val_minIndx(end),val_maxIndx(1));
                indxFound=(indx2_try-indx1_try-2*Np>0);
            end
        end
        indx1=indx1_try;
        indx2=indx2_try;
    end
end

