function fig_save(figFn, saveFigures, figOptInS, setNo)
% IN:
%  figFn
%     Do NOT include path
% ---------------------------------------------

cS = const_cpsearn(setNo);
figDir = cS.dirS.figDir;

if isempty(figOptInS)
   figS = const_fig_cpsearn;
   figOptS = figS.figOptS;
else
   figOptS = figOptInS;
end

% Create fig dir if necessary
if ~exist(figDir, 'dir')
   files_lh.mkdir_lh(figDir);
end

figOptS.figDir = fullfile(figDir, 'figdata');
if ~exist(figOptS.figDir, 'dir')
   files_lh.mkdir_lh(figOptS.figDir);
end

figures_lh.fig_save_lh(fullfile(figDir, figFn), saveFigures, 0, figOptS);

end