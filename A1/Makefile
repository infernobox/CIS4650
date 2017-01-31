#
# Makefile for news article language in SGML
#

CC = g++

CFLAGS =

OBJS = lex.yy.o util.o scanner.o

scanner: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o scanner -ll
	
scanner.o: scanner.cpp globals.h util.h
	$(CC) $(CFLAGS) -c scanner.cpp

util.o: util.cpp util.h globals.h
	$(CC) $(CFLAGS) -c util.cpp

lex.yy.c: tokens.l 
	flex tokens.l

lex.yy.o: lex.yy.c globals.h util.h
	$(CC) $(CFLAGS) -c lex.yy.c

clean: 
	rm -f scanner $(OBJS) lex.yy.c