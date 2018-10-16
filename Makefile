# Top level SQL makefile
# GBB 2014

# Add make clean to subdirs

export SQL='psql'
export SQLFLAGS='nomess'

# Default target
all: main_maps

# Subdirs are...
SUBDIRS := base_maps 1 2 3 4 main_maps

# These are not real files, they are targets
.PHONY: $(SUBDIRS)

# This is a make target for all subdirs
subdirs: $(SUBDIRS)

# This is how to make each subdir when treated as a target
$(SUBDIRS):
	$(MAKE) -C $@

# Most maps depend on base maps
1: base_maps
2: base_maps
3: base_maps
4: base_maps

# Main maps need everything else built first. 
.PHONY: main_maps

main_maps: 1 2 3 4 

clean: 
	find ./ -name "*.out" -exec rm '{}' \;

setup:	setup.sql
	$(SQL) $(SQLFLAGS) < setup.sql 

