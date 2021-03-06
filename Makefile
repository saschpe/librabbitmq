RABBIT_DIR=rabbitmq-c
RABBIT_TARGET=clib
RABBIT_DIST=librabbitmq-0.0.1


all: build

add-submodules:
	-git submodule add https://github.com/alanxz/rabbitmq-c
	-git submodule add https://github.com/rabbitmq/rabbitmq-codegen

submodules:
	git submodule init
	git submodule update

rabbitmq-c: submodules
	(cd $(RABBIT_DIR); test -f configure || autoreconf -i)
	(cd $(RABBIT_DIR); test -f Makefile  || automake --add-missing)


rabbitmq-clean:
	-(cd $(RABBIT_DIR) && make clean)
	-(cd $(RABBIT_TARGET) && make clean)

rabbitmq-distclean:
	-(cd $(RABBIT_DIR) && make distclean)
	-(cd $(RABBIT_TARGET) && make distclean)

clean-build:
	-rm -rf build

build: clean-build dist
	python setup.py build

install: build
	python setup.py install

develop: build
	python setup.py develop

pyclean:
	-python setup.py clean
	-rm -rf build
	-rm -f _librabbitmq.so

clean: pyclean rabbitmq-clean

distclean: pyclean rabbitmq-distclean
	-rm -rf dist
	-rm -rf clib
	-rm -f erl_crash.dump

$(RABBIT_TARGET):
	(test -f config.h || cd $(RABBIT_DIR); ./configure)
	(cd $(RABBIT_DIR); make distdir)
	mv "$(RABBIT_DIR)/$(RABBIT_DIST)" "$(RABBIT_TARGET)"


dist: rabbitmq-c $(RABBIT_TARGET)


rebuild:
	python setup.py build
	python setup.py install
