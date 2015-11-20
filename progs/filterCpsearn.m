classdef filterCpsearn < handle
% Determines how individuals are filtered out
%{
%}

properties
   % Drop people in group quarters?
   dropGq
   dropZeroEarn
   dropNonWageWorkers
   
   % cS.male, cS.female
   sex
   % cS.raceWhite, ...
   race

   % Age in PREVIOUS year (where earnings observed)
   ageMin
   ageMax
   % How to compute age? In year of birth, person is of this age
   ageInBirthYear
   % Age range for college premium by [young, middle age, old]
   ymoAgeRangeM

   % Real annual earning to be counted as working
   %  included in mean log wage calc etc
   minRealEarn

   % Count this fraction of bus income
   fracBusInc

   % Min hours worked last week
   hoursMin
   weeksMin

   % Wages outside of this many times the median are deleted
   wageMinFactor
   wageMaxFactor
   
   cpiBaseYear

end



methods
   %% Constructor
   function fltS = filterCpsearn
      fltS.ageInBirthYear = 1;
   end
   
   %% Validate
   function validate(fltS)
      % Boolean
      nameV = {'dropGq', 'dropZeroEarn', 'dropNonWageWorkers'};
      for i1 = 1 : length(nameV)
         x = fltS.(nameV{i1});
         if ~isa(x, 'logical')
            error('Invalid boolean field');
         end
      end
      
      % Positive scalar integers, but may be []
      nameV = {'sex', 'race', 'ageMin', 'ageMax', 'hoursMin', 'weeksMin'};
      for i1 = 1 : length(nameV)
         x = fltS.(nameV{i1});
         if ~isempty(x)
            validateattributes(x, {'double'}, ...
               {'finite', 'nonnan', 'nonempty', 'integer', 'positive', 'scalar'})
         end
      end

      % Positive scalars, cannot be []
      nameV = {'wageMinFactor', 'wageMaxFactor', 'cpiBaseYear'};
      for i1 = 1 : length(nameV)
         x = fltS.(nameV{i1});
         validateattributes(x, {'double'}, ...
            {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
      end
      
      validateattributes(fltS.ymoAgeRangeM, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
         'size', [3, 2]})
   end
   
end
   
   
end