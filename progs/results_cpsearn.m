function results_cpsearn(setNo)

cS = const_cpsearn(setNo);
saveFigures = 1;


%% Diagnostics
if 1
   % Check incwage
   diagnostics_cpsearn.incwage_check(cS.yearV, setNo);
   % Wage stats for fixed age range
   %wage_fixed_age_cpsearn(ageLb, ageUb, sexCode, setNo)
   % Schooling by year
   aggr_cpsearn.school_by_year_show(saveFigures, setNo);
   % Wages
   aggr_cpsearn.wage_by_year_show(saveFigures, setNo);
   % Schooling by cohort
   aggr_cpsearn.cohort_school_show(saveFigures, setNo)
   % Show constructed earnings stats, by age, school, year
   aggr_cpsearn.earn_show(saveFigures, setNo);
   % Show earnings of a given cohort
   % [medianV, meanV, stdV, nObsV] = cohort_earn_direct_cpsearn(bYear, setNo);
end


end