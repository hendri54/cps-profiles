function aggr_stats(setNo)
% Aggregate stats by year

cS = const_cpsearn(setNo);
yearV = cS.yearV;
ny = length(yearV);
nu = 2;  % all or workers

% Filter settings
fltS = output_cpsearn.var_load(cS.vFilterSettings, [], setNo);


% Allocate output matrices by [school, year, universe]
fnV = {'wageMeanLog_stuM', 'wageMedian_stuM'};
for iField = 1 : length(fnV)
   saveS.(fnV{iField}) = repmat(cS.missVal, [cS.nSchool, ny, nu]);
end

% Wage [young / middle aged / old, year, universe]
nYmo = size(fltS.ymoAgeRangeM, 1);
saveS.wageMedian_ymo_stuM = repmat(cS.missVal, [nYmo, cS.nSchool, ny, nu]);
saveS.wageMeanLog_ymo_stuM = repmat(cS.missVal, [nYmo, cS.nSchool, ny, nu]);


%% Main loop

% Last year has no wage data
for iy = 1 : (ny - 1)
   % For wages in year 1, must load year 2 variables
   year1 = yearV(iy) + 1;
   
   wtV = output_cpsearn.var_load(cS.vWeight, year1, setNo);
   % Age at interview
   ageV = output_cpsearn.var_load(cS.vAge, year1, setNo);
   % sexV = output_cpsearn.var_load(cS.vSex, year1, setNo);
   schoolClV = output_cpsearn.var_load(cS.vSchoolGroup, year1, setNo);
   % Wage for year1 - 1
   wageV = output_cpsearn.var_load(cS.vRealWeeklyWage, year1, setNo);
   logWageV = log_lh(wageV, cS.missVal);

   for iSchool = 1 : cS.nSchool
      for iu = [cS.iAll, cS.iWorkers]
         for iAge = 1 : (nYmo + 1);
            if iAge > nYmo
               % All ages
               ageLb = cS.aggrAgeRangeV(1);
               ageUb = cS.aggrAgeRangeV(end);
            else
               % Young / middle aged / old
               ageLb = fltS.ymoAgeRangeM(iAge, 1);
               ageUb = fltS.ymoAgeRangeM(iAge, end);
            end
            
            % Find matching persons
            validV = (wtV > 0)  &  (schoolClV == iSchool)  &  (ageV >= ageLb)  &  (ageV <= ageUb);
            if iu == cS.iWorkers
               % Only workers with valid wages
               validV(wageV <= 0) = false;
            end

            idxV = find(validV);
            if length(idxV) < 50
               error('No data');
            end
            
            totalWt = sum(wtV(idxV));
            clWtV = wtV(idxV) / totalWt;

            wageMedian = distrib_lh.weighted_median(wageV(idxV), clWtV, cS.dbg);
            if iu == cS.iWorkers
               wageMeanLog = sum(clWtV .* logWageV(idxV));
            else
               wageMeanLog = cS.missVal;
            end
            
            % Put into saved matrices
            if iAge > nYmo
               saveS.wageMedian_stuM(iSchool, iy, iu) = wageMedian;
               saveS.wageMeanLog_stuM(iSchool, iy, iu) = wageMeanLog;
            else
               saveS.wageMedian_ymo_stuM(iAge, iSchool, iy, iu) = wageMedian;
               saveS.wageMeanLog_ymo_stuM(iAge, iSchool, iy, iu) = wageMeanLog;
            end
         end % age group
      end % iu
   end
end


output_cpsearn.var_save(saveS, cS.vAggrStats, [], setNo);


%% Output check

fieldV = {'wageMedian_stuM', 'wageMeanLog_stuM', 'wageMedian_ymo_stuM', 'wageMeanLog_ymo_stuM'};
for i1 = 1 : length(fieldV)
   nameStr = fieldV{i1};
   validateattributes(saveS.(nameStr), {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
end

end