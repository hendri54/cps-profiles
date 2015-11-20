function byear_school_age_stats_test(setNo)

fprintf('Testing byear_school_age_stats \n');

cS = const_cpsearn(setNo);

% Load stats by [age, school, year]
loadS = output_cpsearn.var_load(cS.vAgeSchoolYearStats, [], setNo);
iu = 1;
iSchool = 2;

% Make stats by birth year from this
byLbV = 1940 : 1960;
byUbV = byLbV;
ageV = 30 : 50;

outS = aggr_cpsearn.byear_school_age_stats(byLbV, byUbV, ageV, setNo);


% Using generic function, test match

in_atM = squeeze(loadS.wageMedian_astuM(ageV,iSchool,:,iu));
in_caM = squeeze(outS.wageMedian_csauM(:, iSchool, ageV, iu));

ageFirstYear = 1;
out_atM = econ_lh.age_year_from_cohort_age(in_caM, ageV, loadS.yearV, byLbV, ageFirstYear, cS.missVal, cS.dbg);
check_lh.approx_equal(in_atM, out_atM, 1e-5, []);

out_caM = econ_lh.cohort_age_from_age_year(in_atM, ageV, loadS.yearV, byLbV, ageFirstYear, cS.missVal, cS.dbg);
check_lh.approx_equal(in_caM, out_caM, 1e-5, []);


end