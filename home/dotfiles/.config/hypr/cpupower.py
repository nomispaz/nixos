import subprocess
import time

custom_command = "sudo cpupower frequency-set -u 2GHz"

while True:
    subprocess.call(custom_command, shell=True)
    time.sleep(2)
