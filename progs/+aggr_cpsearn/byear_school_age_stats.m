function outS = byear_school_age_stats(byLbV, byUbV, ageV, setNo)
% Construct stats by birth year, school, age
% from stats by [physical age, school, year]
%{
IN:
 bYear1
    First cohort to keep
 byUbV
    Upper bounds of birth cohorts, integer!
 ageV
    Ages to keep

OUT:
    meanLogWageM(birth year, school, phys age)
    wageExYearEffectsM
       same net of year effects

Checked: 2015-Jul-1
%}

if nargin ~= 4
   error('Invalid nargin');
end

cS = const_cpsearn(setNo);

byUbV = byUbV(:);
byLbV = byLbV(:);

% Lower bounds of birth cohorts
% byLbV = [bYear1; byUbV(1 : end-1) + 1];

% Load stats by [age, school, year]
loadS = output_cpsearn.var_load(cS.vAgeSchoolYearStats, [], setNo);
fltS = output_cpsearn.var_load(cS.vFilterSettings, [], setNo);



%%  Output matrices


outS.ageV = ageV;

nBy = length(byUbV);
nAge = length(ageV);
nu = 2;
sizeV = [nBy, cS.nSchool, ageV(end), nu];

% List of fields to copy
fnV = {'mass', 'nObs', 'wageMedian', 'wageMeanLog', 'earnMedian', 'earnMeanLog', 'weeksMean', 'schoolYrMean'};

srcFieldV = cell(size(fnV));
tgFieldV  = cell(size(fnV));
for iField = 1 : length(fnV)
   srcFieldV{iField} = [fnV{iField}, '_astuM'];
   tgFieldV{iField}  = [fnV{iField}, '_csauM'];   
   outS.(tgFieldV{iField}) = repmat(cS.missVal, sizeV);
end



%% Loop over multi-year birth cohorts
% Average values over all years with data 

for iBy = 1 : nBy
   % Birth years in that cohort
   bYearV = byLbV(iBy) : byUbV(iBy);
         
   % Loop over ages
   for iAge = 1 : nAge
      age1 = ageV(iAge);

      % Index of this age in loadS - just to check that entry exists
      ageIdx = find(loadS.ageV == age1);
      if length(ageIdx) ~= 1
         error('Age not found');
      end
      
      % Year for this birth year / age combination
      yearV = bYearV + age1 - fltS.ageInBirthYear;
      % Only keep years in data range
      yearV(yearV < cS.yearV(1)  |  yearV > cS.yearV(end)) = [];
         
      if ~isempty(yearV)  &&  ~isempty(ageIdx)
         % Indices into matrices by year
         yrIdxV = yearV - cS.yearV(1) + 1;

         % Loop over fields to copy
         for iField = 1 : length(fnV)
            for iu = 1 : nu
               for iSchool = 1 : cS.nSchool
                  % Source data by school; all years for that cohort
                  src_sV = loadS.(srcFieldV{iField})(age1, iSchool, yrIdxV, iu);
                  % Find non-missing values
                  vIdxV = find(src_sV(:) ~= cS.missVal);
                  if ~isempty(vIdxV)
                     if strcmp(fnV{iField}, 'nObs')
                        % No of obs are summed, not averaged
                        outValue = sum(src_sV(vIdxV));
                     else
                        outValue = mean(src_sV(vIdxV));
                     end
                     outS.(tgFieldV{iField})(iBy, iSchool, age1, iu)  =  outValue;
                  end
               end
            end
         end % field
      end % 
   end % age
end


%% Self-test
for iField = length(tgFieldV)
   validateattributes(outS.(tgFieldV{iField}), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', sizeV})
end


end