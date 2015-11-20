function preamble_cpsearn(setNo)

cS = const_cpsearn(setNo);
fltS = output_cpsearn.var_load(cS.vFilterSettings, [], setNo);

dataFn = output_cpsearn.var_fn(cS.vPreambleData, [], setNo);
preamble_lh.initialize(dataFn, fullfile(cS.dirS.outDir, 'preamble.tex'));

add_field('cpsAgeMin',  sprintf('%i', fltS.ageMin), 'Earliest data age', cS);
add_field('cpsAgeMax',  sprintf('%i', fltS.ageMax), 'Latest data age', cS);
add_field('cpsYearFirst',  sprintf('%i', cS.yearV(1)), 'First data year', cS);
add_field('cpsYearLast',  sprintf('%i', cS.yearV(end)), 'Last data year', cS);

% outStr = string_lh.string_from_vector(fltS.ageWorkStart_sV, '%i');
% add_field('cpsAgeWorkStartV',  outStr, 'Work start age by school', cS);
% add_field('cpsAgeWorkLast',  sprintf('%i', fltS.ageWorkLast), 'Last work age', cS);
% % improve: separate field +++
% add_field('cpsAgeOne',  sprintf('%i', fltS.ageWorkStart_sV(1)),  'Discount to this age', cS);

add_field('cpsWageMinFactor',  sprintf('%.2f', fltS.wageMinFactor),  'Multiple of median', cS);
add_field('cpsWageMaxFactor',  sprintf('%0f',  fltS.wageMaxFactor),  'Multiple of median', cS);

add_field('cpsAggrAgeRange', sprintf('%i-%i', cS.aggrAgeRangeV([1, end])), 'Age range for aggregates', cS);
add_field('cpsCpiBaseYear',  sprintf('%i', fltS.cpiBaseYear), 'cpi base year', cS);

% ****  filter

add_field('cpsHoursMin', sprintf('%i', fltS.hoursMin), 'Min hours per week', cS);
add_field('cpsWeeksMin', sprintf('%i', fltS.weeksMin), 'Min weeks per year', cS);

texFn = preamble_lh.write_tex(dataFn);
type(texFn);


end


function add_field(fieldName, commandStr, commentStr, cS)

dataFn = output_cpsearn.var_fn(cS.vPreambleData, [], cS.setNo);
preamble_lh.add_field(fieldName, commandStr, dataFn, commentStr);

end