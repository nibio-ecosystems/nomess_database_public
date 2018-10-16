SQL='psql'
SQLFLAGS='nomess'

mapfiles := $(wildcard *.sql)
mapdone := $(mapfiles:.sql=.out)

all: 
	$(MAKE) maps

maps: $(mapdone) 

clean:
	rm *.out

%.out:	%.sql 
	$(SQL) $(SQLFLAGS) < $<	 && echo "BUILT" >> $@
