function fltS = filter_settings(fltNo, cS)
% Filter settings


%% Default settings

% Filter object, no default values
fltS = filterCpsearn;

fltS.dropGq = true;
fltS.dropZeroEarn = true;
fltS.dropNonWageWorkers = true;

fltS.sex = cS.male;

fltS.race = [];

% Age in PREVIOUS year (where earnings observed)
fltS.ageMin = 16;
fltS.ageMax = 75;
% This is age in year of birth
fltS.ageInBirthYear = 1;

% Age boundaries for college premium young / middle aged / old
fltS.ymoAgeRangeM = [25, 34;  35, 44;  45, 54];

% Real annual earning to be counted as working
%  included in mean log wage calc etc
fltS.minRealEarn = 12 * 300;    % +++++

% Count this fraction of bus income
fltS.fracBusInc = 0;

% Min hours worked last week
fltS.hoursMin = 30;
fltS.weeksMin = 30;

% Wages outside of this many times the median are deleted
fltS.wageMinFactor = 0.05;
fltS.wageMaxFactor = 100;


fltS.cpiBaseYear = 2010;



%% Individual filters
if fltNo == cS.fltDefault
   % nothing
   
elseif fltNo == cS.fltExperDefault
   % Ben-Porath experience profiles
   fltS.hoursMin = [];
   fltS.weeksMin = [];
   fltS.ageMax = 70;
   fltS.dropGq = false;
   fltS.dropZeroEarn = false;
   fltS.dropNonWageWorkers = false;
   % Must count this to avoid artificial zeros
   fltS.fracBusInc = 2/3;
   
else
   error('Invalid');
end


fltS.validate;


end