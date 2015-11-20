function run_all_cpsearn(setNo)
% run everything in sequence
%{
Before this can be run: must create file with settings that depend on project
   cS.vFilterSettings
%}
% ----------------------------------

cS = const_cpsearn(setNo);
yearV = cS.yearV;
saveFigures = 1;



% External variable: unemployment rate
% unempl_rate_cpsearn(saveFigures, setNo);


%% Prepare to run
if 0
   % This is done by the calling project before anything is run
   % This is an example
   if 0
      warning('This must be disabled, except for testing');
      keyboard;
      % Filter for sample selection
      fltS = import_cpsearn.filter_settings(cS.fltDefault, cS);
      fltS.validate;
      output_cpsearn.var_save(fltS, cS.vFilterSettings, [], setNo);

      % Settings for wage profiles
      profS = profiles_cpsearn.settings([]);
      output_cpsearn.var_save(profS, cS.vProfileSettings, [], setNo);
   end
   
   
   % Make dir for new experiment
   helper_cpsearn.mkdir(setNo);
   var_cpsearn.cpi_load(setNo);   
   %return;
end



%% Get cps data

% ****  Import cps variables
if 01
   for year1 = yearV(:)'
      % Filter 
      import_cpsearn.filter(year1, setNo);

      % Import
      import_cpsearn.import(year1, setNo);
   end
   %return;
end


% ****  Create derived individual variables
   
if 01
   for year1 = yearV(:)'
      var_cpsearn.school_create(year1, setNo);   
   end
   
   % Make wage (2 versions: including zeros/outliers or excluding them)
   var_cpsearn.wage_create(yearV, setNo);
   diagnostics_cpsearn.data_report(yearV, setNo);
   %return;
end % for year1


%%  Summary variables

% Stats by [age, school, year, universe]
aggr_cpsearn.age_school_year_stats(setNo);
% Can make stats by birth year with 
%  aggr_cpsearn.byear_school_age_stats

% Time series of aggregate stats
aggr_cpsearn.aggr_stats(setNo);


%% Earnings profiles

% Profile settings
%  Can run profiles with multiple settings
profS = output_cpsearn.var_load(cS.vProfileSettings, [], setNo);

% Make profiles + show them
profiles_cpsearn.cohort_earn_profiles(profS, setNo);


% Write preamble for paper
preamble_cpsearn(setNo);


%%  Diagnostics and results

results_cpsearn(setNo);



end