./iostat-csv.sh | tee -a /tmp/iostat.log &

while true; do
	ps -C java -o pid=,%mem=,vsz= >> /tmp/mem.log
	gnuplot /tmp/gnuplot.script
	sleep 1
done
