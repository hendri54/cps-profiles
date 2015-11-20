function fig_format(fh, figType)

if nargin < 2
   figType = 'line';
end

figS = const_fig_cpsearn;

figures_lh.format(fh, figType, figS);


end