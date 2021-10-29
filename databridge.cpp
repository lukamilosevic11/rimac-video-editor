#include "databridge.h"
#include <filesystem>
#include <cstdlib>
#include <string>
#include <thread>
#include <QtConcurrent/QtConcurrent>
#include <stdio.h>
#include <iostream>

DataBridge* DataBridge::databridge_= nullptr;

DataBridge::DataBridge(QObject *parent)
    : QObject(parent)
    , m_EditedVideosThumbnails(false)
    , m_RawVideosThumbnails(false)
    , m_RawVideosSettings(false)
    , m_RawVideosEditing(false)
    , m_EditingFinished(false)
{}

DataBridge *DataBridge::GetInstance()
{
    if(databridge_ == nullptr){
        databridge_ = new DataBridge();
    }

    return databridge_;
}

//Numerical
bool DataBridge::getNumericalValueEnabled() const
{
    return m_NumericalValueEnabled;
}

void DataBridge::setNumericalValueEnabled(bool value)
{
    if(value != m_NumericalValueEnabled){
        m_NumericalValueEnabled = value;
        emit NumericalValueEnabledChanged();
    }
}

int DataBridge::getNumericalRandomValue() const
{
    return m_NumericalRandomValue;
}

void DataBridge::setNumericalRandomValue(int value)
{
    if(value != m_NumericalRandomValue){
        m_NumericalRandomValue = value;
        emit NumericalRandomValueChanged();
    }
}

int DataBridge::getNumericalValueX() const
{
    return m_NumericalValueX;
}

void DataBridge::setNumericalValueX(int value)
{
    if(value != m_NumericalValueX){
        m_NumericalValueX = value;
        emit NumericalValueXChanged();
    }
}

int DataBridge::getNumericalValueY() const
{
    return m_NumericalValueY;
}

void DataBridge::setNumericalValueY(int value)
{
    if(value != m_NumericalValueY){
        m_NumericalValueY = value;
        emit NumericalValueYChanged();
    }
}

//Shape
bool DataBridge::getShapeValueEnabled() const
{
    return m_ShapeValueEnabled;
}

void DataBridge::setShapeValueEnabled(bool value)
{
     if(value != m_ShapeValueEnabled){
         m_ShapeValueEnabled = value;
         emit ShapeValueEnabledChanged();
     }
}

int DataBridge::getShapeValueX() const
{
    return m_ShapeValueX;
}

void DataBridge::setShapeValueX(int value)
{
     if(value != m_ShapeValueX){
         m_ShapeValueX = value;
         emit ShapeValueXChanged();
     }
}

int DataBridge::getShapeValueY() const
{
    return m_ShapeValueY;
}

void DataBridge::setShapeValueY(int value)
{
    if(value != m_ShapeValueY){
        m_ShapeValueY = value;
        emit ShapeValueYChanged();
    }
}

QColor DataBridge::getShapeColor1() const
{
    return m_ShapeColor1;
}

void DataBridge::setShapeColor1(const QColor &value)
{
    if(value != m_ShapeColor1){
        m_ShapeColor1 = value;
        emit ShapeColor1Changed();
    }
}

QColor DataBridge::getShapeColor2() const
{
    return m_ShapeColor2;
}

void DataBridge::setShapeColor2(const QColor &value)
{
    if(value != m_ShapeColor2){
        m_ShapeColor2 = value;
        emit ShapeColor2Changed();
    }
}

//Slider
bool DataBridge::getSliderValueEnabled() const
{
    return m_SliderValueEnabled;
}

void DataBridge::setSliderValueEnabled(bool value)
{
    if(value != m_SliderValueEnabled){
        m_SliderValueEnabled = value;
        emit SliderValueEnabledChanged();
    }
}

int DataBridge::getSliderValueX() const
{
    return m_SliderValueX;
}

void DataBridge::setSliderValueX(int value)
{
    if(value != m_SliderValueX){
        m_SliderValueX = value;
        emit SliderValueXChanged();
    }
}

int DataBridge::getSliderValueY() const
{
    return m_SliderValueY;
}

void DataBridge::setSliderValueY(int value)
{
    if(value != m_SliderValueY){
        m_SliderValueY = value;
        emit SliderValueYChanged();
    }
}

int DataBridge::getSliderCurrentValue() const
{
    return m_SliderCurrentValue;
}

void DataBridge::setSliderCurrentValue(int value)
{
    if(value != m_SliderCurrentValue){
        m_SliderCurrentValue = value;
        emit SliderCurrentValueChanged();
    }
}

int DataBridge::getSliderMaxValue() const
{
    return m_SliderMaxValue;
}

void DataBridge::setSliderMaxValue(int value)
{
    if(value != m_SliderMaxValue){
        m_SliderMaxValue = value;
        emit SliderMaxValueChanged();
    }
}

int DataBridge::getSliderMinValue() const
{
    return m_SliderMinValue;
}

void DataBridge::setSliderMinValue(int value)
{
    if(value != m_SliderMinValue){
        m_SliderMinValue = value;
        emit SliderMinValueChanged();
    }
}

//Visibility of Windows
bool DataBridge::getEditedVideosThumbnails() const
{
    return m_EditedVideosThumbnails;
}

void DataBridge::setEditedVideosThumbnails(bool value)
{
    if(value != m_EditedVideosThumbnails){
        m_EditedVideosThumbnails = value;
        emit EditedVideosThumbnailsChanged();
    }
}

bool DataBridge::getRawVideosThumbnails() const
{
    return m_RawVideosThumbnails;
}

void DataBridge::setRawVideosThumbnails(bool value)
{
    if(value != m_RawVideosThumbnails){
        m_RawVideosThumbnails = value;
        emit RawVideosThumbnailsChanged();
    }
}

bool DataBridge::getRawVideosSettings() const
{
    return m_RawVideosSettings;
}

void DataBridge::setRawVideosSettings(bool value)
{
    if(value != m_RawVideosSettings){
        m_RawVideosSettings = value;
        emit RawVideosSettingsChanged();
    }
}

bool DataBridge::getRawVideosEditing() const
{
    return m_RawVideosEditing;
}

void DataBridge::setRawVideosEditing(bool value)
{
    if(value != m_RawVideosEditing){
        m_RawVideosEditing = value;
        emit RawVideosEditingChanged();
    }
}

//Other
int DataBridge::getFrameRate() const
{
    return m_FrameRate;
}

void DataBridge::setFrameRate(int FrameRate)
{
    m_FrameRate = FrameRate;
}

QString DataBridge::getFileName() const
{
    return m_FileName;
}

void DataBridge::setFileName(const QString &value)
{
    if(value != m_FileName){
        m_FileName = value;
        emit FileNameChanged();
    }
}

//using different thread because we don't want to GUI stuck
void DataBridge::createVideoFromImages() const
{
    QtConcurrent::run(DataBridge::createdVideoThread, m_FrameRate, m_FileName.toStdString(), m_AudioPath.toStdString());
}

//checking if ffmpeg is finished with creating video
void DataBridge::checkIfFFMPEGIsFinished()
{
    std::string data = getStdoutFromCommand("ps aux | pgrep -i '[f]fmpeg'");
    if(data == ""){
        setEditingFinished(true);
        emit videoDone();
    }
}

//remove frame images from editedImages folder inside project
void DataBridge::cleanupEditedImagesFolder() const
{
    for (auto& path: std::filesystem::directory_iterator("./editedImages")) {
        std::filesystem::remove_all(path);
    }
}

//remove video from filePath
void DataBridge::deleteEditedVideo(const QString &filePath) const
{
    std::filesystem::remove(filePath.toStdString());
}

//thread function where we create video from frame images and adding sound from original video
void DataBridge::createdVideoThread(int frameRate, const std::string& fileName, const std::string& audioPath)
{
    //create video from images and copy audio
    std::system(("ffmpeg -y -framerate " + std::to_string(frameRate) + " -i ./editedImages/%d.jpg -i " + audioPath + " -c copy -map 0:v? -map 1:a? -shortest ./editedVideos/" + fileName + "_edited.mp4").c_str());
    //clean images from editedImages folder
    for (auto& path: std::filesystem::directory_iterator("./editedImages")) {
        std::filesystem::remove_all(path);
    }
}

//helper function for reading system commands output
std::string DataBridge::getStdoutFromCommand(std::string cmd) const
{
    std::string data;
    FILE * stream;
    const int max_buffer = 256;
    char buffer[max_buffer];
    cmd.append(" 2>&1");

    stream = popen(cmd.c_str(), "r");

    if (stream) {
      while (!feof(stream))
        if (fgets(buffer, max_buffer, stream) != NULL) data.append(buffer);
      pclose(stream);
    }
    return data;
}

bool DataBridge::getEditingFinished() const
{
    return m_EditingFinished;
}

void DataBridge::setEditingFinished(bool value)
{
    if(value != m_EditingFinished){
        m_EditingFinished = value;
        emit EditingFinishedChanged();
    }
}

QString DataBridge::getAudioPath() const
{
    return m_AudioPath;
}

void DataBridge::setAudioPath(const QString &value)
{
    if(value != m_AudioPath){
        m_AudioPath = value;
        emit AudioPathChanged();
    }
}


