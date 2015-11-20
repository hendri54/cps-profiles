function mkdir(setNo)
% Make dirs for a new experiment
% -----------------------------------

dirS = directories_cpsearn(setNo);

dirListV = {dirS.matDir, dirS.outDir, dirS.figDir, dirS.tbDir};

for i1 = 1 : length(dirListV)
   if ~exist(dirListV{i1}, 'dir')
      files_lh.mkdir_lh(dirListV{i1}, 0);
   end
end

end