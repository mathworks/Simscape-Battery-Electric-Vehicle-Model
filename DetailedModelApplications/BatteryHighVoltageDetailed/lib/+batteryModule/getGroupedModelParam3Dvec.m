function groupedVal = getGroupedModelParam3Dvec(param_val,cellIndex5Section,thermalLUT_selected)
% Copyright 2020-2021 The MathWorks, Inc.

    if thermalLUT_selected == 1
        i=cellIndex5Section(1);
        j=cellIndex5Section(2);
        k=cellIndex5Section(3);
        l=cellIndex5Section(4);
        m=cellIndex5Section(5);
    else
        % When the Cooling in not LUT based, then default parameter size is
        % of 10 cells in module
        m=size(param_val,3);
        l=m-2;k=l-2;j=k-2;i=j-2;
    end
    param_val1=param_val(1:end,1:end,1:i);
    param_val2=param_val(1:end,1:end,i+1:j);
    param_val3=param_val(1:end,1:end,j+1:k);
    param_val4=param_val(1:end,1:end,k+1:l);
    param_val5=param_val(1:end,1:end,l+1:m);

    if i==1 % Single cell data, no need to permute and process
        paramValLumped_val1=param_val1;
    else % It's a 3D matrix (more than 1 cell data)
        paramValLumped1=permute(sum(permute(param_val1,[3,1,2])),[2,3,1]);
        paramValLumped_val1=repmat(paramValLumped1,[1,1,i]);
    end
    
    if j==i+1 % Single cell data, no need to permute and process
        paramValLumped_val2=param_val2;
    else % It's a 3D matrix (more than 1 cell data)
        paramValLumped2=permute(sum(permute(param_val2,[3,1,2])),[2,3,1]);
        paramValLumped_val2=repmat(paramValLumped2,[1,1,j-i]);
    end
    
    if k==j+1 % Single cell data, no need to permute and process
        paramValLumped_val3=param_val3;
    else % It's a 3D matrix (more than 1 cell data)
        paramValLumped3=permute(sum(permute(param_val3,[3,1,2])),[2,3,1]);
        paramValLumped_val3=repmat(paramValLumped3,[1,1,k-j]);
    end
    
    if l==k+1 % Single cell data, no need to permute and process
        paramValLumped_val4=param_val4;
    else % It's a 3D matrix (more than 1 cell data)
        paramValLumped4=permute(sum(permute(param_val4,[3,1,2])),[2,3,1]);
        paramValLumped_val4=repmat(paramValLumped4,[1,1,l-k]);
    end
    
    if m==l+1 % Single cell data, no need to permute and process
        paramValLumped_val5=param_val5;
    else % It's a 3D matrix (more than 1 cell data)
        paramValLumped5=permute(sum(permute(param_val5,[3,1,2])),[2,3,1]);
        paramValLumped_val5=repmat(paramValLumped5,[1,1,m-l]);
    end
    
    paramValLumped_cat1=cat(3,paramValLumped_val1,paramValLumped_val2);
    paramValLumped_cat2=cat(3,paramValLumped_cat1,paramValLumped_val3);
    paramValLumped_cat3=cat(3,paramValLumped_cat2,paramValLumped_val4);
    
    groupedVal=cat(3,paramValLumped_cat3,paramValLumped_val5);
end

