import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3 as QDiag

//File dialog for choosing folder for edited videos
QDiag.FileDialog {
    id: folderDialog
    folder: mainWindow.rawVideosFolder
    title: "Select folder which contains Raw Videos"
    selectFolder: true;

    onRejected: {
        console.log("Raw Videos folder chooser cancelled!");
        folderDialog.close();
    }

    onAccepted:{
        //set default path for the raw videos
        mainWindow.rawVideosFolder = folder

        let component = Qt.createComponent("rawVideosThumbnails.qml");

        if(component.status === Component.Ready){
            let createdObject = component.createObject(mainWindow);
            if (createdObject !== null) {
                print ("Component rawVideosThumbnails is now ready!");
            } else {
                print ("Object rawVideosThumbnails is null!");
            }
        }else if (component.status === Component.Error){
            // Error Handling
            console.log("Error loading component:", component.errorString());
        }

        folderDialog.close();
    }

    Component.onCompleted: folderDialog.open();
}



