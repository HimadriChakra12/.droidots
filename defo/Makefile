DEFO       ?= defo
APKSIGNER  ?= apksigner
ZIPALIGN   ?= zipalign
KEYTOOL    ?= keytool

KEYSTORE   ?= defo.keyring
KEY_ALIAS  ?= defo

APPS := $(patsubst %/defo.conf,%,$(wildcard */defo.conf))

.PHONY: all clean keystore $(APPS)

all: $(APPS)

$(APPS): %: %/defo.conf $(KEYSTORE)
	@echo "== $@ =="
	@apk=$$(grep -E '^[[:space:]]*apk[[:space:]]*=' $@/defo.conf \
	          | sed -E 's/^[^=]*=[[:space:]]*//'); \
	if [ -n "$$apk" ]; then \
		( cd $@ && $(DEFO) -f "$$apk" -c defo.conf ); \
	else \
		( cd $@ && $(DEFO) -a -c defo.conf ); \
	fi
	@outname=$$(grep -E '^[[:space:]]*output[[:space:]]*=' $@/defo.conf \
	              | sed -E 's/^[^=]*=[[:space:]]*//'); \
	if [ -z "$$outname" ]; then \
		outname=$$(cd $@ && ls -t *-defo.apk 2>/dev/null | head -n1); \
	fi; \
	if [ -z "$$outname" ] || [ ! -f "$@/$$outname" ]; then \
		echo "!! couldn't find defo's output apk in $@ (check its 'output =' line)"; \
		exit 1; \
	fi; \
	aligned="$@/aligned-$$outname"; \
	$(ZIPALIGN) -f -p 4 "$@/$$outname" "$$aligned"; \
	$(APKSIGNER) sign --ks $(KEYSTORE) --ks-key-alias $(KEY_ALIAS) "$$aligned"; \
	echo "-> $$aligned (signed)"

keystore: $(KEYSTORE)

$(KEYSTORE):
	$(KEYTOOL) -genkeypair -v \
		-keystore $(KEYSTORE) -alias $(KEY_ALIAS) \
		-keyalg RSA -keysize 2048 -validity 10000

clean:
	rm -f */*-defo.apk */aligned-*.apk
