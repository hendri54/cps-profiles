function incwage_check_cpsearn(yearV, setNo)
% Check incwage for top coded values that are missed
% ---------------------------------------------------

cS = const_cpsearn(setNo);

for iy = 1 : length(yearV)
   year1 = yearV(iy);
   wV = output_cpsearn.var_load(cS.vIncWage, year1, setNo);
   
   wMax = max(wV);
   fprintf('%i:  Max: %8.1f  occurs %3i times \n',  ...
      year1, wMax, length(find(wV == wMax)));
   
   % Show highest values
   if wMax > 49000
      valueV = unique(wV(wV > 49000));
      nv = length(valueV);
      for i1 = 1 : min(10, nv)
         value1 = valueV(nv + 1 - i1);
         fprintf('  %8.1f  %i \n',  value1,  length(find(wV == value1)));
      end
   end
end


end