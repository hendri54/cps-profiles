function school_by_year_show(saveFigures, setNo)
% Show stats for schooling by year
% ---------------------------------------

cS = const_cpsearn(setNo);
ny = length(cS.yearV);

% Stats: school by year for a particular age range
[avgSchoolV, fracM] = aggr_cpsearn.school_by_year(setNo);

output_cpsearn.fig_new(saveFigures, []);
fh = plot(cS.yearV, avgSchoolV, 'ro');
xlabel('Year');
ylabel('Avg years of school');
output_cpsearn.fig_format(fh, 'line');

output_cpsearn.fig_save('school_avg_by_year', saveFigures, [], setNo);


% *******  Fractions

output_cpsearn.fig_new(saveFigures, []);
fh = plot(cS.yearV, fracM, '-');
xlabel('Year');
ylabel('Fraction by school class');
legend(cS.sLabelV, 'Location', 'southeast');
output_cpsearn.fig_format(fh, 'line');

output_cpsearn.fig_save('school_class_by_year', saveFigures, [], setNo);


end