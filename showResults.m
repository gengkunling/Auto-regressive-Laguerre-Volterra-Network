function showResults(LVN)
y = LVN.y;

for i = 1:LVN.Ni
    if LVN.Ni > 1
        disp(['For input ', int2str(i)]);
    end
    alpha = LVN.A(i);
    format short
    eval(['W = LVN.W', int2str(i)]);
    format shortE
    eval(['C = LVN.C', int2str(i)]);
    disp('');
    disp('--------------------------------------------');
end
NMSE = LVN.nmse;
Y0 = LVN.Y0;
Cx = LVN.Cx
disp(['Y0 =: ', num2str(Y0)]);
disp(['NMSE is: ', num2str(NMSE)]);