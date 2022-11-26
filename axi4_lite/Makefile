COV_OPT = line+cond+tgl+fsm

UVM_VERBOSITY = UVM_LOW

VCS = vcs \
	+v2k \
	-full64 \
	-sverilog \
	-debug_all \
	-tb_timescale=1ns/1ps \
	-l build.log \
	-cm $(COV_OPT) \
	+incdir+$(VERDI_HOME)/src \
	-P $(VERDI_HOME)/share/PLI/VCS/LINUXAMD64/novas.tab \
	$(VERDI_HOME)/share/PLI/VCS/LINUXAMD64/pli.a \

SIMV = ./simv \
	+UVM_VERBOSITY=$(UVM_VERBOSITY) \
	-l simv.log

all: clean comp sim 

.PHONY:

comp:
	$(VCS) \
	-f filelist.f

sim:
	$(SIMV) \
	-cm $(COV_OPT)

clean:
	@rm -rf wave* core csrc simv* vc_hdrs.h ucli.key urg* *.log *.fsdb novas.* verdiLog DVEfiles both *daidir case* result/*

urg:
	@urg -dir simv.vdb -report report/coverage

dve:
	dve -conv -dir simv.vdb&

verdi:
	verdi -sv -f filelist.f -ssf *.fsdb&
