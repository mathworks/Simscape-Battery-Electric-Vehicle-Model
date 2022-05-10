function [indx_cv01,indx_cv02,indx_cv03,indx_cv04,indx_cv05] = getGroupedModelFiveSections(indxCell1,indxCell2,Ns,Np)
% Copyright 2020-2021 The MathWorks, Inc.

    indx_cv001=max(Np,indxCell1-Np);
    indx_cv002=indx_cv001+Np;
    indx_cv005=Ns*Np;
    indx_cv004=indx_cv005-max(Np,Ns*Np-indxCell2);
    indx_cv003=indx_cv004-Np;
    %
    indx_cv01=max(Np,indx_cv001-mod(indx_cv001,Np)+min(mod(indx_cv001,Np),1)*Np);
    indx_cv02=max(Np,indx_cv002-mod(indx_cv002,Np)+min(mod(indx_cv002,Np),1)*Np);
    indx_cv03=max(Np,indx_cv003-mod(indx_cv003,Np)+min(mod(indx_cv003,Np),1)*Np);
    indx_cv04=max(Np,indx_cv004-mod(indx_cv004,Np)+min(mod(indx_cv004,Np),1)*Np);
    indx_cv05=max(Np,indx_cv005-mod(indx_cv005,Np)+min(mod(indx_cv005,Np),1)*Np);
end

