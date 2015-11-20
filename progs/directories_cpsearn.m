function dirS = directories_cpsearn(setNo)
% Directories

dirS.baseDir = '/Users/lutz/Documents/econ/data/Cps/earn_profiles/';
dirS.progDir = fullfile(dirS.baseDir, 'progs');

setStr = sprintf('set%03i', setNo);

% Matrix files by set
dirS.matDir = fullfile(dirS.baseDir, 'mat', setStr);
% Imported data files by year go here (depend on set)
dirS.matImportDir = fullfile(dirS.matDir, 'import');

% For results
dirS.outDir = fullfile(dirS.baseDir, 'out', setStr);
dirS.figDir = dirS.outDir;
dirS.tbDir  = dirS.outDir;

% Dir for auxiliary data (e.g. cpi)
dirS.dataDir = fullfile(dirS.baseDir, 'data');


end