function saveS = cohort_earn_profiles(profS, setNo)
% Make, save, show cohort earnings profiles
%{
For log median wages and mean log wages
For cohorts used in model and for all cohorts
%}

% cS = const_cpsearn(setNo);
% profS = profiles_cpsearn.settings(profNo);
saveFigures = 1;


% Estimate earnings regressions, using median and mean log
regrV = profiles_cpsearn.regr_earn_age_year(profS, setNo);
profiles_cpsearn.regr_earn_age_year_show(regrV, profS, saveFigures, setNo);

% Make and save cohort profiles
saveS = profiles_cpsearn.cohort_earn_profiles_make(regrV, profS, setNo);
output_cpsearn.var_save(saveS, profS.vCohortEarnProfiles, [], setNo);

% Show them
profiles_cpsearn.cohort_earn_profiles_show(saveS, profS, saveFigures, setNo);

% Show time path of present values of lifetime earnings
profiles_cpsearn.cohort_pvearn_show(saveS, profS, saveFigures, setNo);

end