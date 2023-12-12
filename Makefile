ifeq (1,${RELEASE})
	VFLAGS=-prod
endif
ifeq (1,${ARM})
	VFLAGS:=-cflags "-target arm64-apple-darwin" $(VFLAGS)
endif
ifeq (1,${WINDOWS})
	VFLAGS:=-os windows $(VFLAGS)
endif

all: check build test

check:
	v fmt -w .
	v vet .

build:
	v $(VFLAGS) -use-os-system-to-run yaml2json.v

test:
	./test.sh
