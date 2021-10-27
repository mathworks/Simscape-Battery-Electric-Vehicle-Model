function groupedVal = getGroupedModelParam1Dvec(param_val,cellIndex5Section,numCells5section)
% Copyright 2020-2021 The MathWorks, Inc.

    tmpVar01=sum(param_val(1:cellIndex5Section(1)))/numCells5section(1);
    tmpVar02=sum(param_val(cellIndex5Section(1)+1:cellIndex5Section(2)))/numCells5section(2);
    tmpVar03=sum(param_val(cellIndex5Section(2)+1:cellIndex5Section(3)))/numCells5section(3);
    tmpVar04=sum(param_val(cellIndex5Section(3)+1:cellIndex5Section(4)))/numCells5section(4);
    tmpVar05=sum(param_val(cellIndex5Section(4)+1:cellIndex5Section(5)))/numCells5section(5);
    groupedVal=[tmpVar01,tmpVar02,tmpVar03,tmpVar04,tmpVar05];
end

