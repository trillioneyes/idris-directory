CFLAGS += -std=gnu99 

providertest: providertest.idr stattypes.o System/Directory/Providers.idr
	idris providertest.idr -o providertest

stattest: System/Directory/Stat.idr System/Directory/Providers.idr stattypes.so statbinds.o statbinds.so
	idris stattest.idr -o stattest

stattypes.so: stattypes.c stattypes.h
	gcc $(CFLAGS) -shared stattypes.c -o stattypes.so -fPIC

statbinds.so: statbinds.c statbinds.h
	gcc $(CFLAGS) -shared statbinds.c -o statbinds.so -fPIC
