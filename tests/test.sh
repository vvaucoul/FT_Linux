lsblk /dev/sdc
var=$?

echo 'Var: ' $var

if [ $var != 0 ]
then
    echo "Before format partitions, insert a second disk..."
    exit 1
fi
