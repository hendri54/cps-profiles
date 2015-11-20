function cpi_load(setNo)
% Load cpi data and save as matrix file
%{
Checked: 2015-Mar-18
%}

cS = const_cpsearn(setNo);
fltS = output_cpsearn.var_load(cS.vFilterSettings, [], setNo);

% Load file with [year, cpi]
dataM = csvread(fullfile(cS.dirS.dataDir, 'cpi_all_urban.txt'));

saveS.yearV = dataM(:,1);
validateattributes(saveS.yearV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>', 1900, ...
   '<', 2020})

saveS.cpiV = dataM(:,2);

% Convert so that base year has cpi of 1
baseIdx = find(saveS.yearV == fltS.cpiBaseYear);
saveS.cpiV = saveS.cpiV ./ saveS.cpiV(baseIdx);

validateattributes(saveS.cpiV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
   'size', [length(saveS.yearV), 1]})

output_cpsearn.var_save(saveS, cS.vCpi, [], setNo);

end