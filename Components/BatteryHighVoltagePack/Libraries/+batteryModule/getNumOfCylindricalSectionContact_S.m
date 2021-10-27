function data = getNumOfCylindricalSectionContact_S(cellIndx,x,sectionData,nCell,indx)
% Copyright 2020-2021 The MathWorks, Inc.

    % Output data of size 1+nCell
    % Input data : 
    %      cellIndx(size1+nCell)
    %      x=cellCylinLine
    %      sectionData=cellIndex5Section(size=5)
    numCells_cellIndx=cellIndx(1,1);
    cells_cellIndx=cellIndx(1,2:numCells_cellIndx+1);
    data=zeros(1,6); % In 6, 1st index stores actual size (# sections in contact)
                     % In 6, the rest 5 refer to the section number (1-5)
                     % in contact
    
    if indx == 1
        % left
        if x<=sectionData(1,1)
            data(1,1)=1; data(1,2)=1; % 1st section only on this side
        elseif x>sectionData(1,1) && x<=sectionData(1,2)
            data(1,1)=2; data(1,2)=1; data(1,3)=2; 
        elseif x>sectionData(1,2) && x<=sectionData(1,3)
            data(1,1)=3; data(1,2)=1; data(1,3)=2; data(1,4)=3;
        elseif x>sectionData(1,3) && x<=sectionData(1,4)
            data(1,1)=4; data(1,2)=1; data(1,3)=2; data(1,4)=3; data(1,5)=4;
        else
            data(1,1)=5; data(1,2)=1; data(1,3)=2; data(1,4)=3; data(1,5)=4; data(1,6)=5;
        end
    elseif indx == 2
        % right
        y=x*(ceil(nCell/x)-1)+1;
        if y<=sectionData(1,1)
            data(1,1)=5; data(1,2)=1; data(1,3)=2; data(1,4)=3; data(1,5)=4; data(1,6)=5; % 1st section only on this side
        elseif y>sectionData(1,1) && y<=sectionData(1,2)
            data(1,1)=4; data(1,2)=2; data(1,3)=3; data(1,4)=4; data(1,5)=5; 
        elseif y>sectionData(1,2) && y<=sectionData(1,3)
            data(1,1)=3; data(1,2)=3; data(1,3)=4; data(1,4)=5;
        elseif y>sectionData(1,3) && y<=sectionData(1,4)
            data(1,1)=2; data(1,2)=4; data(1,3)=5;
        else
            data(1,1)=1; data(1,2)=5; 
        end
    elseif indx == 3
        % posEnd
        tempVar=ones(1,5);
        for i = 2*x:2*x:nCell
            if i<=sectionData(1,1)
                tempVar(1,1)=0;
            elseif i>sectionData(1,1) && i<=sectionData(1,2)
                tempVar(1,2)=0;
            elseif i>sectionData(1,2) && i<=sectionData(1,3)
                tempVar(1,3)=0;
            elseif i>sectionData(1,3) && i<=sectionData(1,4)
                tempVar(1,4)=0;
            else
                tempVar(1,5)=0;
            end
        end
        for i = (2*x+1):2*x:nCell
            if i<=sectionData(1,1)
                tempVar(1,1)=0;
            elseif i>sectionData(1,1) && i<=sectionData(1,2)
                tempVar(1,2)=0;
            elseif i>sectionData(1,2) && i<=sectionData(1,3)
                tempVar(1,3)=0;
            elseif i>sectionData(1,3) && i<=sectionData(1,4)
                tempVar(1,4)=0;
            else
                tempVar(1,5)=0;
            end
        end
        tempVar(1,1)=0; % for 1st cell
        tempCnt=0; 
        for i=1:5
            if tempVar(1,i) == 0
                tempCnt=tempCnt+1;
                data(1,tempCnt+1)=i; % +1 as data(1,1)=tempCnt;
            end
        end
        data(1,1)=tempCnt;
    elseif indx == 4
        % negEnd
        tempVar=ones(1,5);
        for i = x:2*x:nCell
            if i<=sectionData(1,1)
                tempVar(1,1)=0;
            elseif i>sectionData(1,1) && i<=sectionData(1,2)
                tempVar(1,2)=0;
            elseif i>sectionData(1,2) && i<=sectionData(1,3)
                tempVar(1,3)=0;
            elseif i>sectionData(1,3) && i<=sectionData(1,4)
                tempVar(1,4)=0;
            else
                tempVar(1,5)=0;
            end
        end
        for i = (x+1):2*x:nCell
            if i<=sectionData(1,1)
                tempVar(1,1)=0;
            elseif i>sectionData(1,1) && i<=sectionData(1,2)
                tempVar(1,2)=0;
            elseif i>sectionData(1,2) && i<=sectionData(1,3)
                tempVar(1,3)=0;
            elseif i>sectionData(1,3) && i<=sectionData(1,4)
                tempVar(1,4)=0;
            else
                tempVar(1,5)=0;
            end
        end
        tempCnt=0; 
        for i=1:5
            if tempVar(1,i) == 0
                tempCnt=tempCnt+1;
                data(1,tempCnt+1)=i; % +1 as data(1,1)=tempCnt;
            end
        end
        data(1,1)=tempCnt;
    else
        % Error
        
    end
end

