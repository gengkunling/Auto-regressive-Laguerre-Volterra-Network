function z = getZ(U, C)
% Get the ANF/PNF outputs z
% U is the PDM outputs matix with size NxH
% C is the polynomial coeeficients matrix with size QxH
Q = size(C, 1);
if Q == 1
    z = U * C';
elseif Q == 2
    U2 = U .* U;
    z = U * C(1, :)' + U2 * C(2, :)';
elseif Q == 3
    U2 = U .* U;
    U3 = U2 .* U;
    z = U * C(1, :)' + U2 * C(2, :)' + U3 * C(3, :)';
else
    error('The order Q should not exceed 3!');
end
