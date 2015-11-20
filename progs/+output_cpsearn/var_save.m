function var_save(outV, varNo, year1, setNo)
% Save a MAT variable
% ----------------------------------------------

[fn, ~, fDir] = output_cpsearn.var_fn(varNo, year1, setNo);

% Create dir if it does not exist
if ~exist(fDir, 'dir')
   files_lh.mkdir_lh(fDir, 0);
end

save(fn, 'outV');
fprintf('Saved variable %i  for year %i, set %i \n',  varNo, year1, setNo);

end