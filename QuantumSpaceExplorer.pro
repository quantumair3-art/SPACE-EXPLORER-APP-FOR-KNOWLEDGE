
QT += quick quickcontrols2 network

CONFIG += c++17 resources_big

SOURCES += \
    NewsManager.cpp \
    VoyagerManager.cpp \
    ReportManager.cpp \
    main.cpp

HEADERS += \
    NewsManager.h \
    VoyagerManager.h \
    ReportManager.h

RESOURCES += \
    qml.qrc \
    assets.qrc \
    planets.qrc
