function fh = fig_new(saveFigures, figOptS)
% Open a new figure. Perhaps not visible
% ---------------------------------------

if nargin < 2
   figOptS = [];
end
if isempty(figOptS)
   figS = const_fig_cpsearn;
   figOptS = figS.figOptS;
end

visible = (saveFigures == 0);

fh = figures_lh.new(figOptS, visible);


end