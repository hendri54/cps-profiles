function fracM = cohort_school(bYearV, ageV, setNo)
% Compute fraction by [birth year, school level]
% ----------------------------------------------

cS = const_cpsearn(setNo);
iu = cS.iAll;

byLbV = bYearV(:);
byUbV = bYearV(:);

% Mass by [by, school, phys age]
outS = aggr_cpsearn.byear_school_age_stats(byLbV, byUbV, ageV, setNo);

fracM = zeros([length(byUbV), cS.nSchool]);

for iBy = 1 : length(byUbV)
   % Mass by [school, age]
   massM = squeeze(outS.mass_csauM(iBy, :, ageV, iu));
   
   % Sum over all ages with data
   massV = zeros([cS.nSchool, 1]);
   for iAge = 1 : length(ageV)
      if min(massM(:, iAge)) > 0
         massV = massV + massM(:, iAge);
      end
   end
   
   % Data for any age?
   if massV(1) > 0
      fracM(iBy, :) = massV ./ sum(massV);
   end
end

validateattributes(fracM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})

end