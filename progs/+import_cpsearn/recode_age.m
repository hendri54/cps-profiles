function outV = recode_age(inV, year1, setNo)
% Input variable has standard cps recode applied already
% -----------------------------------------

cS = const_cpsearn(setNo);

% Subtract 1 to match year of earnings
%outV = inV - 1;

outV = inV;
outV(inV < 0) = cS.missVal;


end