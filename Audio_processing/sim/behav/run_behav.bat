@echo off
set bin_path=D:/PDS_FPGA/Modelsim_SE_10_5/win64
cd D:/PDS_FPGA/Audio_test/sim/behav
call "%bin_path%/modelsim"   -do "do {run_behav_compile.tcl};do {run_behav_simulate.tcl}" -l run_behav_simulate.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
