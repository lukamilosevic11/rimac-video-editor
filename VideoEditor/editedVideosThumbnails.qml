import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.folderlistmodel 2.15

Window {
    property int numberOfEditedVideos: 0;

    id: editedVideos
    visible: true
    height: 600
    width: 1000
    title: qsTr("Edited Videos")
    color: "#121212"

    //reads folder from which we get videos
    FolderListModel{
        id: editedVideosList;
        folder: mainWindow.editedVideosFolder
        nameFilters: ["*.mov", "*.avi", "*.mp4", "*.wmv", "*.flv", "*.mkv"] //some video file formats
        showFiles: true
        showDirs: false
        sortField: FolderListModel.Name

        onCountChanged: if(count !== 0) numberOfEditedVideos = count;
        onStatusChanged: if(status === FolderListModel.Ready && numberOfEditedVideos === 0) closeEditedVideosPage.start();
    }

    //Message if folder doesn't have videos
    Text{
        id: noEditedVideosText
        text: "There is no videos in this folder, please select another one!"
        x: editedVideos.width/2 - noEditedVideosText.width/2;
        y: editedVideos.height/2 - noEditedVideosText.height/2;
        font.family: "Encode Sans"
        font.pointSize: 15
        font.bold: true
        color: "#FBBF21"
        visible: editedVideosList.count === 0;
        onVisibleChanged: {
            if(visible === true) closeEditedVideosPage.start();
        }
    }

    //shows thumbnails of videos
    GridView {
        id: editedVideosGrid
        anchors {
            fill:parent;
            margins: 10
        }
        cellWidth: width/2;
        cellHeight: height/2;
        visible: numberOfEditedVideos > 0
        model: editedVideosList
        delegate: Rectangle {
            width: editedVideosGrid.cellWidth - 5;
            height: editedVideosGrid.cellHeight - 5;
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter;
            border.color: "#FBBF21";
            border.width: 2;
            color: "transparent";
            radius: 5
            Video {
                id: editedVideoThumbnail;
                autoPlay: true;
                autoLoad: true;
                anchors {
                    fill: parent;
                    margins: 2;
                }

                source: fileUrl;
                // play for 1s and then pause => and we have thumbnail :)
                onPlaying: {
                    editedVideoThumbnail.seek(1000);
                    editedVideoThumbnail.pause();
                }

                //shows fullscreen
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        editedVideoFullscreenWindow.fileSource = fileUrl;
                        editedVideoFullscreenWindow.name = fileName;
                        editedVideoFullscreenWindow.showFullScreen();
                    }
                }
            }

            Button {
                id: deleteEditedVideo
                text: "Delete"
                anchors {
                    bottom: editedVideoThumbnail.bottom
                    right: editedVideoThumbnail.right
                }

                onClicked: {
                    _db.deleteEditedVideo(filePath);
                }
            }
        }
    }

    Timer{
        id: closeEditedVideosPage
        interval: 2000;
        repeat: false;
        onTriggered: editedVideos.destroy();
    }

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2;
        y = Screen.height / 2 - height / 2;
        _db.editedVideosThumbnails = true;
    }
    Component.onDestruction: {
        _db.editedVideosThumbnails = false;
    }

    onClosing: {
        _db.editedVideosThumbnails = false;
    }

    //window which shows fullscreen video
    Window{
        property url fileSource:"";
        property string name:"";

        id: editedVideoFullscreenWindow
        title: name
        visible: false
        color: "#121212"

        Video
        {
            id: editedVideoFullscreen;
            anchors.fill: parent;
            autoLoad: true;
            autoPlay: true;
            source: editedVideoFullscreenWindow.fileSource;
//            loops: MediaPlayer.Infinite

            focus: true

            //with keys up and down we can change volume
            //with keys left and right we can seek video
            //with esc key we can close fullscreen mode
            //with space we can play and pause video
            Keys.onUpPressed: {
                if(editedVideoFullscreen.volume < 1.0)
                    editedVideoFullscreen.volume += 0.1;
                if(!volumeEditedVideo.visible)
                    volumeEditedVideo.visible = true;
                hideEditedVideoVolume.stop();
            }
            Keys.onDownPressed: {
                if(editedVideoFullscreen.volume > 0.0)
                    editedVideoFullscreen.volume -= 0.1;
                if(!volumeEditedVideo.visible)
                    volumeEditedVideo.visible = true;
                hideEditedVideoVolume.stop();
            }
            Keys.onLeftPressed: {
                if(editedVideoFullscreen.position - 5000 > 0)
                    editedVideoFullscreen.seek(editedVideoFullscreen.position - 5000);
                else
                    editedVideoFullscreen.seek(0);
                if(!seekEditedVideo.visible)
                    seekEditedVideo.visible = true;
                hideEditedVideoSeek.stop();
            }
            Keys.onRightPressed: {
                if(editedVideoFullscreen.position + 5000 < editedVideoFullscreen.duration)
                    editedVideoFullscreen.seek(editedVideoFullscreen.position + 5000);
                else
                    editedVideoFullscreen.seek(editedVideoFullscreen.duration - 5);
                if(!seekEditedVideo.visible)
                    seekEditedVideo.visible = true;
                hideEditedVideoSeek.stop();
            }

            Keys.onReleased: {
                if(volumeEditedVideo.visible)
                    hideEditedVideoVolume.start()

                if(seekEditedVideo.visible)
                    hideEditedVideoSeek.start()
            }

            Keys.onSpacePressed:{
                if(!playPausedEditedVideos.visible)
                    playPausedEditedVideos.visible = true;
                if(editedVideoFullscreen.playbackState === MediaPlayer.PlayingState){
                    editedVideoFullscreen.pause();
                    playPausedEditedVideos.source = "./assets/pause.png";
                }else{
                    editedVideoFullscreen.play();
                    playPausedEditedVideos.source = "./assets/play.png";
                }
                hideEditedVideoPlayPaused.start();
            }

            Keys.onEscapePressed: editedVideoFullscreenWindow.close();


            Timer{
                id: hideEditedVideoVolume
                interval: 500;
                repeat: false;
                onTriggered: volumeEditedVideo.visible = false;
            }

            Timer{
                id: hideEditedVideoSeek
                interval: 500;
                repeat: false;
                onTriggered: seekEditedVideo.visible = false;
            }

            Timer{
                id: hideEditedVideoPlayPaused
                interval: 500;
                repeat: false;
                onTriggered: playPausedEditedVideos.visible = false;
            }

            //play/pause sign
            Image{
                id: playPausedEditedVideos
                x: editedVideoFullscreen.width / 2 - width / 2;
                y: editedVideoFullscreen.height / 2 - height / 2;
                source: "./assets/pause.png"
                visible: false
                fillMode: Image.PreserveAspectFit
            }

            //volume bar
            Rectangle {
                id: volumeEditedVideo
                anchors {
                    bottom: editedVideoFullscreen.bottom;
                    right: editedVideoFullscreen.right;
                    bottomMargin: 50;
                    rightMargin: 50;
                }
                color: "#FBBF21";
                width: 20;
                height: (editedVideoFullscreen.height - 100)*editedVideoFullscreen.volume;
                visible: false
                radius: 5
            }

            //seek bar
            Rectangle {
                id: seekEditedVideo
                anchors {
                    left: editedVideoFullscreen.left;
                    bottom: editedVideoFullscreen.bottom;
                    bottomMargin: 50;
                    leftMargin: 50;
                }
                color: "#FBBF21";
                height: 20;
                width: ((1.0*editedVideoFullscreen.position)/(1.0*editedVideoFullscreen.duration))*editedVideoFullscreen.width - 100.0;
                visible: false
                radius: 5
            }
        }

        Component.onCompleted: {
            x = Screen.width / 2 - width / 2
            y = Screen.height / 2 - height / 2
        }

        onClosing: {
            editedVideoFullscreen.stop()
            fileSource = "";
            name = "";
        }
    }
}
