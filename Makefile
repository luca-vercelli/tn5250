BIN?=/usr/local/bin
DESTDIR?=

clean:
	#nothing to do

compile:
	#nothing to do

install:
	mkdir -p $(DESTDIR)$(BIN)
	mkdir -p $(DESTDIR)/usr/share/applications/
	mkdir -p $(DESTDIR)/etc/
	cp tn5250.sh $(DESTDIR)$(BIN)/tn5250
	cp tn5250.desktop $(DESTDIR)/usr/share/applications/
	cp tn5250.conf $(DESTDIR)/etc/

remove:
	$(RM) $(DESTDIR)$(BIN)/tn5250
	$(RM) $(DESTDIR)/usr/share/applications/tn5250.desktop
	$(RM) $(DESTDIR)/etc/tn5250.conf

