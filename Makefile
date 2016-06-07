BIN=/usr/local/bin

clean:
	#nothing to do

compile:
	#nothing to do

install:
	cp tn5250.sh $(DESTDIR)$(BIN)/tn5250
	cp tn5250.desktop $(DESTDIR)/usr/share/applications/
	cp tn5250.conf $(DESTDIR)/etc/

remove:
	$(RM) $(DESTDIR)$(BIN)/tn5250
	$(RM) $(DESTDIR)/usr/share/applications/tn5250.desktop
	$(RM) $(DESTDIR)/etc/tn5250.conf

