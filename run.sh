iostat -t -x 1 | grep --line-buffered -v -e avg-cpu -e Device -e Linux >> /tmp/iostat.log &

while true; do
	ps -C java -o pid=,%mem=,vsz= >> /tmp/mem.log
	gnuplot ./gnuplot.script
	sleep 1
done
