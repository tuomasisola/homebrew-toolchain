include configs

ASM_OUT = out.hex
C_OUT = c/out

MAKEFLAGS += --silent


### General ###

.PHONY: run
run:
	source .venv/bin/activate && \
	python videoterminal.py ${TTY_DEV} ${BAUDRATE} ${INPUT_DELAY} ${CODE_ORG}

.PHONY: build
build:
	python3 -m venv ./.venv && \
	source .venv/bin/activate && \
	python3 -m pip install --upgrade pip && \
	python3 -m pip install pyserial

	gcc tools/send.c -o tools/send

	curl -O http://nightly.z88dk.org/z88dk-osx-latest.zip && \
	unzip z88dk-osx-latest.zip -d ./tools && \
	rm z88dk-osx-latest.zip

.PHONY: send
send:
	./tools/send ${INPUT_DELAY} < ${SRC} > ${TTY_DEV}

.PHONY: clean
clean:
	rm asm/*.hex asm/*.lst
	rm c/*.ihx c/*.bin
	rm tools/send
	rm -r tools/z88dk


.PHONY: print
print:
	awk 'BEGIN{print "\033[96m"}; \
		 NR <= 5; \
		 END{print "..."; print; print "\tlines: " NR; print "\033[0m"}' \
		 ${TOPRINT}

### Assembly ###

.PHONY: asm
asm:
	asm80 -m Z80 ${ASM_SOURCE} -o ${ASM_OUT} > /dev/null && \
	make print TOPRINT=asm/${ASM_OUT}


.PHONY: asm-send
asm-send:
	make send SRC=asm/${ASM_OUT}


### C ###

CC = zcc +rc2014
CFLAGS = -vn -subtype=basic -clib=sdcc_iy -SO3 --max-allocs-per-node200000 -create-app
PRAGMA = -pragma-define:CRT_ORG_CODE=${CODE_ORG} -pragma-define:CRT_REGISTER_SP=0xFC00


.PHONY: c
c:
	export PATH=${PATH}:./tools/z88dk/bin && \
	export ZCCCFG=./tools/z88dk/lib/config && \
	$(CC) $(CFLAGS) $(PRAGMA) ${C_SRC} -o $(C_OUT) && \
	rm c/*.bin
	make print TOPRINT=${C_OUT}.ihx

.PHONY: c-send
c-send:
	make send SRC=${C_OUT}.ihx


