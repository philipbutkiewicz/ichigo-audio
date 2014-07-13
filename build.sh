#!/bin/bash
mkdir output

if [ $# -ne 1 ]; then
    echo "Missing platform argument"
    echo "Usage: build.sh [osx|linux]"
    exit 1
fi
if [ $1 == "osx" ]; then
	ext="dylib"
	libs=""
	headers=""

	cp -v ichigo_audio.c ichigo_audio.build.c
	echo -e "#define OSX 1\n\n$(cat ichigo_audio.build.c)" > ichigo-audio.build.c

	cp -v dependencies/osx/bass/libbass.dylib output/libbass.dylib
	cp -v dependencies/osx/bass_fx/libbass_fx.dylib output/libbass_fx.dylib
	cp -v dependencies/osx/bassflac/libbassflac.dylib output/libbassflac.dylib
	cp -v dependencies/osx/basswv/libbasswv.dylib output/libbasswv.dylib
	cp -v dependencies/osx/bass_ape/libbass_ape.dylib output/libbass_ape.dylib
	cp -v dependencies/osx/bass_mpc/libbass_mpc.dylib output/libbass_mpc.dylib
	cp -v dependencies/osx/tags/libtags.dylib output/libtags.dylib
fi
if [ $1 == "linux" ]; then
	ext="so"
	libs="-Ldependencies/win32/bass_aac -Ldependencies/win32/bass_alac -lbass_aac -lbass_alac"
	headers="-Idependencies/win32/bass_aac -Idependencies/win32/bass_alac"

	cp -v dependencies/linux/bass/libbass.so output/libbass.so
	cp -v dependencies/linux/bass_fx/libbass_fx.so output/libbass_fx.so
	cp -v dependencies/linux/bassflac/libbassflac.so output/libbassflac.so
	cp -v dependencies/linux/bass_aac/libbass_aac.so output/libbass_aac.so
	cp -v dependencies/linux/bass_alac/libbass_alac.so output/libbass_alac.so
	cp -v dependencies/linux/basswv/libbasswv.so output/libbasswv.so
	cp -v dependencies/linux/bass_ape/libbass_ape.so output/libbass_ape.so
	cp -v dependencies/linux/bass_mpc/libbass_mpc.so output/libbass_mpc.so
	cp -v dependencies/linux/tags/libtags.so output/libtags.so

	cp -v ichigo-audio.c ichigo-audio.build.c
fi

gcc -c ichigo-audio.build.c -Idependencies/$1/bass -Idependencies/$1/bassflac -Idependencies/$1/bass_fx -Idependencies/$1/tags/c $headers -m32 -o ichigo-audio.o
gcc -shared -Wl -m32 -Ldependencies/$1/bass -Ldependencies/$1/bassflac -Ldependencies/$1/bass_fx -Ldependencies/$1/basswv -Ldependencies/$1/bass_ape -Ldependencies/$1/bass_mpc -Ldependencies/$1/bass_fx/tags/c $libs -lbass -lbassflac -lbass_fx -lbasswv -lbass_ape -lbass_mpc -ltags -o ichigo-audio.$ext ichigo-audio.o
rm ichigo-audio.build.c
rm ichigo-audio.o

cp -v ichigo-audio.$ext output/ichigo-audio.$ext
