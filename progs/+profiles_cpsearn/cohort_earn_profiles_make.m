function saveS = cohort_earn_profiles_make(loadV, profS, setNo)
% Construct cohort log earnings profiles
%{
Start with means by [age, school, cohort]
Fit a quartic to each
Extend using the common age profile estimated for all cohorts (given s)

Compute present value of lifetime earnings by [s, c]
%}

cS = const_cpsearn(setNo);
nCohorts = length(profS.bYearV);

%% Load

% Raw earnings
byAgeV = profS.ageWorkStart_sV(1) : profS.ageWorkLast;
byS = aggr_cpsearn.byear_school_age_stats(profS.bYearLbV, profS.bYearUbV, byAgeV, setNo);

if profS.wageConcept == cS.iEarnLogMedian
   rawEarn_csaM = log_lh(byS.earnMedian_csauM(:,:,:,profS.iUniverse), cS.missVal);  
elseif profS.wageConcept == cS.iEarnMeanLog
   rawEarn_csaM = byS.earnMeanLog_csauM(:,:,:,profS.iUniverse);
elseif profS.wageConcept == cS.iWageLogMedian
   rawEarn_csaM = log_lh(byS.wageMedian_csauM(:,:,:,profS.iUniverse), cS.missVal);  
elseif profS.wageConcept == cS.iWageMeanLog
   rawEarn_csaM = byS.wageMeanLog_csauM(:,:,:,profS.iUniverse);
else
   error('Invalid');
end

% Run wage regressions
if isempty(loadV)
   loadV = profiles_cpsearn.regr_earn_age_year(profS, setNo);
end



%% Make cohort profiles

saveS.bYearV = profS.bYearV;
saveS.logEarn_ascM = repmat(cS.missVal, [profS.ageWorkLast, cS.nSchool, nCohorts]);
% Raw data; no smoothing or interpolation
saveS.logRawEarn_ascM = repmat(cS.missVal, [profS.ageWorkLast, cS.nSchool, nCohorts]);

for iSchool = 1 : cS.nSchool
   regrS = loadV{iSchool};
   % Ages to fill for this school group
   sAgeV = (profS.ageWorkStart_sV(iSchool) : profS.ageWorkLast)';
   
   % Regression profile by sAgeV
   idxV = sAgeV - regrS.ageValueV(1) + 1;
   if ~isequal(sAgeV, regrS.ageValueV(idxV))
      error('Invalid');
   end
   regrEarnV = regrS.ageDummyV(idxV);
   %  Values can be NaN towards the end
   %  In that case: set to last non-nan value
   regrEarnV = vectorLH.extrapolate(regrEarnV, cS.dbg);
   validateattributes(regrEarnV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   
   for iCohort = 1 : nCohorts
      % Raw earnings data (by sAgeV)
      rawEarnV = rawEarn_csaM(iCohort, iSchool, sAgeV);
      rawEarnV = rawEarnV(:);
      saveS.logRawEarn_ascM(sAgeV, iSchool, iCohort) = rawEarnV;
      
      % Which ages have data?
      rawIdxV = find(rawEarnV ~= cS.missVal);
      
      % Smooth ages with data
      smoothEarnV = smooth(rawIdxV, rawEarnV(rawIdxV), 'lowess');
      validateattributes(smoothEarnV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         'size', [length(rawIdxV), 1]})
      
      % Interpolate missing values that are interior, if needed
      if ~isequal(rawIdxV(:), (rawIdxV(1) : rawIdxV(end))')
         smoothEarnV = interp1(rawIdxV, smoothEarnV, (rawIdxV(1) : rawIdxV(end)), 'linear');
         rawIdxV = rawIdxV(1) : rawIdxV(end);
      end
         
      logEarnV = nan(size(sAgeV));
      logEarnV(rawIdxV) = smoothEarnV;
      
      % Extrapolate
      logEarnV = vector_lh.splice(logEarnV, regrEarnV, 5, cS.dbg);
      
      if cS.dbg > 10
         validateattributes(logEarnV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
            'size', size(sAgeV)})
      end
      
      % Save the smoothed actual data
      saveS.logEarn_ascM(sAgeV,iSchool,iCohort) = logEarnV;
   end
end

validateattributes(saveS.logEarn_ascM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
   'size', [profS.ageWorkLast, cS.nSchool, nCohorts]})



%% Present value of lifetime earnings
% Discounted to work start of lowest school group

saveS.pvEarn_scM = nan([cS.nSchool, nCohorts]);
% Discount to this age
age1 = profS.ageWorkStart_sV(1);
% Interest rate
R = profS.R;
discFactorV = (1/R) .^ (0 : (profS.ageWorkLast - age1))';

for iCohort = 1 : nCohorts
   for iSchool = 1 : cS.nSchool
      % Earnings by phys age
      earnV = zeros([profS.ageWorkLast, 1]);
      workAgeV = profS.ageWorkStart_sV(iSchool) : profS.ageWorkLast;
      earnV(workAgeV) = exp(saveS.logEarn_ascM(workAgeV, iSchool, iCohort));
      validateattributes(earnV(workAgeV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
      % Present value, discounted to age1
      saveS.pvEarn_scM(iSchool, iCohort) = sum(earnV(age1 : profS.ageWorkLast) .* discFactorV);
   end
end




end