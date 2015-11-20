# Translate from cpsbc to cpsearn

perl -pi -w -e 's/const\_fig\_bc1/const\_fig\_cpsearn/g' $1
perl -pi -w -e 's/\_bc1/\_cpsearn/g' $1
perl -pi -w -e 's/var\_load\_cpsbc/output\_cpsearn.var\_load/g' $1
perl -pi -w -e 's/var\_save\_cpsbc/output\_cpsearn.var\_save/g' $1
perl -pi -w -e 's/cpsbc/cpsearn/g' $1

perl -pi -w -e 's/save\_fig\_cpsearn/output\_cpsearn.fig\_save/g' $1