#ifndef UTILITIES_H
#define UTILITIES_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRandomGenerator>
#include <QtMath>
#include <QCryptographicHash>
#include <fstream>
#include <string>

using namespace std;

// ==========================================
// LOGIN SYSTEM
// ==========================================
class StoreCredits : public QObject {
    Q_OBJECT
public:
    explicit StoreCredits(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE bool saveLogin(QString username, QString password) {
        string userStr = username.toStdString();

        // Hash the password using SHA-256
        QString hashedPass = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex();
        string passStr = hashedPass.toStdString();

        string line;

        ifstream readFile("loginInfo.txt");
        while (getline(readFile, line)) {
            size_t commaPos = line.find(',');
            if (commaPos != string::npos) {
                string existingUser = line.substr(0, commaPos);
                if (existingUser == userStr) {
                    readFile.close();
                    return false;
                }
            }
        }
        readFile.close();

        ofstream myFile("loginInfo.txt", ios::app);
        myFile << userStr << "," << passStr << endl;
        myFile.close();

        return true;
    }

    Q_INVOKABLE bool checkLogin(QString username, QString password) {
        string userStr = username.toStdString();

        // Hash the inputted password to compare with the stored hash
        QString hashedPass = QCryptographicHash::hash(password.toUtf8(), QCryptographicHash::Sha256).toHex();
        string passStr = hashedPass.toStdString();

        string line;

        ifstream readFile("loginInfo.txt");
        if (!readFile.is_open()) return false;

        while (getline(readFile, line)) {
            size_t commaPos = line.find(',');
            if (commaPos != string::npos) {
                string existingUser = line.substr(0, commaPos);
                string existingPass = line.substr(commaPos + 1);

                if (existingUser == userStr && existingPass == passStr) {
                    readFile.close();
                    return true;
                }
            }
        }
        readFile.close();
        return false;
    }
};

// ==========================================
// ISS LIVE API TRACKER
// ==========================================
class ISSAPI : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString latitude READ latitude NOTIFY dataChanged)
    Q_PROPERTY(QString longitude READ longitude NOTIFY dataChanged)
    Q_PROPERTY(QString altitude READ altitude NOTIFY dataChanged)
    Q_PROPERTY(QString velocity READ velocity NOTIFY dataChanged)
    Q_PROPERTY(QString country READ country NOTIFY dataChanged)

public:
    explicit ISSAPI(QObject *parent = nullptr) : QObject(parent) {
        manager = new QNetworkAccessManager(this);
        connect(manager, &QNetworkAccessManager::finished, this, &ISSAPI::onReplyFinished);

        QMetaObject::invokeMethod(this, "fetchLiveLocation", Qt::QueuedConnection);
    }

    Q_INVOKABLE void fetchLiveLocation() {
        QNetworkRequest request(QUrl("https://api.wheretheiss.at/v1/satellites/25544"));
        manager->get(request);
    }

    QString latitude() const { return m_lat; }
    QString longitude() const { return m_lon; }
    QString altitude() const { return m_alt; }
    QString velocity() const { return m_vel; }
    QString country() const { return m_country; }

signals:
    void dataChanged();

private slots:
    void onReplyFinished(QNetworkReply *reply) {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray responseData = reply->readAll();
            QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
            QJsonObject jsonObj = jsonDoc.object();

            m_lat = QString::number(jsonObj["latitude"].toDouble(), 'f', 2);
            m_lon = QString::number(jsonObj["longitude"].toDouble(), 'f', 2);
            m_alt = QString::number(jsonObj["altitude"].toDouble(), 'f', 2);
            m_vel = QString::number(jsonObj["velocity"].toDouble(), 'f', 2);

            emit dataChanged();
            fetchCountryName(m_lat, m_lon);
        }
        reply->deleteLater();
    }

private:
    void fetchCountryName(const QString& lat, const QString& lon) {
        QString urlStr = QString("https://nominatim.openstreetmap.org/reverse?lat=%1&lon=%2&format=json&zoom=3").arg(lat, lon);
        QNetworkRequest request((QUrl(urlStr)));

        request.setRawHeader("User-Agent", "JASAEspacio App/1.0");

        QNetworkAccessManager *geoManager = new QNetworkAccessManager(this);
        QNetworkReply *geoReply = geoManager->get(request);

        connect(geoReply, &QNetworkReply::finished, this, [this, geoReply, geoManager]() {
            if (geoReply->error() == QNetworkReply::NoError) {
                QJsonDocument jsonDoc = QJsonDocument::fromJson(geoReply->readAll());
                QJsonObject jsonObj = jsonDoc.object();

                if (jsonObj.contains("error")) {
                    m_country = "Over the Ocean";
                } else if (jsonObj.contains("address")) {
                    m_country = jsonObj["address"].toObject()["country"].toString("Unknown");
                } else {
                    m_country = "Over the Ocean";
                }

                emit dataChanged();
            }
            geoReply->deleteLater();
            geoManager->deleteLater();
        });
    }

    QNetworkAccessManager *manager;
    QString m_lat = "---";
    QString m_lon = "---";
    QString m_alt = "---";
    QString m_vel = "---";
    QString m_country = "Loading...";
};

// ==========================================
// STARGAZE WEATHER API
// ==========================================
class StargazeWeatherAPI : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString cityName      READ cityName      NOTIFY dataChanged)
    Q_PROPERTY(QString condition      READ condition      NOTIFY dataChanged)
    Q_PROPERTY(QString conditionIcon READ conditionIcon NOTIFY dataChanged)
    Q_PROPERTY(int     aqi            READ aqi            NOTIFY dataChanged)
    Q_PROPERTY(QString aqiLabel      READ aqiLabel      NOTIFY dataChanged)
    Q_PROPERTY(int     bortle         READ bortle         NOTIFY dataChanged)
    Q_PROPERTY(QString bortleDesc    READ bortleDesc    NOTIFY dataChanged)
    Q_PROPERTY(double  stargazeScore READ stargazeScore NOTIFY dataChanged)
    Q_PROPERTY(QString insight        READ insight        NOTIFY dataChanged)
    Q_PROPERTY(bool    loading        READ loading        NOTIFY loadingChanged)

public:
    explicit StargazeWeatherAPI(QObject *parent = nullptr) : QObject(parent) {
        m_manager = new QNetworkAccessManager(this);
        QMetaObject::invokeMethod(this, "fetchData", Qt::QueuedConnection);
    }

    Q_INVOKABLE void fetchData() {
        m_loading = true;
        emit loadingChanged();

        QNetworkRequest req(QUrl("https://ipinfo.io/json"));
        req.setRawHeader("Accept", "application/json");
        QNetworkReply *reply = m_manager->get(req);

        connect(reply, &QNetworkReply::finished, this, [this, reply]() {
            if (reply->error() == QNetworkReply::NoError) {
                QJsonDocument doc  = QJsonDocument::fromJson(reply->readAll());
                QJsonObject   obj  = doc.object();

                m_cityName = obj["city"].toString("Unknown");

                QString loc = obj["loc"].toString("0,0");
                QStringList parts = loc.split(",");
                if (parts.size() == 2) {
                    m_lat = parts[0].toDouble();
                    m_lon = parts[1].toDouble();
                }

                m_pendingCount = 3;
                fetchWeather();
                fetchAQI();
                fetchLightPollution();

            } else {
                m_cityName = "Unavailable";
                m_loading  = false;
                emit loadingChanged();
                emit dataChanged();
            }
            reply->deleteLater();
        });
    }

    QString cityName()      const { return m_cityName; }
    QString condition()     const { return m_condition; }
    QString conditionIcon() const { return m_conditionIcon; }
    int     aqi()           const { return m_aqi; }
    double  stargazeScore() const { return m_stargazeScore; }
    bool    loading()       const { return m_loading; }
    int     bortle()        const { return m_bortle; }
    QString bortleDesc()    const { return m_bortleDesc; }

    QString insight() const {
        if (m_weatherCode >= 95)                                return "Thunderstorm — no chance tonight";
        if (m_weatherCode >= 71 && m_weatherCode <= 77) return "Snowfall obscuring the sky";
        if (m_weatherCode >= 51)                                return "Precipitation blocking all observation";
        if (m_weatherCode >= 45)                                return "Fog — sky completely obscured";
        if (m_cloudCover > 80)                                  return "Heavy overcast — wait for a clear night";
        if (m_cloudCover > 60)                                  return "Mostly cloudy — marginal at best";
        if (m_cloudCover > 30)                                  return "Partial clouds, observe in clear gaps";

        if (m_bortle >= 9) return "Severe light pollution dominates";
        if (m_bortle >= 8) return "Heavy city glow is your main obstacle";
        if (m_bortle >= 7) return "Urban light pollution limits the sky";
        if (m_bortle >= 6) return "Suburban glow washing out faint objects";
        if (m_bortle >= 5) return "Milky Way barely visible on best nights";

        if (m_aqi > 150)   return "Poor air quality degrading transparency";
        if (m_aqi > 100)   return "Hazy air reducing limiting magnitude";
        if (m_bortle <= 2) return "Pristine sky — exceptional night!";
        if (m_bortle <= 3) return "Excellent dark sky — Milky Way structure visible";
        if (m_bortle <= 4) return "Good rural sky — faint DSOs within reach";
        return "Decent conditions for tonight";
    }

    QString aqiLabel() const {
        if (m_aqi <= 50)  return "Good";
        if (m_aqi <= 100) return "Moderate";
        if (m_aqi <= 150) return "Sensitive Groups";
        if (m_aqi <= 200) return "Unhealthy";
        if (m_aqi <= 300) return "Very Unhealthy";
        return "Hazardous";
    }

signals:
    void dataChanged();
    void loadingChanged();

private:
    void fetchWeather() {
        QString url = QString(
                          "https://api.open-meteo.com/v1/forecast"
                          "?latitude=%1&longitude=%2"
                          "&current=cloud_cover,weather_code&timezone=auto"
                          ).arg(m_lat).arg(m_lon);

        QNetworkReply *r = m_manager->get(QNetworkRequest(QUrl(url)));
        connect(r, &QNetworkReply::finished, this, [this, r]() {
            if (r->error() == QNetworkReply::NoError) {
                QJsonObject current = QJsonDocument::fromJson(r->readAll())
                .object()["current"].toObject();
                int wcode   = current["weather_code"].toInt(0);
                m_cloudCover = current["cloud_cover"].toInt(50);
                m_condition      = weatherCodeToString(wcode);
                m_conditionIcon  = weatherCodeToIcon(wcode);
                m_weatherCode    = wcode;
            }
            r->deleteLater();
            checkAndFinalize();
        });
    }

    void fetchAQI() {
        QString url = QString(
                          "https://air-quality-api.open-meteo.com/v1/air-quality"
                          "?latitude=%1&longitude=%2&current=us_aqi"
                          ).arg(m_lat).arg(m_lon);

        QNetworkReply *r = m_manager->get(QNetworkRequest(QUrl(url)));
        connect(r, &QNetworkReply::finished, this, [this, r]() {
            if (r->error() == QNetworkReply::NoError) {
                m_aqi = QJsonDocument::fromJson(r->readAll())
                .object()["current"].toObject()["us_aqi"].toInt(50);
            }
            r->deleteLater();
            checkAndFinalize();
        });
    }

    void fetchLightPollution() {
        QString url = QString(
                          "https://www.lightpollutionmap.info/QueryRaster/"
                          "?ql=wa_2015&qt=point&qd=%1,%2"
                          ).arg(m_lon).arg(m_lat);

        QNetworkRequest req{QUrl(url)};
        req.setRawHeader("User-Agent", "JASAEspacio App/1.0");

        QNetworkReply *r = m_manager->get(req);
        connect(r, &QNetworkReply::finished, this, [this, r]() {
            if (r->error() == QNetworkReply::NoError) {
                QJsonObject result = QJsonDocument::fromJson(r->readAll())
                .object()["result"].toObject();
                double radiance = result["1"].toObject()["val"].toDouble(-1.0);

                m_bortle = (radiance >= 0.0) ? radianceToBortle(radiance) : 9;
            } else {
                m_bortle = 9;
            }
            m_bortleDesc = bortleDescription(m_bortle);
            r->deleteLater();
            checkAndFinalize();
        });
    }

    void checkAndFinalize() {
        m_pendingCount--;
        if (m_pendingCount <= 0) {
            computeStargazeScore();
            m_loading = false;
            emit dataChanged();
            emit loadingChanged();
        }
    }

    void computeStargazeScore() {
        bool isPrecip = (m_weatherCode >= 51 && m_weatherCode <= 99);
        bool isFog    = (m_weatherCode >= 45 && m_weatherCode <= 48);
        if (isPrecip) { m_stargazeScore = 0.01 + (QRandomGenerator::global()->bounded(4)) * 0.01; return; }
        if (isFog)    { m_stargazeScore = 0.02 + (QRandomGenerator::global()->bounded(3)) * 0.01; return; }

        if (m_cloudCover > 80) {
            m_stargazeScore = 0.01 + (m_cloudCover > 95 ? 0.0 : 0.07 * (1.0 - (m_cloudCover - 80) / 20.0));
            return;
        }

        double bortleRaw;
        switch (m_bortle) {
        case 1:  bortleRaw = 100; break;
        case 2:  bortleRaw = 88;  break;
        case 3:  bortleRaw = 74;  break;
        case 4:  bortleRaw = 58;  break;
        case 5:  bortleRaw = 42;  break;
        case 6:  bortleRaw = 26;  break;
        case 7:  bortleRaw = 15;  break;
        case 8:  bortleRaw = 7;   break;
        case 9:  bortleRaw = 2;   break;
        default: bortleRaw = 2;
        }

        double aqiRaw;
        if      (m_aqi <= 50)  aqiRaw = 100;
        else if (m_aqi <= 100) aqiRaw = 80;
        else if (m_aqi <= 150) aqiRaw = 55;
        else if (m_aqi <= 200) aqiRaw = 30;
        else                   aqiRaw = 8;

        double cloudRaw;
        if      (m_cloudCover <= 15) cloudRaw = 100;
        else if (m_cloudCover <= 30) cloudRaw = 82;
        else if (m_cloudCover <= 50) cloudRaw = 55;
        else if (m_cloudCover <= 65) cloudRaw = 25;
        else                         cloudRaw = 8;

        double raw = (bortleRaw * 0.80) + (aqiRaw * 0.10) + (cloudRaw * 0.10);
        if (m_cloudCover > 65) raw = qMin(raw, 20.0);

        m_stargazeScore = qMin(1.0, qMax(0.01, raw / 100.0));
    }

    QString weatherCodeToString(int code) const {
        if (code == 0)              return "Clear Sky";
        if (code <= 3)              return "Partly Cloudy";
        if (code <= 48)             return "Foggy";
        if (code <= 55)             return "Drizzle";
        if (code <= 67)             return "Rainy";
        if (code <= 77)             return "Snowy";
        if (code <= 82)             return "Rain Showers";
        if (code <= 86)             return "Snow Showers";
        return "Thunderstorm";
    }

    QString weatherCodeToIcon(int code) const {
        if (code == 0)  return "✦";
        if (code <= 3)  return "◑";
        if (code <= 48) return "≋";
        if (code <= 67) return "▽";
        if (code <= 77) return "✻";
        if (code <= 82) return "▽";
        return "⚡";
    }

    int radianceToBortle(double radiance) const {
        if (radiance <  0.01) return 1;
        if (radiance <  0.10) return 2;
        if (radiance <  0.32) return 3;
        if (radiance <  1.00) return 4;
        if (radiance <  3.16) return 5;
        if (radiance < 10.00) return 6;
        if (radiance < 31.60) return 7;
        if (radiance < 100.0) return 8;
        return 9;
    }

    QString bortleDescription(int bortle) const {
        switch (bortle) {
        case 1:  return "Pristine Dark Sky";
        case 2:  return "Truly Dark Sky";
        case 3:  return "Rural Sky";
        case 4:  return "Rural / Suburban";
        case 5:  return "Suburban Sky";
        case 6:  return "Bright Suburban";
        case 7:  return "Suburban / Urban";
        case 8:  return "City Sky";
        case 9:  return "Inner-City Sky";
        default: return "Urban Estimate";
        }
    }

    QNetworkAccessManager *m_manager = nullptr;
    int    m_pendingCount  = 0;
    bool   m_loading       = false;
    double m_lat           = 0.0;
    double m_lon           = 0.0;
    QString m_cityName     = "Locating...";
    QString m_condition    = "---";
    QString m_conditionIcon = "•";
    int     m_aqi          = 0;
    int     m_cloudCover   = 0;
    int     m_weatherCode  = 0;
    int     m_bortle       = 9;
    QString m_bortleDesc   = "---";
    double  m_stargazeScore = 0.0;
};

#endif // UTILITIES_H
