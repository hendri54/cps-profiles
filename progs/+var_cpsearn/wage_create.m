function wage_create(yearV, setNo)
% Create weekly wage, real
%{
Including business income share
Including zeros, but not negatives

2 versions:
- all: including zeros
- workers: only those with valid wages that are not outliers

Checked: 2015-july1
%}

cS = const_cpsearn(setNo);
fltS = output_cpsearn.var_load(cS.vFilterSettings, [], setNo);

% CPI last year, when wages were earned
cpiV = var_cpsearn.cpi(yearV - 1, setNo);

for iy = 1 : length(yearV)
   year1 = yearV(iy);

   % Load ind variables
   % classWkrV = output_cpsearn.var_load(cS.vClassWkr,  year1, setNo);
   incWageV  = output_cpsearn.var_load(cS.vIncWage,   year1, setNo);
   % Business income - can be negative
   incBusV   = output_cpsearn.var_load(cS.vIncBus,    year1, setNo);
   weeksV    = output_cpsearn.var_load(cS.vWeeksYear, year1, setNo);
   wtV       = output_cpsearn.var_load(cS.vWeight, year1, setNo);


   % ****** Statistics that include 0 wages
   % These variable treats missing values as 0 (e.g. not working for pay)
   
   % Mark as invalid: impossible combinations
   invalidV = (weeksV > 0)  &  (incWageV <= 0)  &  (incBusV <= 0)  &  (wtV > 0);
   
   % Earnings = wage income + fraction of business income
   earnV = (max(0, incWageV) + fltS.fracBusInc .* max(0, incBusV)) ./ cpiV(iy);
   earnV(invalidV) = cS.missVal;
   wageV = earnV ./ max(1, weeksV);
   wageV(invalidV) = cS.missVal;
   
   output_cpsearn.var_save(earnV, cS.vRealAnnualEarnAll, year1, setNo);
   output_cpsearn.var_save(wageV, cS.vRealWeeklyWageAll, year1, setNo);
   

   % ******  Exclude wage outliers
   % Treat not working as missing values
   
   % Now mark as invalid those who do not work
   invalidV = (earnV <= 0  |  weeksV <= 0  |  incWageV < 0  |  wtV <= 0);
   % We keep those truly earning 0 (if filter permits this)
   invalidV(earnV == 0   &   weeksV == 0) = false;

   % weekly real wage
   wageV = earnV ./ max(1, weeksV);
   wageV(invalidV) = cS.missVal;
   
   % Compute median weekly wage to drop outliers
   idxV = find(wageV > 0);
   medianWage = distrib_lh.weighted_median(wageV(idxV), wtV(idxV), 1);
   
   wageV(wageV > 0  &  (wageV < fltS.wageMinFactor .* medianWage  |  wageV > fltS.wageMaxFactor .* medianWage)) = cS.missVal;   
   output_cpsearn.var_save(wageV, cS.vRealWeeklyWage, year1, setNo);

   earnV(wageV == cS.missVal) = cS.missVal;
   output_cpsearn.var_save(earnV, cS.vRealAnnualEarn, year1, setNo);
        
%    % Does person earn enough to be counted as working
%    isWorkingV = repmat(cS.missVal, size(weeksV));
%    isWorkingV(idxV) = (earnV(idxV) >= cS.minRealEarn);
%    output_cpsearn.var_save(isWorkingV, cS.vIsWorking, year1, setNo);
  
end

   
end