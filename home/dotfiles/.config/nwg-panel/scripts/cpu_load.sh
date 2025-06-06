# Extract CPU frequencies from /proc/cpuinfo
frequencies=$(cat /proc/cpuinfo | grep "MHz" | cut -d':' -f2)

# Initialize sum and count variables
sum=0
count=0

# Loop through each frequency
for freq in $frequencies; do
  sum=$(echo "$sum + $freq" | bc)
  count=$((count + 1))
done

# Calculate the average in GHz if count is greater than zero
if [ $count -gt 0 ]; then
  average_mhz=$(echo "$sum / $count" | bc)
  average_ghz=$(echo "scale=2; $average_mhz / 1000" | bc)
  echo " $average_ghz GHz"
else
  echo "No frequencies found in /proc/cpuinfo."
fi
