# shell-batteryCheck
When the computer is in discharging mode and when it goes below 70%, this project gives audio warning & shutdown the computer @ no response after the audio warning. There is a cronjob at root level will call this script "bat_chkRun.sh" every minute. Since we need to shutdown the computer through the script, we need 'root' level cronjob. Once the computer is discharging, this script will start to monitor & create logs @ 'BAT_LOG.txt'. Once the computer charge level reaches 70 or below 70%, it'll run "audi.sh" script as user '<local uesr[GUI]>'. It's because at this user runlevel, even if the audio player is used by the GUI programs, this method ensures the warning sound plays on top of it. The warning audio file is "warning.wav" The user has to plug-in the power while hearing the audio warining. If one failed to power up, the computer will shutdown automatically.

Project written by
kamalakannan
