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


# get website
git clone https://github.com/Dogfalo/materialize.git

git clone https://github.com/kolonuk/HTML5GameBrowser
mkdir /var/www/websitelocation
mv HTML5GameBrowser/www /var/www/websitelocation/
mv HTML5GameBrowser/html5gamebrowser.conf /etc/nginx/sitesenabled/...

wget https://github.com/Dogfalo/materialize/releases/download/1.0.0/materialize-v1.0.0.zip
unzip materialize-v1.0.0.zip
mv materialize/css /var/www/websitelocation/
mv materialize/js /var/www/websitelocation/
mv materialize/LICENCE /var/www/websitelocation/LICENCE_materialize
mv materialize/README.md /var/www/websitelocation/README_materialize.md



EXPOSE 8181:8181
ENTRYPOINT ["/bin/bash", "cd /weblocation/;python -m SimpleHTTPServer 8181"]





