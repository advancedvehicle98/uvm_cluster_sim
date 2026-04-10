# Work directories (relative to this root dir)
OUT_PREFIX        ?= ./out
LIB_PREFIX        ?= $(OUT_PREFIX)
BUILD_UTIL_PREFIX ?= .

RTL_PREFIX    ?= ./src/rtl
TB_PREFIX     ?= ./src/tb

ALL_PREFIXES = \
	$(BUILD_UTIL_PREFIX) \
	$(RTL_PREFIX) \
	$(TB_PREFIX)


# Source files
#---------------------------------------------------------------------

TB_TARGETS = tb.sv
UVM_TESTS ?= cluster_base_test

CONFIG_NAME = cluster_config

RTL_TARGETS = \
	cluster_test_pkg.sv \
	node_desc.sv \
	cluster.sv \
	cluster_if.sv \
	node.sv \
	node_if.sv \
	node_param_if.sv \
	sched_if.sv \
	scheduler_none.sv

SV_TARGETS = \
	$(foreach TG,$(TB_TARGETS),$(TB_PREFIX)/$(TG)) \
	$(foreach TG,$(RTL_TARGETS),$(RTL_PREFIX)/$(TG)) \
	./src/config.sv 


# Questa variables
#---------------------------------------------------------------------

VSIM_LOG_FILE_PATH ?= $(OUT_PREFIX)/sim.log

TOP_LEVEL_MODULE  = tb
TOP_WORK_LIB_PATH = $(LIB_PREFIX)/$(TOP_LEVEL_MODULE)

VSIM_DO_SCRIPT_PATH = $(BUILD_UTIL_PREFIX)/vsim.do
VSIM_CMD_ARGS_FILE  = $(BUILD_UTIL_PREFIX)/vsim_cmd_args.txt
VLOG_CMD_ARGS_FILE  = $(BUILD_UTIL_PREFIX)/vlog_cmd_args.txt


#---------------------------------------------------------------------
#                          TARGETS
#---------------------------------------------------------------------

PHONY += all
all: out_dir questa

PHONY += questa
questa: vlog vsim


PHONY += out_dir
out_dir:
	mkdir -p $(OUT_PREFIX)


# Questa package compilation
#---------------------------------------------------------------------

PHONY += vlog
vlog: $(SV_TARGETS)
	vlog $^ \
	-sv \
	-libmap ./src/libmap.sv \
	-f $(VLOG_CMD_ARGS_FILE) \
	-work $(TOP_WORK_LIB_PATH)


# UVM simulation lauch
#---------------------------------------------------------------------

PHONY += vsim
vsim: $(UVM_TESTS)
.NOTPARALLEL: vsim

$(UVM_TESTS):
	vsim $(CONFIG_NAME) \
	-f $(VSIM_CMD_ARGS_FILE) \
	-L $(TOP_WORK_LIB_PATH) \
	-l $(VSIM_LOG_FILE_PATH) \
	-lib $(TOP_WORK_LIB_PATH) \
	+UVM_TESTNAME-$@ \
	-do $(VSIM_DO_SCRIPT_PATH); \


# Cleanup (do this before doing commits or if something
# goes wrong)
#---------------------------------------------------------------------

BUILD_ARTEFACTS = \
	$(OUT_PREFIX) \
	work \
	$(foreach P,$(ALL_PREFIXES),$(P)/*~) \
	./*_lib

PHONY += clean
clean:
	rm -rf $(BUILD_ARTEFACTS)


# Help output
#---------------------------------------------------------------------
PHONY += help
help: 
	@printf "dd\n"
