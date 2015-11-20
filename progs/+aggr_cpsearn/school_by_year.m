function [avgSchoolV, fracM] = school_by_year(setNo)
% Show stats for schooling by year
% ---------------------------------------

cS = const_cpsearn(setNo);
ny = length(cS.yearV);

% Avg years of schooling
avgSchoolV = zeros([ny, 1]);
% Fraction by school group
fracM = zeros([cS.nSchool, ny]);

for iy = 1 : ny
   year1 = cS.yearV(iy);
   
   wtV = output_cpsearn.var_load(cS.vWeight, year1, setNo);
   ageV = output_cpsearn.var_load(cS.vAge, year1, setNo);
   schoolClV = output_cpsearn.var_load(cS.vSchoolGroup, year1, setNo);
   schoolV = output_cpsearn.var_load(cS.vSchoolYears, year1, setNo);
   
   idxV = find(wtV > 0  &  ageV >= 25  &  ageV <= 50  &  schoolClV > 0  &  schoolV >= 0);
   totalWt = sum(wtV(idxV));
   
   avgSchoolV(iy) = sum(wtV(idxV) .* schoolV(idxV)) ./ totalWt;
   
   for iSchool = 1 : cS.nSchool
      fracM(iSchool, iy) = sum(wtV(idxV) .* (schoolClV(idxV) == iSchool)) ./ totalWt;
   end
end

end