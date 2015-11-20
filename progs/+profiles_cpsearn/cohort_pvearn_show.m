function cohort_pvearn_show(loadS, profS, saveFigures, setNo)
%{
change: control plot names
%}

cS = const_cpsearn(setNo);
% figS = const_fig_bc1;



%% Levels  and  premium relative to HSG
% Also indicate cohorts used in model
if 1
   yLabelStrV = {'Log present value',  'Lifetime earnings premium'};
   figNameV = {'cohort_pv_lty_',  'cohort_lty_premium_'};
   iSchoolV = cS.iCD : cS.nSchool;
   
   logPvEarn_scM = log_lh(loadS.pvEarn_scM, cS.missVal);
   
   for iPlot = 1 : 2
      data_cvM = logPvEarn_scM(iSchoolV, :)';
      if iPlot == 2
         % Relative to HSG
         data_cvM = data_cvM - logPvEarn_scM(cS.iHSG, :)' * ones([1, size(data_cvM, 2)]);
      end

      for iCase = 1 : 2
         fh = output_cpsearn.plot_by_cohort(loadS.bYearV, profS.bYearV(profS.byShowIdxV), ...
            data_cvM,  saveFigures);            
      end
      
      ylabel(yLabelStrV{iPlot});
      legend(cS.sLabelV(iSchoolV), 'location', 'northwest');
      output_cpsearn.fig_format(fh, 'line');
      output_cpsearn.fig_save([profS.prefixStr, figNameV{iPlot}], saveFigures, [], setNo);
   end
end




end