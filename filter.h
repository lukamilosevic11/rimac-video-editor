#ifndef FILTER_H
#define FILTER_H

#include <QVideoFilterRunnable>
#include <QAbstractVideoFilter>
#include <QVideoFrame>

class FilterRunnable : public QVideoFilterRunnable
{
public:
    FilterRunnable();
    QVideoFrame run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat, RunFlags flags);

private:
    int m_NumberOfFrames;
};

class Filter : public QAbstractVideoFilter
{
public:
    QVideoFilterRunnable *createFilterRunnable() {

        return new FilterRunnable;
    }
};

#endif // FILTER_H
