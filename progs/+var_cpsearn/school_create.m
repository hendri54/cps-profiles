function school_create(year1, setNo)
% Create school variables at individual level
% -------------------------------------------

cS = const_cpsearn(setNo);

if year1 >= 1992
   % Have educ99 (degree attained)
   educ99V = output_cpsearn.var_load(cS.vEduc99, year1, setNo);
   
   schoolClV = educ99_to_degree_cps(educ99V, year1, cS.iHSD, cS.iHSG, cS.iCD, cS.iCG, cS.missVal);
   schoolV   = educ99_to_yrschool_cps(educ99V, year1, cS.missVal);
else
   hiGradeV = output_cpsearn.var_load(cS.vHigrade, year1, setNo);
   schoolClV = higrade_to_degree_cps(hiGradeV, year1, cS.iHSD, cS.iHSG, cS.iCD, cS.iCG, cS.missVal);
   schoolV   = higrade_to_yrschool_cps(hiGradeV, year1, cS.missVal);
end

%       % Use the consistent recode that exists in all years
%       % except 1963
%       [educV, success] = output_cpsearn.var_load(cS.vEduc, year1, setNo);
%       if success ~= 1
%          error('educ should exist');
%       end
% 
% 
%       % ********  School group
% 
%       n = length(educV);
%       schoolClV = repmat(cS.missVal, [n, 1]);
% 
%       schoolClV(educV >= 2  &  educV <= 60) = cS.iHSD;
%       schoolClV(educV >= 70 &  educV <= 73) = cS.iHSG;
%       schoolClV(educV >= 80 &  educV <= 100) = cS.iCD;
%       schoolClV(educV >= 110  &  educV <= 115) = cS.iCG;

output_cpsearn.var_save(schoolClV, cS.vSchoolGroup, year1, setNo);


% ********  Years of school

%       schoolV = repmat(cS.missVal, [n, 1]);
% 
%       oldV = [2,  10,  11 : 14,  20 : 22,  30 : 32,  40, 50, 60, 70, 71, 72, 73, ...
%          80, 81, 90, 91, 92,  100, 110, 111, 112, 113, 114, 115];
%       newV = [0,  3,   1  :  4,  5, 5, 6,  7, 7, 8,  9,  10, 11, 12, 12, 12, 12, ...
%          13, 14, 14, 14, 14,  15,  16,  16,  18,  18,  18,  20];
% 
%       for i1 = 1 : length(oldV)
%          schoolV(educV == oldV(i1)) = newV(i1);
%       end

output_cpsearn.var_save(schoolV, cS.vSchoolYears, year1, setNo);


end