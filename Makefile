DIR = bin
CONFIG = debug
SWIFTBUILD = swift build -c $(CONFIG)
BINARY = .build/$(CONFIG)
DOMAIN = niossl.test


.PHONY: all server client mqtt-client cert clean distclean
.DEFAULT_GOAL := all


$(DIR):
	mkdir $(DIR)

server: $(DIR)
	$(SWIFTBUILD) --product server
	@cp -v $(BINARY)/server $(DIR)/

client: $(DIR)
	$(SWIFTBUILD) --product client
	@cp -v $(BINARY)/client $(DIR)/

mqtt-client: $(DIR)
	$(SWIFTBUILD) --product mqtt-client
	@cp -v $(BINARY)/mqtt-client $(DIR)/

cert:
	openssl req -x509 -newkey rsa:2048 -sha256 \
	-keyout key.pem -out cert.pem \
	-days 365 -nodes \
	-subj "/CN=$(DOMAIN)" \
	-addext "subjectAltName=DNS:$(DOMAIN)"


all: server client mqtt-client cert

clean:
	swift package clean
	rm -rf $(DIR)

distclean: clean
	rm -rf Package.resolved
