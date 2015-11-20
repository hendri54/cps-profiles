function outV = recode_empstat(inV, year1, setNo)
% -----------------------------------------

cS = const_cpsearn(setNo);

% Range check
if any(inV > 35)
   disp('Invalid range');
   keyboard;
end

% Recode
outV = repmat(cS.missVal, size(inV));
outV(inV > 0) = 0;
outV(inV == 10) = 1;


end