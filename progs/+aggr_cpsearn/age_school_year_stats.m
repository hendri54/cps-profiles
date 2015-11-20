function age_school_year_stats(setNo)
% Compute stats by [age, school, year, universe]
%{
Outputs indexed by physical age, cS.yearV

Universe:
   iAll or iWorkers

Account for the fact that earnings refer to past year

Checked: 2015-Jul-1
%}
% --------------------------------------------

cS = const_cpsearn(setNo);
fltS = output_cpsearn.var_load(cS.vFilterSettings, [], setNo);
ny = length(cS.yearV);

% Min obs per cell
minObs = 10;

% ages retained
saveS.ageV = fltS.ageMin : fltS.ageMax;
saveS.yearV = cS.yearV;
nAge = length(saveS.ageV);
% Universe dimension
nu = 2;


%% Allocate output matrices

sizeV = [fltS.ageMax, cS.nSchool, ny, nu];

% No ob observations
saveS.nObs_astuM = zeros(sizeV);
% Mass 
saveS.mass_astuM = zeros(sizeV);

% Mean log wage (real, weekly), only those with earnings above threshold
saveS.wageMeanLog_astuM = repmat(cS.missVal, sizeV);
% Mean log annual real earnings, only those with earnings above threshold
saveS.earnMeanLog_astuM = repmat(cS.missVal, sizeV);

saveS.wageMedian_astuM = repmat(cS.missVal, sizeV);
% Median annual real earnings, all
saveS.earnMedian_astuM = repmat(cS.missVal, sizeV);
% Fraction working (earnings more than threshold)
% saveS.fracWorkingM = repmat(cS.missVal, sizeV);

% Mean hours per year (median does not work b/c of intervalling)
% saveS.hoursYearMean_astM = repmat(cS.missVal, sizeV);
% Mean weeks worked per year
saveS.weeksMean_astuM = repmat(cS.missVal, sizeV);

% Average years of schooling
saveS.schoolYrMean_astuM = repmat(cS.missVal, sizeV);


%% Compute aggregates

% Start in year 2, which reports wages in year 1
for iy = 2 : ny
   year1 = cS.yearV(iy);
   
   % Load ind variables
   wageV = output_cpsearn.var_load(cS.vRealWeeklyWage, year1, setNo);
   % Earnings: include those not working (earn = 0)
   earnV = output_cpsearn.var_load(cS.vRealAnnualEarnAll, year1, setNo);
   weeksV = output_cpsearn.var_load(cS.vWeeksYear, year1, setNo);
   % isWorkingV = output_cpsearn.var_load(cS.vIsWorking, year1, setNo);
   schoolClV = output_cpsearn.var_load(cS.vSchoolGroup, year1, setNo);
   schoolYrV = output_cpsearn.var_load(cS.vSchoolYears, year1, setNo);
   wtV = output_cpsearn.var_load(cS.vWeight, year1, setNo);
   % Age when wages were earned
   ageV = output_cpsearn.var_load(cS.vAge, year1, setNo) - 1;
   
   % Drop missing observations
   wtV(schoolYrV <= 0) = 0;
   
   logEarnV = log_lh(earnV, cS.missVal);
   logWageV = log_lh(wageV, cS.missVal);
   
   for iu = [cS.iAll, cS.iWorkers]
      for iAge = 1 : nAge
         age1 = saveS.ageV(iAge);      
         for iSchool = 1 : cS.nSchool
            validV = (schoolClV == iSchool)  &  (ageV == age1)  &  (wtV > 0)  &  (earnV >= 0)  &  (weeksV >= 0);
            if iu == cS.iWorkers
               validV(wageV <= 0  |  weeksV <= 0  |  earnV <= 0) = false;
            end
            
            sIdxV = find(validV);
            if length(sIdxV) >= minObs
               % All results refer to last year, when wages were earned
               saveS.nObs_astuM(age1, iSchool, iy-1, iu) = length(sIdxV);
               clWtV = wtV(sIdxV);
               cellMass = sum(clWtV);
               saveS.mass_astuM(age1, iSchool, iy-1, iu) = cellMass;
               clWtV = clWtV ./ cellMass;

               % Fraction working
   %             saveS.fracWorkingM(age1, iSchool, iy-1) = sum((isWorkingV(sIdxV) == 1) .* wtV(sIdxV)) ./ saveS.massM(age1, iSchool, iy-1);

               % Median earnings
               medianEarn = distrib_lh.weighted_median(earnV(sIdxV), clWtV, cS.dbg);
               saveS.earnMedian_astuM(age1, iSchool, iy-1, iu) = medianEarn;

               medianWage = distrib_lh.weighted_median(wageV(sIdxV), clWtV, cS.dbg);
               saveS.wageMedian_astuM(age1, iSchool, iy-1, iu) = medianWage;

               saveS.weeksMean_astuM(age1, iSchool, iy-1, iu) = ...
                  sum(weeksV(sIdxV) .* clWtV);
               
               saveS.schoolYrMean_astuM(age1, iSchool, iy-1, iu) = ...
                  sum(schoolYrV(sIdxV) .* clWtV);

               % These can only be computed for all with wages
               if iu == cS.iWorkers
                  % Annual earnings
                  saveS.earnMeanLog_astuM(age1, iSchool, iy-1, iu) = sum(logEarnV(sIdxV) .* clWtV);

                  % Weekly wage
                  %  Enough to restrict wage > 0 b/c very small wages were
                  %  dropped
                  saveS.wageMeanLog_astuM(age1, iSchool, iy-1, iu) = sum(logWageV(sIdxV) .* clWtV);
               end
            end
         end % iSchool
      end
   end
end


%% Save and check

output_cpsearn.var_save(saveS, cS.vAgeSchoolYearStats, [], setNo);


validateattributes(saveS.wageMeanLog_astuM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
validateattributes(saveS.earnMeanLog_astuM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
validateattributes(saveS.wageMedian_astuM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
validateattributes(saveS.earnMedian_astuM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

validateattributes(saveS.schoolYrMean_astuM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})


end