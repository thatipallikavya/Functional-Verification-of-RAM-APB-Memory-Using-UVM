# Makefile for UVM Testbench

RTL = ../rtl/*
WORK = work
SVTB1 = ../tb/top.sv
SVTB2 = ../test/test_pkg.sv
INC = +incdir+../tb +incdir+../test +incdir+../apb_side

VSIMOPT = -vopt -voptargs=+acc
VSIMCOV = -coverage -sva
VSIMBATCH1 = -c -do "log -r /*; coverage save -onexit mem_cov1; run -all; exit"

sv_cmp:
        vlib $(WORK)
        vmap work $(WORK)
        vlog -work $(WORK) $(RTL) $(INC) $(SVTB2) $(SVTB1)

run_test1: sv_cmp
        vsim $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1) -wlf wave_file1.wlf -l test1.log -sv_seed random work.top +UVM_TESTNAME=write_test
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1

view_wave1:
        vsim -view wave_file1.wlf

report:
        vcover report -html mem_cov1 -output covhtmlreport
        vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1

cov:
        firefox covhtmlreport/index.html &

clean:
        rm -rf transcript* *log* vsim.wlf fcover* covhtml* mem_cov* *.wlf modelsim.ini
        clear

regress: clean run_test1 report cov
