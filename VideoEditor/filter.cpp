#include "filter.h"
#include <iostream>
#include <random>
#include <iostream>

#include <QPainter>
#include <QPainterPath>
#include "databridge.h"
#include <filesystem>

FilterRunnable::FilterRunnable()
    : m_NumberOfFrames(0)
{
    //clean folder where we store frame images
    for (auto& path: std::filesystem::directory_iterator("./editedImages")) {
        std::filesystem::remove_all(path);
    }
}

//function which executes on each frame
QVideoFrame FilterRunnable::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, QVideoFilterRunnable::RunFlags flags)
{
    Q_UNUSED(flags)
    DataBridge* db = DataBridge::GetInstance();
    db->setFrameRate(surfaceFormat.frameRate());
    //creating image of the current frame
    QImage img = input->image();
    QPainter painter(&img);

    //draw numerical values on image
    if(db->getNumericalValueEnabled()){
        painter.setFont(QFont("times",40));
        QPen pen;
        pen.setWidth(20);
        pen.setColor(QColor("#FBBF21"));
        painter.setPen(pen);
        painter.drawText(db->getNumericalValueX(),db->getNumericalValueY(), QString::number(db->getNumericalRandomValue()));
    }

    //draw shapes on image
    if(db->getShapeValueEnabled()){
        QColor color1 = db->getShapeColor1();
        QColor color2 = db->getShapeColor2();
        int x1 = db->getShapeValueX();
        int y1 = db->getShapeValueY();
        QLinearGradient lg(x1, y1, x1+100, y1+100);
        lg.setColorAt(0, color1);
        lg.setColorAt(1, color2);
        painter.fillRect(x1, y1, 100, 100, lg);
    }

    //draw slider on image
    if(db->getSliderValueEnabled()){
        int x = db->getSliderValueX();
        int y = db->getSliderValueY();
        QPen pen(Qt::black, 3);
        painter.setPen(pen);
        QPainterPath path;
        path.addRoundedRect(x, y, 600, 10, 5, 5);
        painter.fillPath(path, QColor("#FBBF21"));
        painter.drawPath(path);
        QPainterPath pathLoading;
        float loadingWidth = ((float)db->getSliderCurrentValue() / db->getSliderMaxValue()) * 600.0;
        pathLoading.addRoundedRect(x, y, loadingWidth, 10, 5, 5);
        painter.fillPath(pathLoading, Qt::gray);
        painter.drawPath(pathLoading);
    }

    painter.end();
    img.save("./editedImages/" + QString::number(m_NumberOfFrames++) + ".jpg");

    return img;
}
