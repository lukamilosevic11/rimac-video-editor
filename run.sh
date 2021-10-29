rm -rf build
mkdir build
cd build/

qmake ../VideoEditor/VideoEditor.pro
  
make
rm *.o

echo "Build done!"
echo "VideoEditor is starting now..."
./VideoEditor
