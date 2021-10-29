import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.folderlistmodel 2.15
import vEditor 1.0

//Page where we show editing progress
Window {
    property bool isCanceled: false;
    property bool slideRight: true;

    id: rawVideosEditing
    visible: true
    height: 600
    width: 1000
    title: "Raw Video Editing"
    color: "#121212"

    //We are using MediaPlayer, VideoOutput and Filter
    //We are showing filtered frames on VideoOutput from original Video from MediaPlayer
    MediaPlayer {
        id: player
        source: mainWindow.rawVideoForEdit
        autoPlay: true
        onStopped: {
            console.log("editing done");
            if(!isCanceled)
                _db.createVideoFromImages();
        }
    }

    Filter { id: filter }

    //Editing progress
    ColumnLayout{
        id: columnVideoEditing
        anchors{
            fill: parent
            margins: 10
        }
        Layout.fillHeight: true;
        Layout.fillWidth: true;
        spacing: 10
        visible: true
        VideoOutput {
            id: rawVideoOutputEditing
            source: player
            filters: [ filter ]
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            Layout.alignment: Qt.AlignCenter;
        }
        RowLayout{
            id: rowVideoEditing
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            Layout.alignment: Qt.AlignCenter;

            BusyIndicator {
                id: busyIndicatorVideoEditing
                Layout.fillHeight: true;
                running: progressVideoEditing.value < 100
            }
            Label{
                id: labelProgressVideoEditing
                Layout.alignment: Qt.AlignRight
                Layout.fillHeight: true;
                text: progressVideoEditing.value < 100 ? "Editing..." : "Editing finished!";
            }

            ProgressBar {
                id: progressVideoEditing
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                from: 0
                value: ((player.position/player.duration)*100).toFixed()
                to: 100
                onValueChanged: {
                    if(value === 100) showFinalizingEditingColumn.start()
                }
            }
            Label{
                id: labelPercentageVideoEditing
                Layout.alignment: Qt.AlignLeft
                Layout.fillHeight: true;
                text: progressVideoEditing.value + "%"
            }

            Button{
                id: cancelEditingVideo
                Layout.alignment: Qt.AlignCenter
                text: "Cancel"
                onClicked: {
                    _db.cleanupEditedImagesFolder();
                    isCanceled = true;
                    player.stop();
                    rawVideosEditing.destroy();
                }
            }
        }
    }

    //If we need to wait for ffmpeg to finish we use this to notify user that we have still something to do
    ColumnLayout{
        id: columnFinalizingVideoEditing
        anchors{
            fill: parent
            margins: 10
        }

        Layout.fillHeight: true;
        Layout.fillWidth: true;
        spacing: 10
        visible: false

        Text {
            id: finalizingEditingText
            text: "Setting up video... Please wait! We are almost done."
            color: "#FBBF21"
            font.pointSize: 25
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter;
        }

        ProgressBar {
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            Layout.alignment: Qt.AlignCenter
            Layout.maximumHeight: 100;
            Layout.maximumWidth: columnFinalizingVideoEditing.width - columnFinalizingVideoEditing.width/3;
            indeterminate: true
        }
    }

    //Finally we are showing message that everything is done
    Text {
        id: doneTextEditingVideo
        visible: false;
        text: "Video is done. You can find it inside *editedVideos* folder"
        color: "#FBBF21"
        font.pointSize: 25
        x: parent.width/2 - doneTextEditingVideo.width/2;
        y: parent.height/2 - doneTextEditingVideo.height/2;
    }

    //Catchs signal from c++ that we are done with ffmpeg
    Connections {
        target: _db
        function onVideoDone(){
            checkForFFMPEG.stop();
            columnFinalizingVideoEditing.visible = false;
            doneTextEditingVideo.visible = true;
            killVideoEditingPage.start();
        }
    }

    //Kill this page when we show done message
    Timer {
        id: killVideoEditingPage
        interval: 2000
        repeat: false
        onTriggered: {
            rawVideosEditing.destroy();
        }
    }

    //Checking if ffmpeg is finished
    Timer{
        id: checkForFFMPEG
        interval: 100
        repeat: true
        onTriggered: {
            _db.checkIfFFMPEGIsFinished();
        }
    }

    //Shows Component which notify user that we should wait ffmpeg
    Timer {
        id: showFinalizingEditingColumn
        interval: 300
        repeat: false
        onTriggered: {
            columnFinalizingVideoEditing.visible = true;
            columnVideoEditing.visible = false;
            checkForFFMPEG.start();
        }

    }

    //Timer for numerical random values
    Timer{
        id: numericalTimer
        interval: 300
        repeat: true
        running: true
        onTriggered: {
            _db.numericalRandomValue = (Math.random()*555).toFixed();
        }
    }

    //Timer for shapes random values
    Timer{
        id: shapeTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            _db.shapeValueX = (Math.random() * (rawVideoOutputEditing.width-110)) + 10;
            _db.shapeValueY = (Math.random() * (rawVideoOutputEditing.height - 110)) + 10;
            _db.shapeColor1 = Qt.rgba(Math.random(), Math.random(), Math.random(), 0.5);
            _db.shapeColor2 = Qt.rgba(Math.random(), Math.random(), Math.random(), 0.5);
        }
    }

    //Timer which updates current value of progress bar
    Timer{
        id: sliderTimer
        interval: 500
        repeat: true
        running: true
        onTriggered: {
            if(_db.sliderCurrentValue == _db.sliderMaxValue){
                slideRight = false;
            }else if(_db.sliderCurrentValue == _db.sliderMinValue){
                slideRight = true;
            }

            if(slideRight){
                _db.sliderCurrentValue = _db.sliderCurrentValue + 1;
            }else{
                _db.sliderCurrentValue = _db.sliderCurrentValue - 1;
            }
        }
    }

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2;
        y = Screen.height / 2 - height / 2;
        _db.rawVideosEditing = true;
        isCanceled = false;
        slideRight = true;
    }

    Component.onDestruction: {
        _db.rawVideosEditing = false;
        player.stop();
        mainWindow.rawVideoForEdit = "";
        _db.rawVideosEditing = false;
    }

    onClosing: {
        player.stop();
        mainWindow.rawVideoForEdit = "";
        _db.rawVideosEditing = false;
        rawVideosEditing.destroy();
    }

}
