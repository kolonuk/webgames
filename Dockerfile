FROM ubuntu

RUN apt-get update;apt-get upgrade -y
RUN apt-get install git python2.7 cmake default-jre -y

RUN mkdir /build && \
    cd /build && \
    git clone https://github.com/emscripten-core/emsdk.git && \
    cd emsdk && \
    git pull && \
    ./emsdk install latest && \
    ./emsdk activate latest && \
    source ./emsdk_env.sh
    
    cd /build
    git clone https://github.com/dreamlayers/em-dosbox.git
    cd em-doxbox
    ./autogen.sh
    emconfigure ./configure
    make
    #copy srx/dosbox.js and src/dosbox.html, src/packager.py and src/repackager.py

    emconfigure ./configure --disable-sync
    make
    #copy srx/dosbox.js, src/dosbox.html and dosbox.html.mem, src/packager.py and src/repackager.py

    emconfigure ./configure --enable-wasm
    make
    #copy srx/dosbox.js, src/dosbox.html, src/packager.py and src/repackager.py

mkdir /build/em-dosbox/src/gamename
cd /build/em-dosbox/src/gamename
get game and unpack
cd ..

#packager.py name dir start.exe
./sync_packageer.py stryker major_stryker STRYKER.EXE
cp stryker.html weblocation/game
cp stryker.data weblocation/game
COPY confs/stryker_dosbox.conf weblocation/game


EXPOSE 8181:8181
ENTRYPOINT ["/bin/bash", "cd /weblocation/;python -m SimpleHTTPServer 8181"]





