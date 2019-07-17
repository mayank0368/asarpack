#!/bin/bash
mkdir temp
./node_modules/.bin/electron-rebuild 
cp -R ./src ./temp/
cp ./package-lock.json ./temp
cp ./package.json ./temp
cp -R ./node_modules ./temp
npm install -g asar
asar pack temp app.asar --unpack *.node
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    rm -rf node_modules/electron/dist/resources/default_app.asar
    mv app.asar node_modules/electron/dist/resources
    mv app.asar.unpacked node_modules/electron/dist/resources
    mv node_modules/electron/dist app
elif [[ "$OSTYPE" == "darwin"* ]]; then
    rm -rf node_modules/electron/dist/Electron.app/Contents/Resources/default_app.asar
    mv app.asar node_modules/electron/dist/Electron.app/Contents/Resources
    mv app.asar.unpacked node_modules/electron/dist/Electron.app/Contents/Resources
    cp -R node_modules/electron/dist/Electron.app app.app
fi

rm -rf temp


