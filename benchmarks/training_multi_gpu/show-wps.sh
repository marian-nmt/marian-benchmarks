prefix=$1

for dir in $(ls -d $prefix.?); do
    wps=$(cat $dir/train.log | grep 'Ep. ' | tail -n +2 | tr ' ' '\t' | cut -f18 | awk '{ total += $1; count++ } END { print total/count }')
    echo -e "$dir : \t$wps"
done

for dir in $(ls -d $prefix.?); do
    allwps=$(cat $dir/train.log | grep 'Ep. ' | tr ' ' '\t' | cut -f18 | tr '\n' ' ')
    echo -e "$dir : \t$allwps"
done

