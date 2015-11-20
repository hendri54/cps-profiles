function wage_by_year_show(saveFigures, setNo)
% Show stats for wages by year
% ---------------------------------------

cS = const_cpsearn(setNo);
figS = const_fig_cpsearn;

% No wage data for last year
ny = length(cS.yearV);
yearV = cS.yearV;
% Universe: workers (b/c mean log)
iu = cS.iWorkers;

loadS = output_cpsearn.var_load(cS.vAggrStats, [], setNo);
logWage_stM = loadS.wageMeanLog_stuM(:,:, iu);


%% Levels
if 1
   fh = output_cpsearn.fig_new(saveFigures, []);
   hold on;
   for iSchool = 1 : cS.nSchool
      yV = logWage_stM(iSchool, :)';
      yV = yV(:);
      idxV = find(yV ~= cS.missVal);
      plot(yearV(idxV), yV(idxV), figS.lineStyleDenseV{iSchool}, 'color', figS.colorM(iSchool,:));
   end
   xlabel('Year');
   ylabel('Mean log wage');
   legend(cS.sLabelV, 'Location', 'southwest');
   output_cpsearn.fig_format(fh, 'line');
   figFn = 'wage_meanlog_by_year';
   output_cpsearn.fig_save(figFn, saveFigures, [], setNo);
end



%% Relative to college
if 1
   fh = output_cpsearn.fig_new(saveFigures, []);
   hold on;
   for iSchool =  1 : cS.nSchool
      yV = logWage_stM(iSchool, :)';
      yV = yV(:);
      idxV = find(yV ~= cS.missVal);
      plot(yearV(idxV), yV(idxV) - logWage_stM(cS.iHSG,idxV)', ...
         figS.lineStyleDenseV{iSchool}, 'color', figS.colorM(iSchool,:));
   end
   hold off;
   xlabel('Year');
   ylabel('Mean log wage relative to HSG');
   legend(cS.sLabelV, 'Location', 'northwest')
   output_cpsearn.fig_format(fh, 'line');

   figFn = 'wageprem_by_year';
   output_cpsearn.fig_save(figFn, saveFigures, [], setNo);
end


end