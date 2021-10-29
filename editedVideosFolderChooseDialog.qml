import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3 as QDiag

//File dialog for choosing folder for edited videos
//Maybe we should set filePath to editedVideos folder instead of choosing folder but for now it's we use File dialog
QDiag.FileDialog {
    id: folderDialogEditedVideos
    folder: mainWindow.editedVideosFolder
    title: "Select folder which contains Edited Videos"
    selectFolder: true;

    onRejected: {
        console.log("Edited Videos folder chooser cancelled!");
        folderDialogEditedVideos.close();
    }

    onAccepted:{
        //console.log("OVO RADI TOP");

        //set default path for the edited videos
        mainWindow.editedVideosFolder = folder

        let component = Qt.createComponent("editedVideosThumbnails.qml");

        if(component.status === Component.Ready){
            let createdObject = component.createObject(mainWindow);
            if (createdObject !== null) {
                print ("Component editedVideosThumbnails is now ready!");
            } else {
                print ("Object editedVideosThumbnails is null!");
            }
        }else if (component.status === Component.Error){
            // Error Handling
            console.log("Error loading component:", component.errorString());
        }

        folderDialogEditedVideos.close();
    }

    Component.onCompleted: folderDialogEditedVideos.open();
}



