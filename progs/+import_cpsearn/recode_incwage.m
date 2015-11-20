function outV = recode_incwage(inV, year1, setNo)
% Input variable has standard cps recode applied already
% Multiply top codes by 1.5 (Autor et al 2008)
% But: in later years (1996+) it simply is not clear what values are top
% codes.
% -----------------------------------------

%cS = const_cpsearn(setNo);

outV = inV;

% Top codes
xMax = max(inV);
idxV = find(inV == xMax);
if length(idxV) > 4
   fprintf('Incwage.  Top code %i:  %8.0f.  Occurs %i times (%5.1f pct). \n', ...
      year1, xMax, length(idxV),  100 .* length(idxV) ./ length(outV));
   outV(idxV) = xMax .* 1.5;
else
   fprintf('Incwage.  Max value %i: %8.0f.  Occurs %i times (%5.1f pct). \n', ...
      year1, xMax, length(idxV),  100 .* length(idxV) ./ length(outV));
end

% There is no bottom coding (incwage >= 0)


end