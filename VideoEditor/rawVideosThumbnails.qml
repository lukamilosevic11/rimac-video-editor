import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.folderlistmodel 2.15

Window {
    property int numberOfRawVideos: 0;

    id: rawVideos
    visible: true
    height: 600
    width: 1000
    title: qsTr("Raw Videos")
    color: "#121212"

    //reads folder from which we get videos
    FolderListModel{
        id: rawVideosList;
        folder: mainWindow.rawVideosFolder
        nameFilters: ["*.mov", "*.avi", "*.mp4", "*.wmv", "*.flv", "*.mkv"] //some video file formats
        showFiles: true
        showDirs: false
        sortField: FolderListModel.Name

        onCountChanged: if(count !== 0) numberOfRawVideos = count;
        onStatusChanged: if(status === FolderListModel.Ready && numberOfRawVideos === 0) closeRawVideosPage.start();

    }

    //Message if folder doesn't have videos
    Text{
        id: noRawVideosText
        text: "There is no videos in this folder, please select another one!"
        x: rawVideos.width/2 - noRawVideosText.width/2;
        y: rawVideos.height/2 - noRawVideosText.height/2;
        font.family: "Encode Sans"
        font.pointSize: 15
        font.bold: true
        color: "#FBBF21"
        visible: rawVideosList.count === 0;
        onVisibleChanged: {
            if(visible === true) closeRawVideosPage.start();
        }
    }

    //shows thumbnails of videos
    GridView {
        id: rawVideosGrid
        anchors {
            fill:parent;
            margins: 10
        }
        cellWidth: width/2;
        cellHeight: height/2;
        visible: numberOfRawVideos > 0
        model: rawVideosList
        delegate: Rectangle {
            width: rawVideosGrid.cellWidth - 5;
            height: rawVideosGrid.cellHeight - 30;
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter;
            border.color: "#FBBF21";
            border.width: 2;
            color: "transparent";
            radius: 5

            //shows fullscreen
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    rawVideoFullscreenWindow.fileSource = fileUrl;
                    rawVideoFullscreenWindow.name = fileName;
                    rawVideoFullscreenWindow.showFullScreen();
                }
            }

            //thumbnail and button
            ColumnLayout{
                spacing: 3
                anchors.fill: parent
                Video {
                    id: rawVideoThumbnail;
                    autoPlay: true;
                    autoLoad: true;
                    Layout.alignment: Qt.AlignCenter
                    Layout.topMargin: 5;
                    Layout.leftMargin: 5;
                    Layout.rightMargin: 5;
                    Layout.fillHeight: true;
                    Layout.fillWidth: true;
                    source: fileUrl;
                    // play for 1s and then pause => and we have thumbnail :)
                    onPlaying: {
                        rawVideoThumbnail.seek(1000);
                        rawVideoThumbnail.pause();
                    }
                }

                Button {
                    id: buttonEditRawVideos
                    text: "Edit"
                    enabled: (!_db.rawVideosSettings && !_db.rawVideosEditing)
                    Layout.alignment: Qt.AlignCenter
                    Layout.bottomMargin: 5;
                    Layout.leftMargin: 5;
                    Layout.rightMargin: 5;

                    onClicked: {
                        mainWindow.rawVideoForEdit = fileUrl;
                        _db.fileName = fileBaseName;
                        _db.audioPath = filePath;
                        console.log(filePath);
                        let component = Qt.createComponent("rawVideoSettings.qml");

                        if(component.status === Component.Ready){
                            let createdObject = component.createObject(rawVideos);

                            if (createdObject !== null) {
                                print ("Component rawVideoSettings is now ready!");
                            } else {
                                print ("Object rawVideoSettings is null!");
                            }
                        }else if (component.status === Component.Error){
                            // Error Handling
                            console.log("Error loading component:", component.errorString());
                        }
                    }
                }

            }
        }
    }

    Timer{
        id: closeRawVideosPage
        interval: 1500;
        repeat: false;
        onTriggered: {
            rawVideos.destroy();
        }
    }

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2;
        y = Screen.height / 2 - height / 2;
        _db.rawVideosThumbnails = true;
    }

    Component.onDestruction: {
        _db.rawVideosThumbnails = false;
    }

    onClosing: {
        _db.rawVideosThumbnails = false;
    }

    //window which shows fullscreen video
    Window{
        property url fileSource:"";
        property string name:"";

        id: rawVideoFullscreenWindow
        title: name
        visible: false
        color: "#121212"

        Video
        {
            id: rawVideoFullscreen;
            anchors.fill: parent;
            autoLoad: true;
            autoPlay: true;
            source: rawVideoFullscreenWindow.fileSource;
//            loops: MediaPlayer.Infinite

            focus: true

            //with keys up and down we can change volume
            //with keys left and right we can seek video
            //with esc key we can close fullscreen mode
            //with space we can play and pause video
            Keys.onUpPressed: {
                if(rawVideoFullscreen.volume < 1.0)
                    rawVideoFullscreen.volume += 0.1;
                if(!volumeRawVideo.visible)
                    volumeRawVideo.visible = true;
                hideRawVideoVolume.stop();
            }
            Keys.onDownPressed: {
                if(rawVideoFullscreen.volume > 0.0)
                    rawVideoFullscreen.volume -= 0.1;
                if(!volumeRawVideo.visible)
                    volumeRawVideo.visible = true;
                hideRawVideoVolume.stop();
            }
            Keys.onLeftPressed: {
                if(rawVideoFullscreen.position - 5000 > 0)
                    rawVideoFullscreen.seek(rawVideoFullscreen.position - 5000);
                else
                    rawVideoFullscreen.seek(0);
                if(!seekRawVideo.visible)
                    seekRawVideo.visible = true;
                hideRawVideoSeek.stop();
            }
            Keys.onRightPressed: {
                if(rawVideoFullscreen.position + 5000 < rawVideoFullscreen.duration)
                    rawVideoFullscreen.seek(rawVideoFullscreen.position + 5000);
                else
                    rawVideoFullscreen.seek(rawVideoFullscreen.duration - 5);
                if(!seekRawVideo.visible)
                    seekRawVideo.visible = true;
                hideRawVideoSeek.stop();
            }

            Keys.onReleased: {
                if(volumeRawVideo.visible)
                    hideRawVideoVolume.start()

                if(seekRawVideo.visible)
                    hideRawVideoSeek.start()
            }

            Keys.onSpacePressed:{
                if(!playPausedRawVideos.visible)
                    playPausedRawVideos.visible = true;
                if(rawVideoFullscreen.playbackState === MediaPlayer.PlayingState){
                    rawVideoFullscreen.pause();
                    playPausedRawVideos.source = "./assets/pause.png";
                }else{
                    rawVideoFullscreen.play();
                    playPausedRawVideos.source = "./assets/play.png";
                }
                hideRawVideoPlayPaused.start();
            }

            Keys.onEscapePressed: rawVideoFullscreenWindow.close();


            Timer{
                id: hideRawVideoVolume
                interval: 500;
                repeat: false;
                onTriggered: volumeRawVideo.visible = false;
            }

            Timer{
                id: hideRawVideoSeek
                interval: 500;
                repeat: false;
                onTriggered: seekRawVideo.visible = false;
            }

            Timer{
                id: hideRawVideoPlayPaused
                interval: 500;
                repeat: false;
                onTriggered: playPausedRawVideos.visible = false;
            }

            //play/pause sign
            Image{
                id: playPausedRawVideos
                x: rawVideoFullscreen.width / 2 - width / 2;
                y: rawVideoFullscreen.height / 2 - height / 2;
                source: "./assets/pause.png"
                visible: false
                fillMode: Image.PreserveAspectFit
            }

            //volume bar
            Rectangle {
                id: volumeRawVideo
                anchors {
                    bottom: rawVideoFullscreen.bottom;
                    right: rawVideoFullscreen.right;
                    bottomMargin: 50;
                    rightMargin: 50;
                }
                color: "#FBBF21";
                width: 20;
                height: (rawVideoFullscreen.height - 100)*rawVideoFullscreen.volume;
                visible: false
                radius: 5
            }

            //seek bar
            Rectangle {
                id: seekRawVideo
                anchors {
                    left: rawVideoFullscreen.left;
                    bottom: rawVideoFullscreen.bottom;
                    bottomMargin: 50;
                    leftMargin: 50;
                }
                color: "#FBBF21";
                height: 20;
                width: ((1.0*rawVideoFullscreen.position)/(1.0*rawVideoFullscreen.duration))*rawVideoFullscreen.width - 100.0;
                visible: false
                radius: 5
            }
        }

        Component.onCompleted: {
            x = Screen.width / 2 - width / 2
            y = Screen.height / 2 - height / 2
        }

        onClosing: {
            rawVideoFullscreen.stop()
            fileSource = "";
            name = "";
        }
    }
}
