function data = getNumOfCylindricalCellsContact(x,Ns,Np,indx)
% Copyright 2020-2021 The MathWorks, Inc.

    % Output data of size 1+Ns*Np
    data=zeros(1,Ns*Np+1);
    if indx == 1
        % posEnd
        countCellNum=1;
        y = 1; % For cell # 1
        data(1,1+countCellNum)=1;
        countCellNum=countCellNum+1;
        for i = 2*x:2*x:Ns*Np
            y = y + 1;
            data(1,1+countCellNum)=i;
            countCellNum=countCellNum+1;
        end
        for i = (2*x+1):2*x:Ns*Np
            y = y + 1;
            data(1,1+countCellNum)=i;
            countCellNum=countCellNum+1;
        end
        data(1,1)=y;
    elseif indx == 2
        % negEnd
        countCellNum=1;
        y = 0;
        for i = x:2*x:Ns*Np
            y = y + 1;
            data(1,1+countCellNum)=i;
            countCellNum=countCellNum+1;
        end
        for i = x+1:2*x:Ns*Np
            y = y + 1;
            data(1,1+countCellNum)=i;
            countCellNum=countCellNum+1;
        end
        data(1,1)=y;
    elseif indx == 3
        % Left
        left_start=1;
        left_end=x;
        data(1,1)=left_end-left_start+1;
        countCellNum=1;
        for i = left_start:left_end
            data(1,1+countCellNum)=i;
            countCellNum=countCellNum+1;
        end
    elseif indx == 4
        % Right
        right_start=x*(ceil(Ns*Np/x)-1)+1;
        right_end=Ns*Np;
        data(1,1)=right_end-right_start+1;
        countCellNum=1;
        for i = right_start:right_end
            data(1,1+countCellNum)=i;
            countCellNum=countCellNum+1;
        end
    else
        
    end
end

