STARTTIME=`date +%s`
sleep 10
sudo logger BenchmarkComplete `wget -q -O - http://169.254.169.254/latest/meta-data/instance-id` $STARTTIME `date +%s`