import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import vEditor 1.0
import Qt.labs.platform 1.1 as QLabs

Window {
    // home folder is a default path at the beggining, after that last choosen folder will be the default one
    property string editedVideosFolder: QLabs.StandardPaths.writableLocation(QLabs.StandardPaths.HomeLocation);
    property string rawVideosFolder: QLabs.StandardPaths.writableLocation(QLabs.StandardPaths.HomeLocation);
    property url rawVideoForEdit;

    id: mainWindow
    visible: true
    height: 600
    width: 1000
    title: qsTr("Video Editor by Lule")
    color: "#121212"

    //nevera image
    Image {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: lineMainWindow.top
        }
        fillMode: Image.PreserveAspectFit
        source: "./assets/rimacNevera.png"
    }

    //yellow line
    Rectangle{
        id: lineMainWindow
        anchors {
            left: parent.left
            right: parent.right
            bottom: buttonsRawAndEditedRowLayout.top
            topMargin: 0
            bottomMargin: 15
            leftMargin: 150
            rightMargin: 150
        }
        color: "#FBBF21"
        height: 2
        radius: 15
    }

    //buttons
    RowLayout{
        id: buttonsRawAndEditedRowLayout
        Layout.alignment: Qt.AlignCenter
        Layout.fillHeight: true
        Layout.fillWidth: true
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom
            bottomMargin: 100
        }
        Button {
            id: rawButton
            enabled: !_db.rawVideosThumbnails;
            Layout.alignment: Qt.AlignRight
            text: "Raw Videos"
            onClicked: {
                let component = Qt.createComponent("rawVideosFolderChooseDialog.qml");

                if(component.status === Component.Ready){
                    let createdObject = component.createObject(mainWindow);
                    if (createdObject !== null) {
                        print ("Component rawVideosFolderChooseDialog is now ready!");
                    } else {
                        print ("Object rawVideosFolderChooseDialog is null!");
                    }
                }else if (component.status === Component.Error){
                    // Error Handling
                    console.log("Error loading component:", component.errorString());
                }
            }
        }
        Button{
            id: editedButton
            enabled: !_db.editedVideosThumbnails
            Layout.alignment: Qt.AlignLeft
            text: "Edited Videos"
            onClicked: {
                let component = Qt.createComponent("editedVideosFolderChooseDialog.qml");

                if(component.status === Component.Ready){
                    let createdObject = component.createObject(mainWindow);
                    if (createdObject !== null) {
                        print ("Component editedVideosFolderChooseDialog is now ready!");
                    } else {
                        print ("Object editedVideosFolderChooseDialog is null!");
                    }
                }else if (component.status === Component.Error){
                    // Error Handling
                    console.log("Error loading component:", component.errorString());
                }
            }
        }
    }

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }
}
