# Second level SQL makefile
# GBB 2014

SQL='psql'
SQLFLAGS='nomess'

# Variables: find the local overview file and subdirectories.
overviewfile := $(wildcard overview*.sql)
overviewout := $(overviewfile:.sql=.out)
SUBDIR := $(sort $(dir $(wildcard */.)))

# Tell make that 'all' and '$(SUBDIR)' are not real filenames to produce.
.PHONY: all $(SUBDIR) 

# To build everything, first build all the subdirectories, then this overview.
all:	
	$(MAKE) subdirs
	$(MAKE) overview	

# To make all subdirs, build all the 'SUBDIR' variable items
subdirs: $(SUBDIR) 

# To make an overview, build the 'overview.out' file. 
overview: $(overviewout)

# To build each subdir, do the following
$(SUBDIR):
	$(MAKE) -C $@

# To clean up, delete the *.out file. This will force a SQL table rebuild. 
clean:
	find ./ -name "*.out" -exec rm '{}' \;

# To build an sql file, do the following.
%.out:  %.sql
	$(SQL) $(SQLFLAGS) < $<  && echo "BUILT" >> $@


