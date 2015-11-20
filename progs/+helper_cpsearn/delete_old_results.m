function delete_old_results(setNo)

dirS = directories_cpsearn(setNo);

inclSubDir = 1;
minAge = 7;
files_lh.delete_files(dirS.outDir, '*.pdf', inclSubDir, minAge, 'yes')

end