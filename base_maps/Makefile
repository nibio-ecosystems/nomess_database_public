mapfile := $(wildcard *.sql)
mapout := $(mapfile:.sql=.out)

SQL='psql'
SQLFLAGS='nomess'

.PHONY: all 

all: $(mapout) 

clean:
	rm *.out

%.out:	%.sql 
	$(SQL) $(SQLFLAGS) < $<	 && echo "BUILT" >> $@
