PREFIX ?= localinstall

ifeq ($(shell uname),Darwin)
	INSTALL=ginstall
else
	INSTALL=install
endif

install:
	$(INSTALL) etc/bash_completion.d/_philcd.bash -D $(DESTDIR)$(PREFIX)/etc/bash_completion.d/_philcd.bash
	$(INSTALL) libexec/philcd/philcd_get_colonpath_candidates.py -D $(DESTDIR)$(PREFIX)/libexec/philcd/philcd_get_colonpath_candidates.py
