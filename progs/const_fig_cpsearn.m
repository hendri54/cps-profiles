function cS = const_fig_cpsearn
% Figure options
% --------------------------------

fileFormat = 'pdf';

% % Figure types
% cS.default = 1;
% cS.bar = 2;
% cS.type3d = 3;


% Slide output?
cS.slideOutput = false;



%% Fonts

if cS.slideOutput
   fontSizeFactor = 1.35;
else
   fontSizeFactor = 1;
end

% Font size for legend, xlabels, axes
cS.figFontSize = 10 * fontSizeFactor;
cS.figFontName = 'Times';
cS.legendFontSize = 10 * fontSizeFactor;
% Font size for latex must be a little larger
cS.latexFontSize = 12 * fontSizeFactor;


%% Figure options / sizes

% Sizes must be consistent with what's used in the paper. Otherwise fonts
% get scaled
figHeight = 4; % inches
figWidth  = 4;
if strcmpi(fileFormat, 'pdf')
   % Extension
   cS.figExt = '.pdf';
   cS.figOptS = struct('height', figHeight, 'width', figWidth, 'color', 'rgb', 'Format', 'pdf', ...
      'FontSize', 1 * fontSizeFactor, 'FontMode', 'scaled');
elseif strcmpi(fileFormat, 'eps')
   % Extension
   cS.figExt = '.eps';
   cS.figOptS = struct('preview', 'tiff', 'height', figWidth, 'width', figWidth, 'color', 'rgb', 'Format', 'eps', ...
      'FontSize', 1 * fontSizeFactor, 'FontMode', 'scaled');   
else
   error('Invalid');
end

% Always save FIG file with underlying data
cS.figOptS.saveFigFile = 1;

% 2 plots side-by-side
cS.figOpt2S = cS.figOptS;
cS.figOpt2S.height = figHeight;
cS.figOpt2S.width  = 2 * figWidth;
% 4 panel
cS.figOpt4S = cS.figOpt2S;
cS.figOpt4S.height = 2 * figHeight;
cS.figOpt4S.width  = 2 * figWidth;
cS.figOpt6S = cS.figOpt4S;
cS.figOpt6S.height = 3 * figHeight;
% Quarter size figure (4 panels or 2 side-by-side)
cS.figOptQuarterS = cS.figOptS;
% Keep sizes the same no matter how figs are displayed
%cS.figOptQuarterS.height = cS.figOptS.height * 0.7;
%cS.figOptQuarterS.width  = cS.figOptS.width  * 0.7;



%% Colors

cS.colorV = 'kbrgcmkbrgcm';

% Set default colors muted
xV = 0.2 : 0.15 : 0.96;
ncol = length(xV);
cS.colorM = zeros([2 * ncol, 3]);
for ix = 1 : length(xV)
   x = xV(ix);
   cS.colorM(ix,:) = [1-x, 0.4, x];
   cS.colorM(ncol + ix, :) = [1-x, x, 0.4];
end

% Color map
cS.colorMap = 'copper';
% This is a matrix. Each line is a color
% cS.colorMap = colormap('copper');
% cS.colorMap = cS.colorMap(5:end, :);


%% Lines

cS.lineWidth = 1.5;

% Markers for non-connected plots
cS.markerV = 'odx+*sd^vphodx+*sd^vph';
cS.lineTypeV = {'-', '--', '-.', '-', '--', '-.', '-', '--', '-.', '-', '--', '-.', '-', '--', '-.', '-', '--', '-.', '-', '--', '-.'};

% Line styles when many points are used
cS.lineStyleDenseV = cS.lineTypeV;     % cell([1,n]);

% Line styles when few points are used
n = length(cS.lineTypeV);
cS.lineStyleV = cell([1,n]);
for i1 = 1 : n
   cS.lineStyleV{i1} = [cS.markerV(i1), cS.lineTypeV{i1}];
   %cS.lineStyleDenseV{i1} = cS.lineTypeV{i1};
end



%% Bar graphs

cS.barWidth = 1;



%% Notation and labels

cS.iqGroupStr = 'Ability';
cS.ypGroupStr = 'Family background';

cS.cohortXLabelStr = 'Cohort';


end