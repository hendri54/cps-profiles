function outV = regr_earn_age_year(profS, setNo)
% Regress log earnings on age and year dummies
%{
Dummies can be NaN when not enough observations
Especially for older workers

IN
   profS
      created by settings.m
      settings for earnings profiles

OUT
   outV{iSchool}
      regression results by school group

general purpose fct: regress something on age / year / cohort dummies +++++
%}


%% Settings

fprintf('\nRegressing (log or median) earnings on age and year dummies\n\n');

cS = const_cpsearn(setNo);
% profS = profiles_cpsearn.settings(setNo);

% Min no of obs per [cohort, school] cell
minObs = 25;
ny = length(cS.yearV);

% Load mean log earnings by [age, school, year]
loadS = output_cpsearn.var_load(cS.vAgeSchoolYearStats, [], setNo);


%% Regressions
% Median and mean log earnings

if profS.wageConcept == cS.iEarnLogMedian
   logEarn_astM = log_lh(loadS.earnMedian_astuM(:, :, :, profS.iUniverse), cS.missVal);
elseif profS.wageConcept == cS.iEarnMeanLog;
   logEarn_astM = loadS.earnMeanLog_astuM(:, :, :, profS.iUniverse);
elseif profS.wageConcept == cS.iWageLogMedian
   logEarn_astM = log_lh(loadS.wageMedian_astuM(:, :, :, profS.iUniverse), cS.missVal);
elseif profS.wageConcept == cS.iWageMeanLog;
   logEarn_astM = loadS.wageMeanLog_astuM(:, :, :, profS.iUniverse);
else
   error('Invalid');
end
nObs_astM = loadS.nObs_astuM(:,:,:,profS.iUniverse);

outV = cell([cS.nSchool, 1]);

for iSchool = 1 : cS.nSchool
   fprintf('\nSchool level %s \n', cS.sLabelV{iSchool});
   regrS.iSchool = iSchool;

   % Age range to use (add some years b/c the last dummies turn out NaN -- why?)
   ageV = (profS.ageWorkStart_sV(iSchool) - 1) : (profS.ageWorkLast + 2);
   nAge = length(ageV);


   % *** Construct regressors

   % Mean log or median earnings
   logEarn_atM = squeeze(logEarn_astM(ageV, iSchool, :));
   nObs_atM = squeeze(nObs_astM(ageV, iSchool, :));

   age_atM = ageV(:) * ones([1, ny]);
   if ~isequal(size(age_atM), size(logEarn_atM))
      error('Invalid');
   end

   year_atM = ones([nAge,1]) * cS.yearV(:)';
   if ~isequal(size(age_atM), size(year_atM))
      error('Invalid');
   end

   % Valid observations
   valid_atM = (logEarn_atM ~= cS.missVal)  &  (nObs_atM >= minObs);

   vIdxV = find(valid_atM == 1);
   fprintf('  No of observations: %i \n',  length(vIdxV));
   if length(vIdxV) < 50
      error('Too few obs');
   end

   % **** Linear model

   mdl = fitlm([age_atM(vIdxV), year_atM(vIdxV)], logEarn_atM(vIdxV), ...
      'CategoricalVars', [1 2], 'Weights', sqrt(nObs_atM(vIdxV)));

   % Extract age and year coefficients
   %  Meaningless scales
   regrS.ageValueV = ageV(:);
   regrS.ageDummyV = feval(mdl, [regrS.ageValueV(:), 2000 .* ones([nAge,1])]);
   regrS.yearValueV = cS.yearV(:);
   regrS.yearDummyV = feval(mdl, [50 .* ones([ny,1]), regrS.yearValueV]);

   outV{iSchool} = regrS;
end



end