function meanLogWageM = wage_by_year(sexCode, yearV, setNo)
% Show stats for wages by year
% ---------------------------------------

cS = const_cpsearn(setNo);
ny = length(yearV);

% Mean log wage by school group
meanLogWageM = zeros([cS.nSchool, ny]);


for iy = 1 : ny
   % For wages in year 1, must load year 2 variables
   year1 = yearV(iy) + 1;
   if year1 <= cS.yearV(end)
   
      wtV = output_cpsearn.var_load(cS.vWeight, year1, setNo);
      % Age at interview
      ageV = output_cpsearn.var_load(cS.vAge, year1, setNo);
      sexV = output_cpsearn.var_load(cS.vSex, year1, setNo);
      schoolClV = output_cpsearn.var_load(cS.vSchoolGroup, year1, setNo);
      % Wage for year1 - 1
      wageV = output_cpsearn.var_load(cS.vRealWeeklyWage, year1, setNo);

      wtV(ageV < 26  |  ageV > 51  |  wageV <= 0  |  sexV ~= sexCode) = 0;

      % Compute median wage
      idxV = find(wtV > 0);
      medianWage = distrib_lh.weighted_median(wageV(idxV), wtV(idxV), 1);

      for iSchool = 1 : cS.nSchool
         idxV = find(wtV > 0  &  schoolClV == iSchool  &  wageV >= 0.05 .* medianWage);

         meanLogWageM(iSchool, iy) = sum(wtV(idxV) .* log(wageV(idxV))) ./ sum(wtV(idxV));
      end
   end
end

end