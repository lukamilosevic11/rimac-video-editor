#ifndef DATABRIDGE_H
#define DATABRIDGE_H

#include <QObject>
#include <QColor>
#include <string>

class DataBridge : public QObject
{
    Q_OBJECT
    //Numerical
    Q_PROPERTY(bool numericalValueEnabled READ getNumericalValueEnabled WRITE setNumericalValueEnabled NOTIFY NumericalValueEnabledChanged)
    Q_PROPERTY(int numericalRandomValue READ getNumericalRandomValue WRITE setNumericalRandomValue NOTIFY NumericalRandomValueChanged)
    Q_PROPERTY(int numericalValueX READ getNumericalValueX WRITE setNumericalValueX NOTIFY NumericalValueXChanged)
    Q_PROPERTY(int numericalValueY READ getNumericalValueY WRITE setNumericalValueY NOTIFY NumericalValueYChanged)

    //Shape
    Q_PROPERTY(bool shapeValueEnabled READ getShapeValueEnabled WRITE setShapeValueEnabled NOTIFY ShapeValueEnabledChanged)
    Q_PROPERTY(int shapeValueX READ getShapeValueX WRITE setShapeValueX NOTIFY ShapeValueXChanged)
    Q_PROPERTY(int shapeValueY READ getShapeValueY WRITE setShapeValueY NOTIFY ShapeValueYChanged)
    Q_PROPERTY(QColor shapeColor1 READ getShapeColor1 WRITE setShapeColor1 NOTIFY ShapeColor1Changed)
    Q_PROPERTY(QColor shapeColor2 READ getShapeColor2 WRITE setShapeColor2 NOTIFY ShapeColor2Changed)

    //Slider
    Q_PROPERTY(bool sliderValueEnabled READ getSliderValueEnabled WRITE setSliderValueEnabled NOTIFY SliderValueEnabledChanged)
    Q_PROPERTY(int sliderValueX READ getSliderValueX WRITE setSliderValueX NOTIFY SliderValueXChanged)
    Q_PROPERTY(int sliderValueY READ getSliderValueY WRITE setSliderValueY NOTIFY SliderValueYChanged)
    Q_PROPERTY(int sliderCurrentValue READ getSliderCurrentValue WRITE setSliderCurrentValue NOTIFY SliderCurrentValueChanged)
    Q_PROPERTY(int sliderMaxValue READ getSliderMaxValue WRITE setSliderMaxValue NOTIFY SliderMaxValueChanged)
    Q_PROPERTY(int sliderMinValue READ getSliderMinValue WRITE setSliderMinValue NOTIFY SliderMinValueChanged)

    //Visibility of windows
    Q_PROPERTY(bool editedVideosThumbnails READ getEditedVideosThumbnails WRITE setEditedVideosThumbnails NOTIFY EditedVideosThumbnailsChanged)
    Q_PROPERTY(bool rawVideosThumbnails READ getRawVideosThumbnails WRITE setRawVideosThumbnails NOTIFY RawVideosThumbnailsChanged)
    Q_PROPERTY(bool rawVideosSettings READ getRawVideosSettings WRITE setRawVideosSettings NOTIFY RawVideosSettingsChanged)
    Q_PROPERTY(bool rawVideosEditing READ getRawVideosEditing WRITE setRawVideosEditing NOTIFY RawVideosEditingChanged)

    //Other
    Q_PROPERTY(QString fileName READ getFileName WRITE setFileName NOTIFY FileNameChanged)
    Q_PROPERTY(QString audioPath READ getAudioPath WRITE setAudioPath NOTIFY AudioPathChanged)
    Q_PROPERTY(bool editingFinished READ getEditingFinished WRITE setEditingFinished NOTIFY EditingFinishedChanged)

signals:
    //Numerical
    void NumericalValueEnabledChanged();
    void NumericalRandomValueChanged();
    void NumericalValueXChanged();
    void NumericalValueYChanged();

    //Shape
    void ShapeValueEnabledChanged();
    void ShapeValueXChanged();
    void ShapeValueYChanged();
    void ShapeColor1Changed();
    void ShapeColor2Changed();

    //Slider
    void SliderValueEnabledChanged();
    void SliderValueXChanged();
    void SliderValueYChanged();
    void SliderCurrentValueChanged();
    void SliderMaxValueChanged();
    void SliderMinValueChanged();

    //Visibility of windows
    void EditedVideosThumbnailsChanged();
    void RawVideosThumbnailsChanged();
    void RawVideosSettingsChanged();
    void RawVideosEditingChanged();

    //Other
    void EditingFinishedChanged();
    void FileNameChanged();
    void AudioPathChanged();
    void videoDone();

protected:
    static DataBridge* databridge_;

public:
    explicit DataBridge(QObject *parent = nullptr);
    DataBridge(DataBridge &other) = delete;
    void operator=(const DataBridge &) = delete;
    static DataBridge* GetInstance();

    //Numerical
    bool getNumericalValueEnabled() const;
    void setNumericalValueEnabled(bool value);

    int getNumericalRandomValue() const;
    void setNumericalRandomValue(int value);

    int getNumericalValueX() const;
    void setNumericalValueX(int value);

    int getNumericalValueY() const;
    void setNumericalValueY(int value);

    //Shape
    bool getShapeValueEnabled() const;
    void setShapeValueEnabled(bool value);

    int getShapeValueX() const;
    void setShapeValueX(int value);

    int getShapeValueY() const;
    void setShapeValueY(int value);

    QColor getShapeColor1() const;
    void setShapeColor1(const QColor &ShapeColor1);

    QColor getShapeColor2() const;
    void setShapeColor2(const QColor &ShapeColor2);

    //Slider
    bool getSliderValueEnabled() const;
    void setSliderValueEnabled(bool value);

    int getSliderValueX() const;
    void setSliderValueX(int value);

    int getSliderValueY() const;
    void setSliderValueY(int value);

    int getSliderCurrentValue() const;
    void setSliderCurrentValue(int value);

    int getSliderMaxValue() const;
    void setSliderMaxValue(int value);

    int getSliderMinValue() const;
    void setSliderMinValue(int value);

    //Visibility of Windows
    bool getEditedVideosThumbnails() const;
    void setEditedVideosThumbnails(bool EditedVideosThumbnails);

    bool getRawVideosThumbnails() const;
    void setRawVideosThumbnails(bool RawVideosThumbnails);

    bool getRawVideosSettings() const;
    void setRawVideosSettings(bool RawVideosSettings);

    bool getRawVideosEditing() const;
    void setRawVideosEditing(bool RawVideosEditing);

    //Other
    int getFrameRate() const;
    void setFrameRate(int FrameRate);

    QString getFileName() const;
    void setFileName(const QString &value);

    Q_INVOKABLE void createVideoFromImages() const;
    Q_INVOKABLE void checkIfFFMPEGIsFinished();
    Q_INVOKABLE void cleanupEditedImagesFolder() const;
    Q_INVOKABLE void deleteEditedVideo(const QString& filePath) const;
    QString getAudioPath() const;
    void setAudioPath(const QString &AudioPath);

    bool getEditingFinished() const;
    void setEditingFinished(bool EditingFinished);

private:
    static void createdVideoThread(int frameRate, const std::string& fileName, const std::string& audioPath);
    std::string getStdoutFromCommand(std::string cmd) const;

private:
    //Numerical
    bool m_NumericalValueEnabled;
    int m_NumericalRandomValue;
    int m_NumericalValueX;
    int m_NumericalValueY;

    //Shape
    bool m_ShapeValueEnabled;
    int m_ShapeValueX;
    int m_ShapeValueY;
    QColor m_ShapeColor1;
    QColor m_ShapeColor2;

    //Slider
    bool m_SliderValueEnabled;
    int m_SliderValueX;
    int m_SliderValueY;
    int m_SliderCurrentValue;
    int m_SliderMaxValue;
    int m_SliderMinValue;

    //Visibility of Windows
    bool m_EditedVideosThumbnails;
    bool m_RawVideosThumbnails;
    bool m_RawVideosSettings;
    bool m_RawVideosEditing;

    //Other
    int m_FrameRate;
    QString m_FileName;
    QString m_AudioPath;
    bool m_EditingFinished;
};

#endif // DATABRIDGE_H
