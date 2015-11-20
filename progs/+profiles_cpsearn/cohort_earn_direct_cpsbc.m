function outS = cohort_earn_direct_cpsbc(bYear, iSchoolV, setNo)
% Directly compute earnings stats for a birth cohort
% all real
% ------------------------------------------

bcS = const_bc1([]);
cS = const_cpsbc(setNo);
cS.sexCode = cS.male;
ny = length(cS.yearV);
fltS = output_cpsearn.var_load(cS.vFilterSettings, [], setNo);

outS.yearV = cS.yearV;
outS.nObsV = zeros([ny, 1]);
outS.meanV = repmat(cS.missVal, [ny, 1]);
outS.medianV = repmat(cS.missVal, [ny, 1]);
outS.stdV = repmat(cS.missVal, [ny, 1]);
% Mean log earn above threshold , REAL
outS.meanLogV = repmat(cS.missVal, [ny, 1]);

% Start in year 1 with wages for year 1
for iy = 2 : ny
   year1 = cS.yearV(iy);

   % Load ind variables
   % classWkrV = var_load_cpsbc(cS.vClassWkr,  year1, setNo);
   incWageV  = var_load_cpsbc(cS.vIncWage,   year1, setNo);
   % Business income - can be negative
   incBusV   = var_load_cpsbc(cS.vIncBus,    year1, setNo);
   wtV       = var_load_cpsbc(cS.vWeight, year1, setNo);
   sexV      = var_load_cpsbc(cS.vSex, year1, setNo);
   % Age at interview
   ageV      = var_load_cpsbc(cS.vAge, year1, setNo);
   schoolClV = var_load_cpsbc(cS.vSchoolGroup, year1, setNo);
   
   cpi = data_bc1.cpi(year1 - 1, bcS);
   
   validSchoolClV = zeros(size(schoolClV));
   for i1 = 1 : length(iSchoolV)
      validSchoolClV(schoolClV == iSchoolV(i1)) = 1;
   end
   
   bYearV = year1 - (ageV - fltS.ageInBirthYear);
   
   % Keep everybody - could drop gov workers, but not consistent with NLSY
   idxV = find(incWageV >= 0  &  incBusV ~= cS.missVal  &  wtV > 0  &  sexV == cS.sexCode  &  ...
      bYearV == bYear  &   validSchoolClV == 1);

   outS.nObsV(iy-1) = length(idxV);
   if outS.nObsV(iy-1) > 10
      earnV = (incWageV(idxV) + fltS.fracBusInc .* incBusV(idxV)) ./ cpi;
      clWtV = wtV(idxV);
      
      [outS.stdV(iy-1), outS.meanV(iy-1)] = stats_lh.std_w(earnV,  wtV(idxV), cS.dbg);
      outS.medianV(iy-1) = distrib_lh.weighted_median(earnV, wtV(idxV), cS.dbg);
      
      % Mean log above threshold, real
      posIdxV = find(earnV >= cS.minRealEarn);
      [~, outS.meanLogV(iy-1)] = stats_lh.std_w(log(earnV(posIdxV)),  clWtV(posIdxV), cS.dbg);
   end   
end


%% Output check
if cS.dbg > 10
   sizeV = [ny, 1];
   validateattributes(outS.meanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', sizeV})
end


end