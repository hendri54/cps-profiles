function profS = settings(profileStr)
% For constructing earnings profiles
%{
IN
   profNo
      determines settings
%}

cS = const_cpsearn([]);

if isempty(profileStr)
   profileStr = 'default';
end


%% Defaults

% Start early, just in case
profS.ageWorkStart_sV = [17, 18, 20, 22] + 1;

profS.ageWorkLast = 65;

profS.wageConcept = cS.iEarnLogMedian;
% Only use workers or everyone
profS.iUniverse = cS.iWorkers;

% Construct profiles for these years
profS.bYearV = 1940 : 1970;
profS.bYearLbV = profS.bYearV;
profS.bYearUbV = profS.bYearV;

profS.byShowIdxV = [];

% Profile prefix, for file names
profS.prefixStr = 'test_';

% Gross interest rate, for present value of lifetime earnings
profS.R = 1.04;


% ********  Variable names to be saved

% Cohort earnings profiles (constant dollars)
profS.vCohortEarnProfiles = cS.vCohortEarnProfilesMedian;


%%  Individual sets


if strcmpi(profileStr, 'default')
   profS.profStr = 'Default';
   profS.prefixStr = 'default_';
   
elseif strcmpi(profileStr, 'wageMedian')
   profS.wageConcept = cS.iWageLogMedian;
   profS.profStr = profileStr;
   profS.prefixStr = 'wageMedian_';
   
elseif strcmpi(profileStr, 'exper')
   % Ben-Porath experience profiles
   profS.profStr = 'BP';
   profS.prefixStr = 'exper_';
   profS.bYearV = 1920 : 1980;
   profS.bYearLbV = profS.bYearV;
   profS.bYearUbV = profS.bYearV;
   profS.wageConcept = cS.iWageLogMedian;
   % Only use workers or everyone
   profS.iUniverse = cS.iAll;
   
else
   error('Invalid');
end


%%  Derived

if isempty(profS.byShowIdxV)
   % Show profiles for these cohorts
   profS.byShowIdxV = round(linspace(1, length(profS.bYearV), 3));
end

if (profS.iUniverse == cS.iAll)  &&  (profS.wageConcept == cS.iEarnMeanLog)
   error('These do not go together');
end

if any(profS.wageConcept == [cS.iEarnLogMedian, cS.iWageLogMedian])
   profS.wageConceptStr = 'Median';    
elseif any(profS.wageConcept == [cS.iEarnMeanLog, cS.iWageMeanLog])
   profS.wageConceptStr = 'MeanLog';
else
   error('Invalid');
end

if any(profS.wageConcept == [cS.iEarnLogMedian, cS.iEarnMeanLog])
   profS.wageEarnStr = 'Earnings';
else
   profS.wageEarnStr = 'Wages';
end



end