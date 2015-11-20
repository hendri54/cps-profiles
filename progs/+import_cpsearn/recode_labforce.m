function outV = recode_labforce(inV, year1, setNo)
% -----------------------------------------

cS = const_cpsearn(setNo);

% Range check
if any(inV > 2)
   disp('Invalid range');
   keyboard;
end

outV = repmat(cS.missVal, size(inV));
outV(inV == 1) = 0;
outV(inV == 2) = 1;



end