function cS = const_cpsearn(setNo)
% Returns values of constants
%{
Anything that is project specific must go into filterCpsearn

Order of variables: [age, school, year, universe]
                    [a, s, t, u]

IN
   setNo
      []: use default
          mainly useful for retrieving items that do not depend on setNo
%}
% -----------------------------------------

% Globally shared constants
cS = const_lh;

cS.setDefault = 1;
cS.dbg = 111;

if isempty(setNo)
   setNo = cS.setDefault;
end
cS.setNo = setNo;



%% Variable codes

% % Work start ages (for present values)
% cS.ageWorkStart_sV = bcS.ageWorkStart_sV + bcS.age1 - 1;
% % Last year of work to include
% %  Higher yields missing values in age year stats
% cS.ageWorkLast = bcS.physAgeRetire;
% 


%% Constants

% This determines settings for earnings profiles
cS.profileStr = 'default';

% setStr = sprintf('set%03i', setNo);

% Data years
%  but earnings are for previous year
cS.yearV = 1964 : 2010;
% Years with wage data
cS.wageYearV = max(cS.yearV - 1, 1964);

cS.bYearV = 1910 : 2000;

% cS.cpiBaseYear = 2010;

cS.iHSD = 1;
cS.iHSG = 2;
cS.iCD = 3;
cS.iCG = 4;
cS.nSchool = 4;
cS.sLabelV = {'HSD', 'HSG', 'CD', 'CG'};


% Stats are saved for all or those with valid wages
cS.iAll = 1;
cS.iWorkers = 2;



%%  Filter

cS.fltDefault = 1;
cS.fltNo = cS.fltDefault;
% Ben-Porath experience profiles
cS.fltExperDefault = 21;


% ******  Wage regressions

% Which earnings concept to use in wage regressions?
cS.iEarnLogMedian = 23;
cS.iEarnMeanLog = 90;
cS.iWageLogMedian = 44;
cS.iWageMeanLog = 55;

% Age range for aggregate stats (such as years of schooling)
cS.aggrAgeRangeV = 30 : 50;



%% Sets
% They really just determine where things are stored now
% Everything else is in filterCpsearn

cS.setExperDefault = 21;

if setNo == cS.setDefault
   % nothing
   
elseif setNo == cS.setExperDefault
   % Ben-Porath experience profiles
   cS.fltNo = cS.fltExperDefault;
   % This determines settings for earnings profiles
   cS.profileStr = 'default';
   
else
   error('Invalid');
end



%% Derived

cS.dirS = directories_cpsearn(setNo);



%%  Variables

% ***********  Imported cps variables
% varNo 1 to 99, by ind

% CPS variable names
cS.cpsVarNameV = cell([20, 1]);

cS.vWeight = 13;
cS.cpsVarNameV{cS.vWeight} = 'wtsupp';

% Age - in interview year
cS.vAge = 1;
cS.cpsVarNameV{cS.vAge} = 'age';

cS.vSex = 2;
cS.cpsVarNameV{cS.vSex} = 'sex';

cS.vRace = 3;
cS.cpsVarNameV{cS.vRace} = 'race';

%cS.vGQ = 4;
%cS.cpsVarNameV{cS.vGQ} = 'gq';

% Type of employment, not recoded
cS.vClassWkr = 4;
cS.cpsVarNameV{cS.vClassWkr} = 'classwkr';

% Is person in labor force? 1 = yes, 0 = no
cS.vLabForce = -99;
%cS.cpsVarNameV{cS.vLabForce} = 'labforce';

% Is person working? 1 = yes, 0 = no
cS.vEmpStat = -99;
%cS.cpsVarNameV{cS.vEmpStat} = 'empstat';

% Hours per week. No need to recode. 
%  NIU is coded as 0 (in cps)
cS.vHoursWeek = 7;
cS.cpsVarNameV{cS.vHoursWeek} = 'hrswork';

% Weeks per year. Recoded.
%  NIU = 0
cS.vWeeksYear = 8;
cS.cpsVarNameV{cS.vWeeksYear} = 'wkswork2';


% Income: wage and salary
%  saved for year it was reported, not when it was earned
cS.vIncWage = 12;
cS.cpsVarNameV{cS.vIncWage} = 'incwage';
% Business income
cS.vIncBus = 14;
cS.cpsVarNameV{cS.vIncBus} = 'incbus';


% Schooling
cS.vHigrade = 9;
cS.cpsVarNameV{cS.vHigrade} = 'higrade';

cS.vEduc99 = 10;
cS.cpsVarNameV{cS.vEduc99} = 'educ99';

cS.vEduc = 11;
cS.cpsVarNameV{cS.vEduc} = 'educ';


%%  Generated cps variables
% by ind, varNo 101 - 199

cS.vFilter = 101;

% Schooling
% Years of school
cS.vSchoolYears = 102;
% School group: HSD, HSG, CD, CG
cS.vSchoolGroup = 103;


% Income
% Real wage per week. Outliers dropped.
cS.vRealWeeklyWage = 120;

% Is person working (earning more than fixed real annual earnings?)
%  either bus or wage income
% cS.vIsWorking = 121;

% Real annual earnings, incl share of bus income
%  only for those with valid wages
cS.vRealAnnualEarn = 122;

% The same, but for everyone (missing is treated as 0; e.g. not working for pay)
%  Only makes sense if business income is counted
cS.vRealAnnualEarnAll = 123;
cS.vRealWeeklyWageAll = 124;


%%  Summary variables
% No year dim. varNo = 201 : 300

% Wage stats by [age, school, year]
%  Records wages in years they were earned
cS.vAgeSchoolYearStats = 201;

% Regress log earnings on age and year dummies
cS.vEarnRegrAgeYearMedian = 202;
cS.vEarnRegrAgeYearMeanLog = 203;

% Cohort earnings profiles (constant dollars)
cS.vCohortEarnProfilesMedian = 204;
% Mean log profile is conditional on working
cS.vCohortEarnProfilesMeanLog = 205;

% Aggregate stats by year
cS.vAggrStats = 206;

% Preamble data
cS.vPreambleData = 207;

% CPI data
cS.vCpi = 208;

% Contains filter info
cS.vFilterSettings = 209;
% Info for earnings profiles (profiles_cpsearn.settings)
cS.vProfileSettings = 210;

% Year effects from regressing mean log wage on year
% cS.vYearEffects = 202;

% Unemployment rate, wide range of years
% cS.vUnemplRate = 203;


end
