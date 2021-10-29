import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.3
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.folderlistmodel 2.15

//Settings page where we choose which overlays we use
Window {
    id: rawVideosSettings
    visible: true
    height: 300
    width: 500
    title: "Raw Video Settings"
    color: "#121212"
    maximumHeight: height
    minimumHeight: height
    maximumWidth: width
    minimumWidth: width


    ColumnLayout{
        id: columnVideoSettings
        anchors {
            fill: parent
            margins: 10
        }
        Layout.fillHeight: true;
        Layout.fillWidth: true;

        spacing: 10
        RowLayout {
            id: textRowVideoSettings
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            Layout.alignment: Qt.AlignCenter;
            Text {
                id: settingsText;
                text: qsTr("Please choose one or multiple Overlays");
                font.pointSize: 13;
                Layout.alignment: Qt.AlignCenter;
                color: "#FBBF21";
            }
        }

        //Numerical settings
        RowLayout {
            id: numericalRow
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            CheckBox {
                id: numericalCheckBox
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                Layout.maximumWidth: 100;
                checked: false
                text: "Numerical"
            }

            Label{
                id: numericalLabelX
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                text: "X"
            }
            SpinBox {
                id: numericalSpinBoxX
                value: 11
                Layout.alignment: Qt.AlignCenter;
                Layout.fillWidth: true;
                from: 10;
                to: 1800;// TODO: we should care about edge cases
                validator: IntValidator {
                    bottom: Math.min(numericalSpinBoxX.from, numericalSpinBoxX.to)
                    top: Math.max(numericalSpinBoxX.from, numericalSpinBoxX.to)
                }
            }
            Label{
                id: numericalLabelY
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                text: "Y"
            }
            SpinBox {
                id: numericalSpinBoxY
                value: 111
                Layout.alignment: Qt.AlignCenter;
                Layout.fillWidth: true;
                from: 10;
                to: 950; // TODO: we should care about edge cases
                validator: IntValidator {
                    bottom: Math.min(numericalSpinBoxY.from, numericalSpinBoxY.to)
                    top: Math.max(numericalSpinBoxY.from, numericalSpinBoxY.to)
                }
            }
        }

        //Shape settings
        RowLayout {
            id: shapeRow
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            CheckBox {
                id: shapeCheckBox
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                Layout.maximumWidth: 100;
                checked: false
                text: "Shape"
            }

            Label{
                id: shapeLabelX
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                text: "X"
            }
            SpinBox {
                id: shapeSpinBoxX
                value: 11
                Layout.alignment: Qt.AlignCenter;
                Layout.fillWidth: true;
                from: 10;
                to: 1800;// TODO: we should care about edge cases
                validator: IntValidator {
                    bottom: Math.min(shapeSpinBoxX.from, shapeSpinBoxX.to)
                    top: Math.max(shapeSpinBoxX.from, shapeSpinBoxX.to)
                }
            }
            Label{
                id: shapeLabelY
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                text: "Y"
            }
            SpinBox {
                id: shapeSpinBoxY
                value: 111
                Layout.alignment: Qt.AlignCenter;
                Layout.fillWidth: true;
                from: 10;
                to: 950; // TODO: we should care about edge cases
                validator: IntValidator {
                    bottom: Math.min(shapeSpinBoxY.from, shapeSpinBoxY.to)
                    top: Math.max(shapeSpinBoxY.from, shapeSpinBoxY.to)
                }
            }
        }

        //Slider settings
        RowLayout {
            id: sliderRow
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            CheckBox {
                id: sliderCheckBox
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                Layout.maximumWidth: 100;
                checked: false
                text: "Slider"
            }

            Label{
                id: sliderLabelX
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                text: "X"
            }
            SpinBox {
                id: sliderSpinBoxX
                value: 11
                Layout.alignment: Qt.AlignCenter;
                Layout.fillWidth: true;
                from: 10;
                to: 1300;// TODO: we should care about edge cases
                validator: IntValidator {
                    bottom: Math.min(sliderSpinBoxX.from, sliderSpinBoxX.to)
                    top: Math.max(sliderSpinBoxX.from, sliderSpinBoxX.to)
                }
            }
            Label{
                id: sliderLabelY
                Layout.alignment: Qt.AlignCenter;
                Layout.fillHeight: true;
                Layout.fillWidth: true;
                text: "Y"
            }
            SpinBox {
                id: sliderSpinBoxY
                value: 111
                Layout.alignment: Qt.AlignCenter;
                Layout.fillWidth: true;
                from: 10;
                to: 1070; // TODO: we should care about edge cases
                validator: IntValidator {
                    bottom: Math.min(sliderSpinBoxY.from, sliderSpinBoxY.to)
                    top: Math.max(sliderSpinBoxY.from, sliderSpinBoxY.to)
                }
            }
        }

        //Buttons apply and cancel
        RowLayout {
            id: buttonRowVideoSettings
            Layout.fillHeight: true;
            Layout.fillWidth: true;
            Layout.alignment: Qt.AlignCenter
            Button {
                id: applyButtonVideoSettings
                text: "Apply"
                Layout.alignment: Qt.AlignCenter

                ToolTip{
                    id: toolTip
                    text:"You must check at least one overlay!"
                    visible: false
                    timeout: 1500
                    delay: 0
                }

                onClicked: {
                    if(!numericalCheckBox.checked && !shapeCheckBox.checked && !sliderCheckBox.checked){
                        toolTip.visible = true;
                    }else{
                        //Numerical
                        _db.numericalValueEnabled = numericalCheckBox.checked;
                        _db.numericalValueX = numericalSpinBoxX.value;
                        _db.numericalValueY = numericalSpinBoxY.value;

                        //Shape
                        _db.shapeValueEnabled = shapeCheckBox.checked;
                        _db.shapeValueX = shapeSpinBoxX.value;
                        _db.shapeValueY = shapeSpinBoxY.value;
                        _db.shapeColor1 = Qt.rgba(Math.random(), Math.random(), Math.random(), 0.5);
                        _db.shapeColor2 = Qt.rgba(Math.random(), Math.random(), Math.random(), 0.5);

                        //Slider
                        _db.sliderValueEnabled = sliderCheckBox.checked;
                        _db.sliderValueX = sliderSpinBoxX.value;
                        _db.sliderValueY = sliderSpinBoxY.value;
                        _db.sliderCurrentValue = 0;
                        _db.sliderMinValue = 0;
                        _db.sliderMaxValue = 20;

                        let component = Qt.createComponent("rawVideoEditing.qml");

                        if(component.status === Component.Ready){
                            let createdObject = component.createObject(mainWindow);

                            if (createdObject !== null) {
                                print ("Component rawVideoEditing is now ready!");
                            } else {
                                print ("Object rawVideoEditing is null!");
                            }
                        }else if (component.status === Component.Error){
                            // Error Handling
                            console.log("Error loading component:", component.errorString());
                        }
                        rawVideosSettings.close();
                    }
                }
            }

            Button {
                id: canceButtonVideoSettings
                text: "Cancel"
                Layout.alignment: Qt.AlignCenter
                onClicked: {
                    rawVideosSettings.close();
                }
            }
        }
    }

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2;
        y = Screen.height / 2 - height / 2;
        _db.rawVideosSettings = true;
    }

    onClosing: {
        _db.rawVideosSettings = false;
    }

}
