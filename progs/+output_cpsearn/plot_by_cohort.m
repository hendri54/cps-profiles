function fh = plot_by_cohort(bYearV, bYearHighlightV, data_cvM, saveFigures)
% Plot a data matrix by cohort
%{
Each column is a variable

Cohorts are shown by year of HS graduaton
%}

figS = const_fig_cpsearn;
nCohorts = length(bYearV);

fh = output_cpsearn.fig_new(saveFigures, []);
hold on;

for iCase = 1 : 2
   if iCase == 1
      % All cohorts as a line
      plotIdxV = 1 : nCohorts;
      lineStyleV = figS.lineStyleDenseV;
   else
      % Model cohorts as dots
      plotIdxV = zeros(size(bYearHighlightV));
      for ic = 1 : length(bYearHighlightV)
         [~, plotIdxV(ic)] = min(abs(bYearV - bYearHighlightV(ic)));
      end
      lineStyleV = repmat({'o'}, size(figS.lineStyleDenseV));
   end

   for iLine = 1 : size(data_cvM, 2)
      plot(bYearV(plotIdxV), data_cvM(plotIdxV, iLine),  lineStyleV{iLine}, 'Color', figS.colorM(iLine,:));
   end
end

hold off;
xlabel('Cohort');

   
end