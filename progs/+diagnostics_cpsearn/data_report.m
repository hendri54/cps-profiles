function data_report(yearV, setNo)
% Show basic sample stats as a diagnostic

cS = const_cpsearn(setNo);
if isempty(yearV)
   % All years
   yearV = cS.yearV;
end
ny = length(yearV);



%% Compute stats

nObsV = zeros(ny,1);
ageMeanV = zeros(ny, 1);
hoursMeanV = zeros(ny, 1);
weeksMeanV = zeros(ny, 1);
schoolMeanV = zeros(ny, 1);
cgFracV = zeros(ny, 1);
wageMedianV = zeros(ny, 1);
incWageFracTopCodedV = zeros(ny, 1);
incWageTopCodeV = zeros(ny, 1);

for iy = 1 : ny
   year1 = yearV(iy);
   incWageV = output_cpsearn.var_load(cS.vIncWage, year1, setNo);
   wageV = output_cpsearn.var_load(cS.vRealWeeklyWage, year1, setNo);
   schoolGroupV = output_cpsearn.var_load(cS.vSchoolGroup, year1, setNo);
   schoolV = output_cpsearn.var_load(cS.vSchoolYears, year1, setNo);
   weeksV = output_cpsearn.var_load(cS.vWeeksYear, year1, setNo);
   hoursV = output_cpsearn.var_load(cS.vHoursWeek, year1, setNo);
   ageV = output_cpsearn.var_load(cS.vAge, year1, setNo);
   wtV  = output_cpsearn.var_load(cS.vWeight, year1, setNo);
   wtV = wtV ./ sum(wtV);
   
   if any(wtV <= 0)
      error('Unexpected');
   end
   if any(schoolV < 0)
      error('Missing schooling');
   end
   
   nObsV(iy) = length(wtV);
   ageMeanV(iy) = sum(ageV .* wtV);
   hoursMeanV(iy) = sum(hoursV .* wtV);
   weeksMeanV(iy) = sum(weeksV .* wtV);
   schoolMeanV(iy) = sum(schoolV .* wtV);
   cgFracV(iy) = sum((schoolGroupV == cS.iCG) .* wtV);
   idxV = find(wageV > 0);
   wageMedianV(iy) = distrib_lh.weighted_median(wageV(idxV), wtV(idxV), cS.dbg);
   % Top coded incWage
   incWageTopCodeV(iy) = max(incWageV);
   incWageFracTopCodedV(iy) = sum((abs(incWageV - incWageTopCodeV(iy)) < 100) .* wtV);
end


%% Checks

validateattributes(nObsV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 5000})
validateattributes(ageMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 30, '<', 50})
validateattributes(hoursMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 15, '<', 50})
validateattributes(weeksMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 15, '<' 51})
validateattributes(schoolMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 8, '<', 15})
validateattributes(incWageTopCodeV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>', 9000})



%% Table setup
% Each row is a year

nr = ny + 1;

nc = 15;

tbM = cell([nr, nc]);
tbS.rowUnderlineV = zeros(nr, 1);



%% Fill table

for iy = 1 : ny
   ir = 1 + iy;
   year1 = yearV(iy);
   if rem(year1, 10) == 0
      tbS.rowUnderlineV(ir) = 1;
   end
   ic = 1;
   
   row_add('Year', sprintf('%i', year1));
   row_add('N', sprintf('%i', nObsV(iy)));
   row_add('Age', sprintf('%.1f', ageMeanV(iy)));
   row_add('Hours', sprintf('%.1f', hoursMeanV(iy)));
   row_add('Weeks', sprintf('%.1f', weeksMeanV(iy)));
   row_add('School', sprintf('%.1f', schoolMeanV(iy)));
   row_add('CgFrac', sprintf('%.2f', cgFracV(iy)));
   row_add('Wage', sprintf('%.1f', wageMedianV(iy)));
   row_add('TopCode', sprintf('%.0f', incWageTopCodeV(iy)));
   row_add('FracTop', sprintf('%.3f', incWageFracTopCodedV(iy)));

end



%% Save table

tbFn = fullfile(cS.dirS.tbDir,  'sample_report');
latex_lh.latex_texttb_lh(tbFn, tbM(:, 1 : ic), 'report', 'report', tbS, cS.dbg);


return;


%% Nested: Add a row
   function row_add(descrStr, valueStr)
      ic = ic + 1;
      if ir == 2
         tbM{1, ic} = descrStr;
      end
      tbM{ir, ic} = valueStr;
   end


end