DAM=.awsmake
CFNT=CFnTemplate
AMIB=AMIBakefile
TOOL_PATH=./
CFN_CREATE=cfn_create.sh
CFN_DELETE=cfn_delete.sh
AMIBAKE=amibake

$(DAM)/%.stack: $(CFNT)/%.yaml
	@if [[ -f $@ ]]; then \
		echo $* stack clean; \
		$(TOOL_PATH)$(CFN_DELETE) --wait $* $(CD_OPTS); \
	fi
	@echo $* stack build
	@$(TOOL_PATH)$(CFN_CREATE) --wait $* $< $(CC_OPTS)
	@if [[ ! -d $(DAM) ]]; then \
		mkdir -p $(DAM); \
	fi
	@touch $@

$(DAM)/%.ami: $(AMIB)/%.amib
	@if [[ -f $@ ]]; then \
		echo $* ami clean; \
		$(TOOL_PATH)$(AMIBAKE) rmi $(AB_NAME_TAG) $(AB_OPTS); \
	fi
	@echo $* ami build
	@$(TOOL_PATH)$(AMIBAKE) build -f $< $(AB_OPTS)
	@$(TOOL_PATH)$(AMIBAKE) push $(AB_NAME_TAG) $(AB_OPTS)
	@if [[ ! -d $(DAM) ]]; then \
		mkdir -p $(DAM); \
	fi
	@touch $@
