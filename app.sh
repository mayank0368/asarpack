mkdir temp
./node_modules/.bin/electron-rebuild -w sqlite3 -p
cp -R ./src ./temp/
cp ./package-lock.json ./temp
cp ./package.json ./temp
cp -R ./node_modules ./temp
npm install -g asar
asar pack temp app.asar
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    rm -rf node_modules/electron/dist/resources/default_app.asar
    cp app.asar node_modules/electron/dist/resources
    cp -R node_modules/electron/dist app
    mv app/electron app/app
elif [[ "$OSTYPE" == "darwin"* ]]; then
    rm -rf node_modules/electron/dist/Electron.app/Contents/Resources/default_app.asar
    cp app.asar node_modules/electron/dist/Electron.app/Contents/Resources
    cp -R node_modules/electron/dist/Electron.app app.app
fi

