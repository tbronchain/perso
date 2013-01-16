##
## Makefile for rsh by Thibault BRONCHAIN
##

CC	=	gcc
CFLAGS	=	-W -Wall -ansi -pedantic -Werror
INCLUDE	=	-I.
LDFLAGS	=	-ltermcap -lcrypt
NAME1	=	./bin/crypter
SRC1	=	crypter.c
OBJ1	=	crypter.o
NAME2	=	./bin/rsh
SRC2	=	crypt_cmp.c rsh.c
OBJ2	=	crypt_cmp.c rsh.o

all:
	mkdir -p ./bin
	$(CC) $(CFLAGS) $(INCLUDE) $(SRC1) -o $(NAME1) -lcrypt
	$(CC) $(CFLAGS) $(INCLUDE) $(SRC2) -o $(NAME2) $(LDFLAGS)

install:
	cp ./bin/rsh /usr/bin/root
	chmod -s /usr/bin/root

clean:
	rm -rf ./bin
