function outV = recode_wkswork2(inV, year1, setNo)
% -----------------------------------------

cS = const_cpsearn(setNo);

% Range check
if any(inV > 9)
   disp('Invalid range');
   keyboard;
end

outV = repmat(cS.missVal, size(inV));

% code 0 is NIU - that must mean person is not working
oldV = 0 : 6;
newV = [0, 7, 20, 33, 44, 48, 51];

for i1 = 1 : length(oldV)
   outV(inV == oldV(i1)) = newV(i1);
end


end