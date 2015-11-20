function cpiV = cpi(yearV, setNo)
%{
Returns cpi for each year
with cpiBaseYear = 1
%}

cS = const_cpsearn(setNo);
loadS = output_cpsearn.var_load(cS.vCpi, [], setNo);

yrIdxV = yearV - loadS.yearV(1) + 1;
if ~isequal(loadS.yearV(yrIdxV), yearV(:))
   error('Not implemented');
end

cpiV = loadS.cpiV(yrIdxV);

validateattributes(cpiV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   'size', [length(yearV), 1]})


end