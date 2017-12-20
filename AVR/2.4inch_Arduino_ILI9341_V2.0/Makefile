MAKEFILES = $(shell find Demo/ -type f -name Makefile)
DIRS = $(dir $(MAKEFILES))

help:
	@echo projects available:
	@for dir in $(DIRS); do \
	   echo '\t'$$dir; \
	 done

# This is a dirty hack
# https://stackoverflow.com/questions/6703125/how-to-do-make-subdir-target
.PHONY: $(DIRS)
$(DIRS):
	$(MAKE) -C $@ $(filter-out $(DIRS), $(MAKECMDGOALS))

all:
	for dir in $(MAKEFILES); do \
	   $(MAKE) -C $$(dirname $$dir); \
	 done

clean:
	@for dir in $(DIRS); do \
	   rm -vfr $$dir/build-uno/; \
	 done

