mkdir -p build
rm -rf build/temp build/plasma5-genial build/sources
cp -R plasma5-genial build
mv build/plasma5-genial build/temp

find build/temp -type f -not -path '*/\.js' -exec sed -i 's/.import /\/\/.import /g' {} +
babel --presets env ./build/temp/ -x '.js'  --retain-lines -d ./build/sources
find build/sources -type f -not -path '*/\.js' -exec sed -i 's/\/\/.import /.import /g' {} +
rsync -a --ignore-existing build/temp/ build/sources

rm -rf plasma5-genial.plasmoid build/temp
cd build/sources
zip -r ../plasma5-genial.plasmoid *