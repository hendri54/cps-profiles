function cohort_earn_profiles_show(loadS, profS, saveFigures, setNo)
% Show cohort earnings profiles
%{
%}

cS = const_cpsearn(setNo);
figS = const_fig_cpsearn;
figOptS = figS.figOpt4S;

prefixStr = profS.wageConceptStr;


% Show selected cohorts
for iCohort = profS.byShowIdxV(:)'
   fh = output_cpsearn.fig_new(saveFigures, figOptS);
   
   for iSchool = 1 : cS.nSchool
      subplot(2,2,iSchool);
      hold on;
      
      % Complete profile
      iLine = 1;
      logEarnV = loadS.logEarn_ascM(:, iSchool, iCohort);
      idxV = find(logEarnV ~= cS.missVal);
      plot(idxV, logEarnV(idxV), figS.lineStyleDenseV{iLine}, 'color', figS.colorM(iLine,:));
      
      % Raw data
      iLine = iLine + 1;
      logEarnV = loadS.logRawEarn_ascM(:, iSchool, iCohort);
      idxV = find(logEarnV ~= cS.missVal);
      plot(idxV, logEarnV(idxV), 'o', 'color', figS.colorM(iLine,:));
      
      hold off;
      xlabel('Age');
      ylabel([prefixStr, ' earnings']);
      output_cpsearn.fig_format(fh, 'line');
   end
   
   output_cpsearn.save_fig([profS.prefixStr, sprintf('earn_profile_%s_coh%i', prefixStr, profS.bYearV(iCohort))], ...
      saveFigures, figOptS, setNo);
end


end