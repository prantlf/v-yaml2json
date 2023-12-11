ifeq (1,${RELEASE})
	VFLAGS=-prod
endif

all: check build test

check:
	v fmt -w .
	v vet .

build:
	v $(VFLAGS) -use-os-system-to-run yaml2json.v

test:
	./test.sh
