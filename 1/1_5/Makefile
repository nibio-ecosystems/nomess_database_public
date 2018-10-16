SQL='psql'
SQLFLAGS='nomess'

viewfiles := $(wildcard view*.sql)
viewouts := $(viewfiles:.sql=.out)
overviewfile := $(wildcard overview*.sql)
overviewout := $(overviewfile:.sql=.out)

all: 
	$(MAKE) views
	$(MAKE) overview

overview: $(overviewout)
views: $(viewouts) 

clean:
	rm *.out

%.out:	%.sql 
	$(SQL) $(SQLFLAGS) < $<	 && echo "BUILT" >> $@
