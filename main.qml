import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    visible: true
    width: 1400
    height: 850
    title: "Quantum Space Explorer"
    color: "#02050a"
    Connections {
        target: newsManager

        function onNewsReady(json) {
            console.log("NEWS RECEIVED FROM NASA")

            newsModel.clear()

            var articles = JSON.parse(json)

            for (var i = 0; i < articles.length; i++) {
                newsModel.append({
                    title: articles[i].title,
                    description: articles[i].description,
                    link: articles[i].link,
                    date: articles[i].date,
                    source: articles[i].source
                })
            }

            newsLoading = false
            newsRequestRunning = false
            newsStatus = newsModel.count > 0
                    ? "LIVE NASA SPACE NEWS"
                    : "NO NEWS ARTICLES FOUND"

            newsLastUpdated =
                    Qt.formatDateTime(new Date(), "dd MMM yyyy • hh:mm")

            console.log("Articles:", newsModel.count)
        }

        function onNewsError(message) {
            console.log("NEWS ERROR:", message)

            newsLoading = false
            newsRequestRunning = false
            newsError = message
            newsStatus = "NEWS COULD NOT BE LOADED"
        }
    }

    property string currentPage: "home"

    // ============================================================
    // LIVE NASA SPACE NEWS STATE
    // ============================================================

    property bool newsLoading: false
    property bool newsRequestRunning: false
    property string newsStatus: "READY"
    property string newsLastUpdated: "Never"
    property string newsError: ""

    ListModel {
        id: newsModel
    }

    // Deep Space becomes an immersive full-window experience.
    onCurrentPageChanged: {
        if (currentPage === "spaceTheory") {
            visibility = Window.FullScreen
        } else if (visibility === Window.FullScreen) {
            visibility = Window.Windowed
        }
    }

    // Selected planet information
    property string selectedPlanetName: ""
    property string selectedPlanetImage: ""
    property string selectedPlanetDescription: ""
    property string selectedPlanetType: ""
    property string selectedPlanetMoons: ""
    property string selectedPlanetDistance: ""
    property string selectedPlanetTemperature: ""

    // ============================================================
    // GLOBAL APP SEARCH
    // Searches content that already exists inside the application.
    // ============================================================

    property bool searchOpen: false
    property string searchQuery: ""
    property string pioneerDetailsName: ""

    ListModel {
        id: searchResultsModel
    }

    // Every searchable item is stored here. No internet search is used;
    // results come from the content built into Quantum Space Explorer.
    property var searchIndex: [
        {
            title: "HOME",
            keywords: "home quantum space explorer explore cosmos universe planets missions moon space theory news",
            description: "Main Quantum Space Explorer page",
            kind: "page",
            target: "home"
        },
        {
            title: "PLANETS",
            keywords: "planets solar system mercury venus earth mars jupiter saturn uranus neptune planet database",
            description: "Explore the eight planets and open detailed information",
            kind: "page",
            target: "planets"
        },
        {
            title: "MISSIONS",
            keywords: "missions nasa voyager voyager 1 spacecraft space probe jpl interstellar golden record jupiter saturn",
            description: "Voyager 1 mission information and live NASA/JPL data",
            kind: "page",
            target: "missions"
        },
        {
            title: "VOYAGER 1",
            keywords: "voyager 1 nasa jpl spacecraft mission probe interstellar space golden record launch launched 1977 september 5 jupiter 1979 saturn 1980 2012 august 25 power lecp low energy charged particles radio signal distance sun earth light time speed first human made spacecraft farthest spacecraft",
            description: "NASA/JPL Voyager 1 mission and live distance information",
            kind: "mission",
            target: "voyager"
        },
        {
            title: "MERCURY",
            keywords: "mercury planet terrestrial closest sun smallest 57.9 million km moons temperature",
            description: "Smallest planet and closest planet to the Sun",
            kind: "planet",
            target: "MERCURY"
        },
        {
            title: "VENUS",
            keywords: "venus planet terrestrial hot atmosphere clouds 108.2 million km moons temperature",
            description: "Hot, cloud-covered terrestrial planet",
            kind: "planet",
            target: "VENUS"
        },
        {
            title: "EARTH",
            keywords: "earth planet terrestrial home world life oceans continents 149.6 million km moon temperature",
            description: "Our home planet and the only known world with life",
            kind: "planet",
            target: "EARTH"
        },
        {
            title: "MARS",
            keywords: "mars planet red planet terrestrial desert 227.9 million km moons phobos deimos temperature",
            description: "The Red Planet with two known moons",
            kind: "planet",
            target: "MARS"
        },
        {
            title: "JUPITER",
            keywords: "jupiter planet gas giant largest planet 778.5 million km moons 115 great red spot temperature",
            description: "The largest planet in the Solar System",
            kind: "planet",
            target: "JUPITER"
        },
        {
            title: "SATURN",
            keywords: "saturn planet gas giant rings 1.43 billion km moons 293 temperature",
            description: "Gas giant famous for its spectacular rings",
            kind: "planet",
            target: "SATURN"
        },
        {
            title: "URANUS",
            keywords: "uranus planet ice giant blue green tilted axis 2.87 billion km moons 28 temperature",
            description: "Ice giant with a strongly tilted axis",
            kind: "planet",
            target: "URANUS"
        },
        {
            title: "NEPTUNE",
            keywords: "neptune planet ice giant blue winds 4.50 billion km moons 16 temperature",
            description: "Distant ice giant with extremely fast winds",
            kind: "planet",
            target: "NEPTUNE"
        },
        {
            title: "SPACE THEORY",
            keywords: "space theory universe cosmos astronomy physics theory documents pdf library",
            description: "Space Theory PDF library",
            kind: "page",
            target: "spaceTheory"
        },
        {
            title: "THEORY OF RELATIVITY",
            keywords: "theory relativity relativity einstein special general space time gravity spacetime pdf",
            description: "Space Theory document: Theory of Relativity",
            kind: "pdf",
            target: "theory_of_relativity.pdf"
        },
        {
            title: "A BRIEF HISTORY OF TIME",
            keywords: "brief history time stephen hawking black holes cosmology universe time pdf",
            description: "Space Theory document: A Brief History of Time",
            kind: "pdf",
            target: "a_brief_history_of_time.pdf"
        },
        {
            title: "THE UNIVERSE IN A NUTSHELL",
            keywords: "universe nutshell stephen hawking cosmology physics space time pdf",
            description: "Space Theory document: The Universe in a Nutshell",
            kind: "pdf",
            target: "the_universe_in_a_nutshell.pdf"
        },
        {
            title: "COSMOS",
            keywords: "cosmos carl sagan astronomy universe stars galaxies space pdf",
            description: "Space Theory document: Cosmos",
            kind: "pdf",
            target: "cosmos.pdf"
        },
        {
            title: "ASTROPHYSICS FOR PEOPLE IN A HURRY",
            keywords: "astrophysics people hurry neil degrasse tyson stars galaxies black holes universe pdf",
            description: "Space Theory document: Astrophysics for People in a Hurry",
            kind: "pdf",
            target: "astrophysics_for_people_in_a_hurry.pdf"
        },
        {
            title: "THE FABRIC OF THE COSMOS",
            keywords: "fabric cosmos brian greene space time relativity quantum universe pdf",
            description: "Space Theory document: The Fabric of the Cosmos",
            kind: "pdf",
            target: "the_fabric_of_the_cosmos.pdf"
        },
        {
            title: "THE ELEGANT UNIVERSE",
            keywords: "elegant universe brian greene string theory physics dimensions pdf",
            description: "Space Theory document: The Elegant Universe",
            kind: "pdf",
            target: "the_elegant_universe.pdf"
        },
        {
            title: "THE FIRST THREE MINUTES",
            keywords: "first three minutes steven weinberg big bang early universe cosmology pdf",
            description: "Space Theory document: The First Three Minutes",
            kind: "pdf",
            target: "the_first_three_minutes.pdf"
        },
        {
            title: "SPACE PIONEERS",
            keywords: "space pioneers scientists discoverers theories astronomy physics universe cosmos tesla einstein newton copernicus galileo kepler tsiolkovsky goddard hubble hawking",
            description: "Explore the people who shaped our understanding of space and the universe",
            kind: "page",
            target: "spacePioneers"
        },
        {
            title: "NIKOLA TESLA",
            keywords: "nikola tesla electromagnetism alternating current wireless radio high frequency electricity wireless communication space pioneer",
            description: "Explore Tesla's contributions to electromagnetism and wireless technology",
            kind: "pioneer",
            target: "NIKOLA TESLA"
        },
        {
            title: "ALBERT EINSTEIN",
            keywords: "albert einstein relativity special general relativity spacetime gravity speed of light universe",
            description: "Explore Einstein's theories of relativity and their role in modern physics",
            kind: "pioneer",
            target: "ALBERT EINSTEIN"
        },
        {
            title: "ISAAC NEWTON",
            keywords: "isaac newton gravity universal gravitation laws motion planets orbit astronomy",
            description: "Explore Newton's laws of motion and universal gravitation",
            kind: "pioneer",
            target: "ISAAC NEWTON"
        },
        {
            title: "JOHANNES KEPLER",
            keywords: "johannes kepler planetary motion orbit planets astronomy laws",
            description: "Explore Kepler's three laws of planetary motion",
            kind: "pioneer",
            target: "JOHANNES KEPLER"
        },
        {
            title: "GALILEO GALILEI",
            keywords: "galileo galilei telescope astronomy jupiter moons venus phases heliocentric",
            description: "Explore Galileo's telescopic observations and discoveries",
            kind: "pioneer",
            target: "GALILEO GALILEI"
        },
        {
            title: "NICOLAUS COPERNICUS",
            keywords: "nicolaus copernicus heliocentric solar system sun planets astronomy",
            description: "Explore the heliocentric model of the Solar System",
            kind: "pioneer",
            target: "NICOLAUS COPERNICUS"
        },
        {
            title: "KONSTANTIN TSIOLKOVSKY",
            keywords: "konstantin tsiolkovsky rocket equation spaceflight astronautics rockets",
            description: "Explore the foundations of theoretical rocket science",
            kind: "pioneer",
            target: "KONSTANTIN TSIOLKOVSKY"
        },
        {
            title: "ROBERT GODDARD",
            keywords: "robert goddard liquid fuel rocket spaceflight rocket engine",
            description: "Explore the pioneering development of liquid-fuel rockets",
            kind: "pioneer",
            target: "ROBERT GODDARD"
        },
        {
            title: "EDWIN HUBBLE",
            keywords: "edwin hubble galaxies expanding universe astronomy telescope",
            description: "Explore Hubble's observations of galaxies and the expanding universe",
            kind: "pioneer",
            target: "EDWIN HUBBLE"
        },
        {
            title: "STEPHEN HAWKING",
            keywords: "stephen hawking black holes cosmology singularity universe radiation",
            description: "Explore Hawking's work on black holes and cosmology",
            kind: "pioneer",
            target: "STEPHEN HAWKING"
        },
        {
            title: "NEWS",
            keywords: "news latest space nasa astronomy discoveries",
            description: "Space news section",
            kind: "page",
            target: "news"
        },
        {
            title: "MOON",
            keywords: "moon lunar lunar surface natural satellite earth satellite moon phases new moon crescent quarter gibbous full moon craters maria mountains south pole apollo chandrayaan chandrayaan-1 chandrayaan-2 chandrayaan-3 vikram pragyan tycho copernicus mare tranquillitatis mare imbrium shackleton 384400 km 3474.8 km gravity exosphere",
            description: "Detailed Moon explorer with real NASA imagery, facts, phases, lunar features and exploration missions",
            kind: "page",
            target: "moon"
        },
        {
            title: "LUNAR EXPLORATION",
            keywords: "lunar exploration moon mission missions apollo 11 apollo 17 chandrayaan 1 chandrayaan 2 chandrayaan 3 vikram pragyan south pole crater moon landing",
            description: "Explore Apollo and Chandrayaan missions in the Moon section",
            kind: "page",
            target: "moon"
        },
        {
            title: "LUNAR FEATURES",
            keywords: "tycho crater copernicus crater mare tranquillitatis mare imbrium shackleton crater lunar south pole maria craters mountains",
            description: "Explore important lunar craters, maria and the south polar region",
            kind: "page",
            target: "moon"
        }
    ]

    function updateSearchResults() {
        searchResultsModel.clear()

        var query = searchQuery.trim().toLowerCase()
        if (query.length === 0)
            return

        var words = query.split(/\s+/)

        for (var i = 0; i < searchIndex.length; i++) {
            var item = searchIndex[i]
            var haystack = (item.title + " " + item.keywords + " " + item.description).toLowerCase()
            var matches = true

            for (var w = 0; w < words.length; w++) {
                if (words[w].length > 0 && haystack.indexOf(words[w]) < 0) {
                    matches = false
                    break
                }
            }

            if (matches) {
                searchResultsModel.append({
                    title: item.title,
                    description: item.description,
                    kind: item.kind,
                    target: item.target
                })
            }
        }
    }

    function openSearchResult(kind, target) {
        searchPopup.close()
        searchOpen = false
        searchQuery = ""
        searchResultsModel.clear()

        if (kind === "pioneer") {
            window.currentPage = "spacePioneers"
            pioneerDetailsName = target
            return
        }

        if (kind === "planet") {
            showPlanetByName(target)
            return
        }

        if (kind === "pdf") {
            window.currentPage = "spaceTheory"
            Qt.openUrlExternally("qrc:/" + target)
            return
        }

        if (kind === "mission") {
            window.currentPage = "missions"
            return
        }

        if (target === "moon") {
            window.currentPage = "moon"
            return
        }

        if (target === "news") {
            window.currentPage = "news"
            newsLoading = true
            newsRequestRunning = true
            newsError = ""
            newsStatus = "LOADING NASA SPACE NEWS"
            newsManager.fetchNews()
            return
        }

        window.currentPage = target
    }

    function showPlanetByName(name) {
        var descriptions = {
            "MERCURY": "The smallest planet and the closest world to the Sun.",
            "VENUS": "A hot, cloud-covered world with a thick atmosphere.",
            "EARTH": "Our home world, covered with oceans and supporting life.",
            "MARS": "The Red Planet, a cold desert world with giant volcanoes.",
            "JUPITER": "The largest planet, famous for its powerful storms.",
            "SATURN": "A giant planet surrounded by its spectacular rings.",
            "URANUS": "An ice giant with a blue-green atmosphere and a tilted axis.",
            "NEPTUNE": "A distant blue ice giant with extremely fast winds."
        }

        var images = {
            "MERCURY": "qrc:/planets/mercury.png",
            "VENUS": "qrc:/planets/venus.png",
            "EARTH": "qrc:/planets/earth.png",
            "MARS": "qrc:/planets/mars.png",
            "JUPITER": "qrc:/planets/jupiter.png",
            "SATURN": "qrc:/planets/saturn.png",
            "URANUS": "qrc:/planets/uranus.png",
            "NEPTUNE": "qrc:/planets/neptune.png"
        }

        window.selectedPlanetName = name
        window.selectedPlanetTab = "OVERVIEW"
        window.selectedPlanetImage = images[name] || ""
        window.selectedPlanetDescription = descriptions[name] || "Planet information is available in the Quantum Space Explorer database."

        if (name === "MERCURY") {
            window.selectedPlanetType = "Terrestrial"
            window.selectedPlanetMoons = "0"
            window.selectedPlanetDistance = "57.9 million km"
            window.selectedPlanetTemperature = "-173°C to 427°C"
        } else if (name === "VENUS") {
            window.selectedPlanetType = "Terrestrial"
            window.selectedPlanetMoons = "0"
            window.selectedPlanetDistance = "108.2 million km"
            window.selectedPlanetTemperature = "about 464°C"
        } else if (name === "EARTH") {
            window.selectedPlanetType = "Terrestrial"
            window.selectedPlanetMoons = "1"
            window.selectedPlanetDistance = "149.6 million km"
            window.selectedPlanetTemperature = "about 15°C"
        } else if (name === "MARS") {
            window.selectedPlanetType = "Terrestrial"
            window.selectedPlanetMoons = "2"
            window.selectedPlanetDistance = "227.9 million km"
            window.selectedPlanetTemperature = "about -63°C"
        } else if (name === "JUPITER") {
            window.selectedPlanetType = "Gas giant"
            window.selectedPlanetMoons = "115"
            window.selectedPlanetDistance = "778.5 million km"
            window.selectedPlanetTemperature = "about -110°C"
        } else if (name === "SATURN") {
            window.selectedPlanetType = "Gas giant"
            window.selectedPlanetMoons = "293"
            window.selectedPlanetDistance = "1.43 billion km"
            window.selectedPlanetTemperature = "about -140°C"
        } else if (name === "URANUS") {
            window.selectedPlanetType = "Ice giant"
            window.selectedPlanetMoons = "28"
            window.selectedPlanetDistance = "2.87 billion km"
            window.selectedPlanetTemperature = "about -195°C"
        } else if (name === "NEPTUNE") {
            window.selectedPlanetType = "Ice giant"
            window.selectedPlanetMoons = "16"
            window.selectedPlanetDistance = "4.50 billion km"
            window.selectedPlanetTemperature = "about -200°C"
        }

        window.currentPage = "planets"
        planetInfoPopup.open()
    }

    // ============================================================
    // VOYAGER 1 LIVE DATA
    // Data is fetched by the C++ VoyagerManager from NASA/JPL Horizons.
    // ============================================================

    property string voyagerEarthDistance: "Loading..."
    property string voyagerSunDistance: "Loading..."
    property string voyagerSpeed: "Loading..."
    property string voyagerLightTime: "Loading..."
    property string voyagerUpdated: "Waiting for NASA/JPL..."
    property string voyagerStatus: "CONNECTING"
    property string voyagerError: ""

    Connections {
        target: voyagerManager

        function onTelemetryReady(earthDistance, sunDistance, speed, lightTime, updated, status) {
            console.log("VOYAGER DATA RECEIVED FROM NASA/JPL")
            console.log("Earth distance:", earthDistance)
            console.log("Sun distance:", sunDistance)
            console.log("Speed:", speed)
            console.log("Light time:", lightTime)
            console.log("Updated:", updated)

            window.voyagerEarthDistance = earthDistance
            window.voyagerSunDistance = sunDistance
            window.voyagerSpeed = speed
            window.voyagerLightTime = lightTime
            window.voyagerUpdated = updated
            window.voyagerStatus = status
            window.voyagerError = ""
        }

        function onTelemetryError(message) {
            console.log("VOYAGER/JPL ERROR:", message)
            window.voyagerError = message
            window.voyagerStatus = "JPL ERROR"
        }
    }

    Timer {
        id: voyagerTimer
        interval: 60000
        repeat: true
        running: window.currentPage === "missions"
        triggeredOnStart: true

        onTriggered: {
            console.log("VOYAGER AUTO REFRESH")
            voyagerManager.updateVoyager1()
        }
    }

    // ============================================================
    // BACKGROUND
    // ============================================================

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/space_background.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        mipmap: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#02050a"
        opacity: 0.60
    }

    // ============================================================
    // TOP NAVIGATION
    // ============================================================

    Rectangle {
        id: topBar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: 82

        color: "#050b12"
        opacity: 0.94

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: "#263540"
        }

        // Logo
        Text {
            id: logoQ

            anchors.left: parent.left
            anchors.leftMargin: 38
            anchors.verticalCenter: parent.verticalCenter

            text: "Q"
            color: "#b7ff00"

            font.pixelSize: 32
            font.bold: true
        }

        Text {
            anchors.left: logoQ.right
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            text: "QUANTUM"
            color: "white"

            font.pixelSize: 17
            font.bold: true
            font.letterSpacing: 2
        }

        Text {
            anchors.left: logoQ.right
            anchors.leftMargin: 12
            anchors.top: logoQ.bottom
            anchors.topMargin: -9

            text: "SPACE EXPLORER"
            color: "#687682"

            font.pixelSize: 8
            font.letterSpacing: 1.8
        }

        // Navigation
        Row {
            anchors.right: searchButton.left
            anchors.rightMargin: 28
            anchors.verticalCenter: parent.verticalCenter

            spacing: 8

            NavButton {
                text: "HOME"

                onClicked: {
                    window.currentPage = "home"
                }
            }

            NavButton {
                text: "PLANETS"

                onClicked: {
                    window.currentPage = "planets"
                }
            }

            NavButton {
                text: "MISSIONS"

                onClicked: {
                    console.log("MISSIONS selected - fetching Voyager 1 NASA/JPL data")
                    window.currentPage = "missions"
                    voyagerManager.updateVoyager1()
                }
            }

            NavButton {
                text: "MOON"

                onClicked: {
                    window.currentPage = "moon"
                }
            }

            NavButton {
                text: "SPACE THEORY"

                onClicked: {
                    window.currentPage = "spaceTheory"
                }
            }

            NavButton {
                text: "PIONEERS"

                onClicked: {
                    window.currentPage = "spacePioneers"
                }
            }

            NavButton {
                text: "NEWS NASA"

                onClicked: {
                    window.currentPage = "news"
                    newsLoading = true
                    newsRequestRunning = true
                    newsError = ""
                    newsStatus = "LOADING NASA SPACE NEWS"
                    newsManager.fetchNews()
                    console.log("NEWS selected - fetching NASA news")
                }
            }
        }

        // Search
        Rectangle {
            id: searchButton

            anchors.right: parent.right
            anchors.rightMargin: 38
            anchors.verticalCenter: parent.verticalCenter

            width: 42
            height: 42
            radius: 21

            color: searchMouse.containsMouse || searchOpen
                   ? "#15222d"
                   : "#0b141c"

            border.color: searchMouse.containsMouse || searchOpen
                          ? "#b7ff00"
                          : "#263540"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "⌕"
                color: searchMouse.containsMouse || searchOpen
                       ? "#b7ff00"
                       : "#9aa6b0"
                font.pixelSize: 24
            }

            MouseArea {
                id: searchMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    if (searchPopup.opened) {
                        searchPopup.close()
                    } else {
                        searchPopup.open()
                    }
                }
            }
        }

        // ========================================================
        // SEARCH PANEL
        // ========================================================

        Popup {
            id: searchPopup

            x: parent.width - width - 38
            y: 76
            width: 470
            height: 530

            padding: 0
            modal: false
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            onOpened: {
                searchOpen = true
                searchField.forceActiveFocus()
            }

            onClosed: {
                searchOpen = false
                searchQuery = ""
                searchResultsModel.clear()
            }

            background: Rectangle {
                radius: 8
                color: "#050b12"
                border.color: "#2a3a46"
                border.width: 1

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: 3
                    radius: 2
                    color: "#b7ff00"
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 24
                anchors.top: parent.top
                anchors.topMargin: 20
                text: "QUANTUM SEARCH"
                color: "#b7ff00"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 2
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.top: parent.top
                anchors.topMargin: 20
                text: "APP DATABASE"
                color: "#52616d"
                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 1
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 50
                height: 50
                radius: 5
                color: "#09131c"
                border.color: searchField.activeFocus ? "#b7ff00" : "#263540"
                border.width: 1

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    text: "⌕"
                    color: "#b7ff00"
                    font.pixelSize: 21
                }

                TextField {
                    id: searchField
                    anchors.left: parent.left
                    anchors.leftMargin: 45
                    anchors.right: parent.right
                    anchors.rightMargin: 42
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    placeholderText: "Search planets, Voyager, missions, PDFs..."
                    text: searchQuery
                    color: "white"
                    placeholderTextColor: "#52616d"
                    font.pixelSize: 13
                    selectByMouse: true
                    background: Item {}

                    onTextChanged: {
                        searchQuery = text
                        updateSearchResults()
                    }

                    Keys.onEscapePressed: searchPopup.close()
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    text: "ESC"
                    color: "#52616d"
                    font.pixelSize: 8
                    font.bold: true
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 24
                anchors.top: parent.top
                anchors.topMargin: 117
                text: searchQuery.length === 0
                      ? "TYPE TO SEARCH THE APP"
                      : searchResultsModel.count + " RESULT" + (searchResultsModel.count === 1 ? "" : "S")
                color: "#65737e"
                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 1.4
            }

            ListView {
                id: searchResultsView
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.topMargin: 145
                anchors.bottomMargin: 18
                clip: true
                spacing: 8
                model: searchResultsModel

                delegate: Rectangle {
                    width: searchResultsView.width
                    height: 68
                    radius: 5
                    color: searchResultMouse.containsMouse ? "#111e28" : "#09131c"
                    border.color: searchResultMouse.containsMouse ? "#60717d" : "#1d2b35"
                    border.width: 1

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.top: parent.top
                        anchors.topMargin: 13
                        anchors.right: typeLabel.left
                        anchors.rightMargin: 12
                        text: model.title
                        color: "white"
                        font.pixelSize: 12
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.right: typeLabel.left
                        anchors.rightMargin: 12
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 12
                        text: model.description
                        color: "#71808c"
                        font.pixelSize: 9
                        elide: Text.ElideRight
                    }

                    Text {
                        id: typeLabel
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        text: model.kind === "planet" ? "PLANET"
                              : model.kind === "mission" ? "MISSION"
                              : model.kind === "pdf" ? "PDF"
                              : "PAGE"
                        color: "#b7ff00"
                        font.pixelSize: 8
                        font.bold: true
                        font.letterSpacing: 1
                    }

                    MouseArea {
                        id: searchResultMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: openSearchResult(model.kind, model.target)
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: searchQuery.length > 0 && searchResultsModel.count === 0
                    text: "NO RESULT FOUND\n\nTry: Mars, Voyager, relativity,\nblack holes, planets, missions..."
                    horizontalAlignment: Text.AlignHCenter
                    color: "#65737e"
                    font.pixelSize: 11
                    lineHeight: 1.5
                }
            }
        }
    }

    // ============================================================
    // HOME PAGE
    // ============================================================

    Item {
        id: homePage

        anchors.fill: parent
        visible: window.currentPage === "home"

        // Small label
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 90
            anchors.top: parent.top
            anchors.topMargin: 165

            text: "01  /  08"
            color: "#b7ff00"

            font.pixelSize: 11
            font.bold: true
            font.letterSpacing: 2
        }

        // Main title
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 88
            anchors.top: parent.top
            anchors.topMargin: 205

            text: "EXPLORE\nTHE COSMOS"

            color: "white"

            font.pixelSize: 68
            font.bold: true
            lineHeight: 0.85
        }

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 91
            anchors.top: parent.top
            anchors.topMargin: 365

            width: 70
            height: 3

            color: "#b7ff00"
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 90
            anchors.top: parent.top
            anchors.topMargin: 390

            text: "QUANTUM SPACE EXPLORER"

            color: "#b7ff00"

            font.pixelSize: 13
            font.bold: true
            font.letterSpacing: 3
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 90
            anchors.top: parent.top
            anchors.topMargin: 425

            width: 470

            text: "Discover planets, missions and distant worlds.\nExplore the universe through science and technology."

            color: "#a5b0b9"

            font.pixelSize: 15
            lineHeight: 1.3
            wrapMode: Text.WordWrap
        }

        // Explore button
        Rectangle {
            id: exploreButton

            anchors.left: parent.left
            anchors.leftMargin: 90
            anchors.top: parent.top
            anchors.topMargin: 500

            width: 180
            height: 50

            radius: 3

            color: exploreMouse.containsMouse
                   ? "#c9ff38"
                   : "#b7ff00"

            Text {
                anchors.centerIn: parent

                text: "EXPLORE NOW  →"

                color: "#02050a"

                font.pixelSize: 11
                font.bold: true
                font.letterSpacing: 1
            }

            MouseArea {
                id: exploreMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    window.currentPage = "planets"
                }
            }
        }

        // Missions button
        Rectangle {
            anchors.left: exploreButton.right
            anchors.leftMargin: 14
            anchors.top: exploreButton.top

            width: 140
            height: 50

            radius: 3

            color: "#0a121a"

            border.color: "#3a4a56"
            border.width: 1

            Text {
                anchors.centerIn: parent

                text: "MISSIONS"

                color: "white"

                font.pixelSize: 11
                font.bold: true
                font.letterSpacing: 1
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    console.log("MISSIONS selected - fetching Voyager 1 NASA/JPL data")
                    window.currentPage = "missions"
                    voyagerManager.updateVoyager1()
                }
            }
        }

        // Earth information panel
        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 90
            anchors.top: parent.top
            anchors.topMargin: 190

            width: 340
            height: 300

            color: "#050b12"
            opacity: 0.84

            border.color: "#263540"
            border.width: 1

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                width: 3

                color: "#b7ff00"
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.top: parent.top
                anchors.topMargin: 30

                text: "CURRENT WORLD"

                color: "#72808b"

                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 2
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.top: parent.top
                anchors.topMargin: 65

                text: "EARTH"

                color: "white"

                font.pixelSize: 31
                font.bold: true
                font.letterSpacing: 2
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.top: parent.top
                anchors.topMargin: 115

                width: 275

                text: "Our home planet — a world of oceans,\ncontinents and life."

                color: "#91a0ab"

                font.pixelSize: 12
                lineHeight: 1.35
                wrapMode: Text.WordWrap
            }

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 32

                height: 1

                color: "#263540"
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 12

                text: "PLANET 03"

                color: "#b7ff00"

                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 1.5
            }
        }

        // ========================================================
        // HOME STATISTICS
        // ========================================================

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 38

            anchors.leftMargin: 90
            anchors.rightMargin: 90

            spacing: 14

            StatBox {
                title: "PLANETS"
                value: "8"
            }

            StatBox {
                title: "DWARF PLANETS"
                value: "5+"
            }

            StatBox {
                title: "KNOWN MOONS"
                value: "290+"
            }

            StatBox {
                title: "SOLAR SYSTEM"
                value: "1"
            }
        }
    }

    // ============================================================
    // PLANETS PAGE
    // ============================================================

    Item {
        id: planetsPage

        anchors.fill: parent
        visible: window.currentPage === "planets"

        // Header
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 120

            text: "SOLAR SYSTEM"

            color: "#b7ff00"

            font.pixelSize: 11
            font.bold: true
            font.letterSpacing: 3
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 62
            anchors.top: parent.top
            anchors.topMargin: 145

            text: "PLANETS"

            color: "white"

            font.pixelSize: 40
            font.bold: true
            font.letterSpacing: 2
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 200

            text: "Explore the eight worlds of our solar system."

            color: "#82909b"

            font.pixelSize: 13
        }

        // Back button
        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 130

            width: 130
            height: 42

            radius: 3

            color: backMouse.containsMouse
                   ? "#14202a"
                   : "#081018"

            border.color: backMouse.containsMouse
                          ? "#b7ff00"
                          : "#263540"

            border.width: 1

            Text {
                anchors.centerIn: parent

                text: "←  HOME"

                color: backMouse.containsMouse
                       ? "#b7ff00"
                       : "#9ba7b1"

                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1
            }

            MouseArea {
                id: backMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    window.currentPage = "home"
                }
            }
        }

        // ========================================================
        // PLANET GRID
        // ========================================================

        GridLayout {
            id: planetGrid

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            anchors.leftMargin: 65
            anchors.rightMargin: 65
            anchors.topMargin: 250
            anchors.bottomMargin: 38

            columns: 4
            rows: 2

            columnSpacing: 16
            rowSpacing: 16

            PlanetCard {
                planetName: "MERCURY"
                planetImage: "qrc:/planets/mercury.png"
                description: "The smallest planet and the closest planet to the Sun. Its surface is heavily cratered and it has almost no atmosphere."

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            PlanetCard {
                planetName: "VENUS"
                planetImage: "qrc:/planets/venus.png"
                description: "A rocky planet with a dense carbon-dioxide atmosphere. Its surface is hotter than Mercury because of an extreme greenhouse effect."

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            PlanetCard {
                planetName: "EARTH"
                planetImage: "qrc:/planets/earth.png"
                description: "The only world known to support life, with abundant liquid water on its surface and a nitrogen-rich atmosphere."

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            PlanetCard {
                planetName: "MARS"
                planetImage: "qrc:/planets/mars.png"
                description: "A cold, rocky desert world with iron-rich dust, polar ice and the giant volcano Olympus Mons."

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            PlanetCard {
                planetName: "JUPITER"
                planetImage: "qrc:/planets/jupiter.png"
                description: "The largest planet, a hydrogen-and-helium gas giant with powerful storms including the Great Red Spot."

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            PlanetCard {
                planetName: "SATURN"
                planetImage: "qrc:/planets/saturn.png"
                description: "A hydrogen-and-helium gas giant surrounded by a bright, extensive ring system and hundreds of confirmed moons."

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            PlanetCard {
                planetName: "URANUS"
                planetImage: "qrc:/planets/uranus.png"
                description: "An ice giant rich in water, methane and ammonia ices, rotating with an extreme axial tilt."

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            PlanetCard {
                planetName: "NEPTUNE"
                planetImage: "qrc:/planets/neptune.png"
                description: "The most distant major planet, a blue ice giant with some of the fastest winds measured in the solar system."

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    // ============================================================
    // MISSIONS PAGE — VOYAGER 1
    // NASA/JPL verified mission information + live Horizons data.
    // ============================================================

    Item {
        id: missionsPage

        anchors.fill: parent
        visible: window.currentPage === "missions"

        onVisibleChanged: {
            if (visible) {
                console.log("MISSION PAGE OPENED - fetching Voyager 1 data")
                voyagerManager.updateVoyager1()
            }
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 112
            text: "NASA / JPL DEEP SPACE MISSION"
            color: "#b7ff00"
            font.pixelSize: 11
            font.bold: true
            font.letterSpacing: 3
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 62
            anchors.top: parent.top
            anchors.topMargin: 138
            text: "VOYAGER 1"
            color: "white"
            font.pixelSize: 42
            font.bold: true
            font.letterSpacing: 2
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 196
            text: "Humanity's most distant spacecraft — now traveling through interstellar space."
            color: "#82909b"
            font.pixelSize: 13
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 115
            width: 125
            height: 40
            radius: 3
            color: missionHomeMouse.containsMouse ? "#0d1821" : "#08111a"
            border.color: missionHomeMouse.containsMouse ? "#b7ff00" : "#263540"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "←  HOME"
                color: missionHomeMouse.containsMouse ? "#b7ff00" : "#9aa7b1"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1
            }

            MouseArea {
                id: missionHomeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: window.currentPage = "home"
            }
        }

        // --------------------------------------------------------
        // LIVE TELEMETRY
        // --------------------------------------------------------

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 245
            width: parent.width - 130
            height: 185
            radius: 8
            color: "#050b12"
            border.color: "#263540"
            border.width: 1

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 4
                radius: 2
                color: "#b7ff00"
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 22
                text: "LIVE VOYAGER 1 TRACKING"
                color: "#b7ff00"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 2
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 22
                text: voyagerStatus
                color: voyagerStatus.indexOf("LIVE") >= 0 ? "#b7ff00" : "#8e9ba7"
                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 1
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.right: parent.right
                anchors.rightMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 62
                spacing: 12

                MissionMetric {
                    title: "EARTH DISTANCE"
                    value: window.voyagerEarthDistance
                }

                MissionMetric {
                    title: "SUN DISTANCE"
                    value: window.voyagerSunDistance
                }

                MissionMetric {
                    title: "ONE-WAY LIGHT TIME"
                    value: window.voyagerLightTime
                }

                MissionMetric {
                    title: "ESCAPE SPEED"
                    value: window.voyagerSpeed
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                text: "LAST JPL UPDATE: " + window.voyagerUpdated + "    •    AUTO REFRESH: 60 SEC"
                color: "#52616d"
                font.pixelSize: 9
            }
        }

        // --------------------------------------------------------
        // MISSION FACTS
        // --------------------------------------------------------

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 450
            width: 620
            height: 285
            radius: 8
            color: "#050b12"
            border.color: "#263540"
            border.width: 1

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 24
                text: "MISSION PROFILE"
                color: "#b7ff00"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 2
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 60
                text: "LAUNCH"
                color: "#64727d"
                font.pixelSize: 9
                font.bold: true
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 78
                text: "5 SEPTEMBER 1977"
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 315
                anchors.top: parent.top
                anchors.topMargin: 60
                text: "MISSION TYPE"
                color: "#64727d"
                font.pixelSize: 9
                font.bold: true
            }
            Text {
                anchors.left: parent.left
                anchors.leftMargin: 315
                anchors.top: parent.top
                anchors.topMargin: 78
                text: "FLYBY / EXTENDED MISSION"
                color: "white"
                font.pixelSize: 14
                font.bold: true
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 28
                anchors.rightMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 112
                height: 1
                color: "#263540"
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 132
                width: 560
                text: "Voyager 1 flew past Jupiter in 1979 and Saturn in 1980. It entered interstellar space on 25 August 2012 and became the first human-made spacecraft to do so."
                color: "#9aa7b1"
                font.pixelSize: 12
                lineHeight: 1.45
                wrapMode: Text.WordWrap
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 205
                width: 560
                text: "CURRENT POWER STATUS: NASA/JPL continues managing Voyager 1's declining power. On 17 April 2026, NASA shut down the Low-energy Charged Particles experiment (LECP) to help extend the spacecraft's operating life."
                color: "#778590"
                font.pixelSize: 10
                lineHeight: 1.45
                wrapMode: Text.WordWrap
            }
        }

        // --------------------------------------------------------
        // STATUS / GOLDEN RECORD PANEL
        // --------------------------------------------------------

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 450
            width: parent.width - 750
            height: 285
            radius: 8
            color: "#050b12"
            border.color: "#263540"
            border.width: 1

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 24
                text: "INTERSTELLAR EXPLORER"
                color: "#b7ff00"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 2
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 61
                width: parent.width - 56
                text: "MOST DISTANT HUMAN-MADE OBJECT"
                color: "white"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 96
                width: parent.width - 56
                text: "Voyager 1 carries the Golden Record, a time capsule containing sounds and images intended to communicate a story of Earth."
                color: "#8f9ca6"
                font.pixelSize: 11
                lineHeight: 1.45
                wrapMode: Text.WordWrap
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 28
                anchors.rightMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 160
                height: 1
                color: "#263540"
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 182
                text: "SCIENCE GOAL"
                color: "#64727d"
                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 1.2
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 28
                anchors.top: parent.top
                anchors.topMargin: 203
                width: parent.width - 56
                text: "Study the outer solar system and the interstellar environment beyond the heliosphere."
                color: "#9aa7b1"
                font.pixelSize: 11
                wrapMode: Text.WordWrap
            }
        }
    }

    // ============================================================
    // MOON EXPLORER
    // Detailed Moon information page - no simulation.
    // ============================================================

    Item {
        id: moonPage
        anchors.fill: parent
        visible: window.currentPage === "moon"

        Flickable {
            anchors.fill: parent
            anchors.topMargin: 82
            contentWidth: width
            contentHeight: moonContent.height + 70
            clip: true

            Column {
                id: moonContent
                width: moonPage.width
                spacing: 22
                topPadding: 28
                bottomPadding: 45

                // HERO
                Rectangle {
                    width: parent.width - 110
                    height: 245
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 10
                    color: "#050b12"
                    border.color: "#263540"
                    border.width: 1

                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 4
                        radius: 2
                        color: "#b7ff00"
                    }

                    // REAL NASA MOON PHOTOGRAPH / MOSAIC
                    // NASA's LRO Moon Mosaic: 1,231 NAC images combined into a full-Moon photographic mosaic.
                    Image {
                        id: moonHeroDisc
                        anchors.left: parent.left
                        anchors.leftMargin: 38
                        anchors.verticalCenter: parent.verticalCenter
                        width: 170
                        height: 170
                        source: "https://assets.science.nasa.gov/dynamicimage/assets/science/psd/earths-moon/outreach-materials/NASA-LRO-Moon-mosaic.png?crop=faces%2Cfocalpoint&fit=clip&h=1041&w=1041"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        asynchronous: true
                        cache: true
                        mipmap: true
                    }

                    Rectangle {
                        anchors.left: moonHeroDisc.left
                        anchors.right: moonHeroDisc.right
                        anchors.top: moonHeroDisc.top
                        anchors.bottom: moonHeroDisc.bottom
                        radius: width / 2
                        color: "transparent"
                        border.color: "#dce0e3"
                        border.width: 1
                    }

                    Text {
                        anchors.left: moonHeroDisc.right
                        anchors.leftMargin: 38
                        anchors.top: parent.top
                        anchors.topMargin: 28
                        text: "LUNAR EXPLORER"
                        color: "#b7ff00"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 2.2
                    }

                    Text {
                        anchors.left: moonHeroDisc.right
                        anchors.leftMargin: 38
                        anchors.top: parent.top
                        anchors.topMargin: 57
                        text: "THE MOON"
                        color: "white"
                        font.pixelSize: 38
                        font.bold: true
                        font.letterSpacing: 2
                    }

                    Text {
                        anchors.left: moonHeroDisc.right
                        anchors.leftMargin: 40
                        anchors.top: parent.top
                        anchors.topMargin: 112
                        width: parent.width - 300
                        text: "Earth's natural satellite — a world of ancient craters, mountains, volcanic plains and permanently shadowed polar regions."
                        color: "#9aa7b1"
                        font.pixelSize: 12
                        lineHeight: 1.45
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        anchors.left: moonHeroDisc.right
                        anchors.leftMargin: 40
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 28
                        text: "QUANTUM SPACE EXPLORER  /  NASA LRO MOON MOSAIC"
                        color: "#52616d"
                        font.pixelSize: 8
                        font.bold: true
                        font.letterSpacing: 1.3
                    }
                }

                // CORE DATA
                Text {
                    width: parent.width - 110
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "MOON AT A GLANCE"
                    color: "#b7ff00"
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 2
                }

                GridLayout {
                    width: parent.width - 110
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 4
                    columnSpacing: 12
                    rowSpacing: 12

                    Repeater {
                        model: [
                            {label:"MEAN DISTANCE", value:"384,400 km", sub:"from Earth"},
                            {label:"DIAMETER", value:"3,474.8 km", sub:"mean diameter"},
                            {label:"SURFACE GRAVITY", value:"1.62 m/s²", sub:"about 1/6 of Earth"},
                            {label:"ORBITAL PERIOD", value:"27.3 days", sub:"sidereal month"},
                            {label:"AGE", value:"≈ 4.5 billion", sub:"years"},
                            {label:"ATMOSPHERE", value:"EXOSPHERE", sub:"extremely thin"},
                            {label:"ESCAPE VELOCITY", value:"2.38 km/s", sub:"from lunar surface"},
                            {label:"MOONLIGHT", value:"REFLECTED", sub:"sunlight, not self-produced"}
                        ]

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            height: 88
                            radius: 6
                            color: "#081018"
                            border.color: "#263540"
                            border.width: 1

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                                anchors.top: parent.top
                                anchors.topMargin: 13
                                text: modelData.label
                                color: "#687682"
                                font.pixelSize: 8
                                font.bold: true
                                font.letterSpacing: 1
                            }
                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                                anchors.top: parent.top
                                anchors.topMargin: 34
                                text: modelData.value
                                color: "white"
                                font.pixelSize: 16
                                font.bold: true
                            }
                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 15
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 12
                                text: modelData.sub
                                color: "#65737e"
                                font.pixelSize: 8
                            }
                        }
                    }
                }

                // PHASES
                Rectangle {
                    width: parent.width - 110
                    height: 180
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 8
                    color: "#050b12"
                    border.color: "#263540"
                    border.width: 1

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 22
                        anchors.top: parent.top
                        anchors.topMargin: 18
                        text: "MOON PHASES"
                        color: "white"
                        font.pixelSize: 17
                        font.bold: true
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 22
                        anchors.top: parent.top
                        anchors.topMargin: 47
                        text: "The Moon's appearance changes as its position changes relative to Earth and the Sun."
                        color: "#7f8d98"
                        font.pixelSize: 10
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 25
                        anchors.rightMargin: 25
                        anchors.top: parent.top
                        anchors.topMargin: 82
                        spacing: 12

                        Repeater {
                            model: ["NEW", "WAXING CRESCENT", "FIRST QUARTER", "WAXING GIBBOUS", "FULL", "WANING GIBBOUS", "THIRD QUARTER", "WANING CRESCENT"]
                            delegate: Column {
                                width: (parent.width - 84) / 8
                                spacing: 7

                                Rectangle {
                                    width: 34
                                    height: 34
                                    radius: 17
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: index === 0 ? "#111820" : (index < 4 ? "#7d858a" : "#c2c5c7")
                                    border.color: "#65717a"
                                    border.width: 1
                                }

                                Text {
                                    width: parent.width
                                    text: modelData
                                    color: index === 4 ? "#b7ff00" : "#788691"
                                    font.pixelSize: 7
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }
                }

                // SURFACE FEATURES
                Text {
                    width: parent.width - 110
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "LUNAR SURFACE DATABASE"
                    color: "#b7ff00"
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 2
                }

                GridLayout {
                    width: parent.width - 110
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 3
                    columnSpacing: 12
                    rowSpacing: 12

                    Repeater {
                        model: [
                            {name:"MARE TRANQUILLITATIS", type:"LUNAR MARE", info:"Sea of Tranquility. Landing site of Apollo 11."},
                            {name:"TYCHO CRATER", type:"IMPACT CRATER", info:"A prominent young crater in the southern lunar highlands."},
                            {name:"COPERNICUS CRATER", type:"IMPACT CRATER", info:"Large, relatively young crater with prominent rays."},
                            {name:"MARE IMBRIUM", type:"LUNAR MARE", info:"A vast basaltic plain formed by ancient impacts and volcanism."},
                            {name:"LUNAR SOUTH POLE", type:"POLAR REGION", info:"Region of major scientific interest, including permanently shadowed areas."},
                            {name:"SHACKLETON CRATER", type:"POLAR CRATER", info:"A crater near the lunar south pole with a permanently shadowed interior."}
                        ]

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            height: 125
                            radius: 7
                            color: featureMouse.containsMouse ? "#101c25" : "#081018"
                            border.color: featureMouse.containsMouse ? "#60717d" : "#263540"
                            border.width: 1

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.top: parent.top
                                anchors.topMargin: 17
                                width: parent.width - 36
                                text: modelData.name
                                color: "white"
                                font.pixelSize: 11
                                font.bold: true
                                elide: Text.ElideRight
                            }
                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.top: parent.top
                                anchors.topMargin: 43
                                text: modelData.type
                                color: "#b7ff00"
                                font.pixelSize: 8
                                font.bold: true
                                font.letterSpacing: 1.1
                            }
                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 18
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.top: parent.top
                                anchors.topMargin: 67
                                text: modelData.info
                                color: "#778691"
                                font.pixelSize: 9
                                lineHeight: 1.35
                                wrapMode: Text.WordWrap
                            }
                            MouseArea {
                                id: featureMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    moonFeaturePopup.titleText = modelData.name
                                    moonFeaturePopup.typeText = modelData.type
                                    moonFeaturePopup.infoText = modelData.info
                                    moonFeaturePopup.open()
                                }
                            }
                        }
                    }
                }

                // MISSIONS
                Rectangle {
                    width: parent.width - 110
                    height: 230
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 8
                    color: "#050b12"
                    border.color: "#263540"
                    border.width: 1

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 24
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        text: "LUNAR EXPLORATION MISSIONS"
                        color: "white"
                        font.pixelSize: 17
                        font.bold: true
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 24
                        anchors.top: parent.top
                        anchors.topMargin: 48
                        text: "Major missions that changed our understanding of the Moon."
                        color: "#778691"
                        font.pixelSize: 10
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 24
                        anchors.rightMargin: 24
                        anchors.top: parent.top
                        anchors.topMargin: 82
                        spacing: 10

                        Repeater {
                            model: [
                                {year:"1969", name:"APOLLO 11", text:"First humans to walk on the Moon."},
                                {year:"2008", name:"CHANDRAYAAN-1", text:"India's first lunar mission; major lunar science mission."},
                                {year:"2023", name:"CHANDRAYAAN-3", text:"India achieved a successful soft landing near the lunar south polar region."},
                                {year:"NOW / FUTURE", name:"LUNAR EXPLORATION", text:"New robotic and crewed missions are expanding lunar science and exploration."}
                            ]
                            delegate: Rectangle {
                                width: (parent.width - 30) / 4
                                height: 120
                                radius: 6
                                color: "#081018"
                                border.color: "#263540"
                                border.width: 1

                                Text { anchors.left: parent.left; anchors.leftMargin: 14; anchors.top: parent.top; anchors.topMargin: 12; text: modelData.year; color: "#b7ff00"; font.pixelSize: 8; font.bold: true }
                                Text { anchors.left: parent.left; anchors.leftMargin: 14; anchors.right: parent.right; anchors.rightMargin: 12; anchors.top: parent.top; anchors.topMargin: 34; text: modelData.name; color: "white"; font.pixelSize: 11; font.bold: true; wrapMode: Text.WordWrap }
                                Text { anchors.left: parent.left; anchors.leftMargin: 14; anchors.right: parent.right; anchors.rightMargin: 12; anchors.top: parent.top; anchors.topMargin: 68; text: modelData.text; color: "#778691"; font.pixelSize: 8; lineHeight: 1.35; wrapMode: Text.WordWrap }
                            }
                        }
                    }
                }

                // CHANDRAYAAN FEATURE
                Rectangle {
                    width: parent.width - 110
                    height: 205
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 8
                    color: "#071018"
                    border.color: "#344550"
                    border.width: 1

                    Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 4; color: "#b7ff00" }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 25
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        text: "INDIA'S LUNAR EXPLORATION"
                        color: "#b7ff00"
                        font.pixelSize: 9
                        font.bold: true
                        font.letterSpacing: 1.8
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 25
                        anchors.top: parent.top
                        anchors.topMargin: 49
                        text: "CHANDRAYAAN-3"
                        color: "white"
                        font.pixelSize: 25
                        font.bold: true
                        font.letterSpacing: 1
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 25
                        anchors.top: parent.top
                        anchors.topMargin: 91
                        width: parent.width - 390
                        text: "India's Chandrayaan-3 mission demonstrated a successful soft landing and rover operations on the Moon in 2023. Its lander was named Vikram and its rover was named Pragyan."
                        color: "#8a98a3"
                        font.pixelSize: 10
                        lineHeight: 1.45
                        wrapMode: Text.WordWrap
                    }

                    Row {
                        anchors.right: parent.right
                        anchors.rightMargin: 28
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Repeater {
                            model: ["VIKRAM\nLANDER", "PRAGYAN\nROVER", "2023\nLANDING"]
                            delegate: Rectangle {
                                width: 90
                                height: 85
                                radius: 5
                                color: "#0b151e"
                                border.color: "#263540"
                                border.width: 1
                                Text { anchors.centerIn: parent; text: modelData; color: "#dbe2e7"; font.pixelSize: 9; font.bold: true; horizontalAlignment: Text.AlignHCenter; lineHeight: 1.3 }
                            }
                        }
                    }
                }

                // SCIENCE + FACTS
                Row {
                    width: parent.width - 110
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 12

                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 225
                        radius: 8
                        color: "#050b12"
                        border.color: "#263540"
                        border.width: 1

                        Text { anchors.left: parent.left; anchors.leftMargin: 22; anchors.top: parent.top; anchors.topMargin: 20; text: "WHY THE MOON MATTERS"; color: "white"; font.pixelSize: 15; font.bold: true }
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 22
                            anchors.right: parent.right
                            anchors.rightMargin: 22
                            anchors.top: parent.top
                            anchors.topMargin: 57
                            text: "• Helps scientists study the early history of the Solar System.\n\n• Its craters preserve evidence of ancient impacts.\n\n• Its polar regions are important for studying lunar water ice.\n\n• The Moon is a natural laboratory for future exploration technology."
                            color: "#82909b"
                            font.pixelSize: 10
                            lineHeight: 1.35
                            wrapMode: Text.WordWrap
                        }
                    }

                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 225
                        radius: 8
                        color: "#050b12"
                        border.color: "#263540"
                        border.width: 1

                        Text { anchors.left: parent.left; anchors.leftMargin: 22; anchors.top: parent.top; anchors.topMargin: 20; text: "DID YOU KNOW?"; color: "white"; font.pixelSize: 15; font.bold: true }
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 22
                            anchors.right: parent.right
                            anchors.rightMargin: 22
                            anchors.top: parent.top
                            anchors.topMargin: 57
                            text: "01  The Moon is tidally locked to Earth.\n\n02  We always see nearly the same lunar hemisphere from Earth.\n\n03  The Moon has an extremely thin exosphere, not a breathable atmosphere.\n\n04  Lunar rocks provide a record of ancient Solar System history."
                            color: "#82909b"
                            font.pixelSize: 10
                            lineHeight: 1.35
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                // TIMELINE
                Rectangle {
                    width: parent.width - 110
                    height: 165
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 8
                    color: "#050b12"
                    border.color: "#263540"
                    border.width: 1

                    Text { anchors.left: parent.left; anchors.leftMargin: 22; anchors.top: parent.top; anchors.topMargin: 19; text: "LUNAR EXPLORATION TIMELINE"; color: "white"; font.pixelSize: 15; font.bold: true }

                    Row {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 25
                        anchors.rightMargin: 25
                        anchors.top: parent.top
                        anchors.topMargin: 73
                        spacing: 0

                        Repeater {
                            model: ["1969\nAPOLLO 11", "1972\nAPOLLO 17", "2008\nCHANDRAYAAN-1", "2019\nCHANDRAYAAN-2", "2023\nCHANDRAYAAN-3", "FUTURE\nNEW MISSIONS"]
                            delegate: Item {
                                width: parent.width / 6
                                height: 65

                                Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 9; height: 1; color: "#344550" }
                                Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.topMargin: 4; width: 11; height: 11; radius: 6; color: index === 4 ? "#b7ff00" : "#60717d" }
                                Text { anchors.left: parent.left; anchors.top: parent.top; anchors.topMargin: 28; width: parent.width - 10; text: modelData; color: index === 4 ? "#b7ff00" : "#8b99a4"; font.pixelSize: 8; font.bold: true; lineHeight: 1.25; wrapMode: Text.WordWrap }
                            }
                        }
                    }
                }
            }
        }

        // FEATURE INFORMATION POPUP
        Popup {
            id: moonFeaturePopup
            property string titleText: ""
            property string typeText: ""
            property string infoText: ""
            anchors.centerIn: parent
            width: 620
            height: 300
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            padding: 0

            background: Rectangle {
                radius: 9
                color: "#071018"
                border.color: "#344550"
                border.width: 1
            }

            contentItem: Item {
                Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom; width: 4; color: "#b7ff00" }
                Text { anchors.left: parent.left; anchors.leftMargin: 30; anchors.top: parent.top; anchors.topMargin: 25; text: "LUNAR SURFACE DATABASE"; color: "#b7ff00"; font.pixelSize: 9; font.bold: true; font.letterSpacing: 2 }
                Text { anchors.left: parent.left; anchors.leftMargin: 30; anchors.top: parent.top; anchors.topMargin: 55; text: moonFeaturePopup.titleText; color: "white"; font.pixelSize: 24; font.bold: true }
                Text { anchors.left: parent.left; anchors.leftMargin: 30; anchors.top: parent.top; anchors.topMargin: 95; text: moonFeaturePopup.typeText; color: "#82909b"; font.pixelSize: 9; font.bold: true; font.letterSpacing: 1.2 }
                Text { anchors.left: parent.left; anchors.leftMargin: 30; anchors.right: parent.right; anchors.rightMargin: 30; anchors.top: parent.top; anchors.topMargin: 130; text: moonFeaturePopup.infoText; color: "#a5b0b9"; font.pixelSize: 11; lineHeight: 1.5; wrapMode: Text.WordWrap }

                Rectangle {
                    anchors.right: parent.right
                    anchors.rightMargin: 25
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 22
                    width: 100
                    height: 36
                    radius: 4
                    color: "#b7ff00"
                    Text { anchors.centerIn: parent; text: "CLOSE"; color: "#02050a"; font.pixelSize: 9; font.bold: true; font.letterSpacing: 1 }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: moonFeaturePopup.close() }
                }
            }
        }

        // HOME BUTTON
        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 55
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 28
            width: 115
            height: 40
            radius: 4
            color: "#0a121a"
            border.color: "#3a4a56"
            border.width: 1

            Text { anchors.centerIn: parent; text: "←  HOME"; color: "white"; font.pixelSize: 9; font.bold: true; font.letterSpacing: 1 }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: window.currentPage = "home" }
        }
    }

    // ============================================================
    // LIVE NASA SPACE NEWS PAGE
    // ============================================================

    Item {
        id: newsPage
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 82
        visible: window.currentPage === "news"
        z: 50

        Rectangle {
            anchors.fill: parent
            color: "#02050a"
            opacity: 0.96
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 55
            anchors.rightMargin: 55
            anchors.topMargin: 28
            anchors.bottomMargin: 28
            spacing: 16

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 74

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "LIVE SPACE INTELLIGENCE"
                        color: "#b7ff00"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 2
                    }

                    Text {
                        text: "NASA SPACE NEWS"
                        color: "white"
                        font.pixelSize: 30
                        font.bold: true
                    }

                    Text {
                        text: newsStatus + "   •   " + newsLastUpdated
                        color: newsError.length > 0 ? "#ff7777" : "#71808c"
                        font.pixelSize: 9
                        font.bold: true
                        font.letterSpacing: 1
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 130
                    Layout.preferredHeight: 38
                    radius: 4
                    color: newsRefreshMouse.containsMouse ? "#c9ff38" : "#b7ff00"

                    Text {
                        anchors.centerIn: parent
                        text: newsLoading ? "LOADING..." : "REFRESH NEWS"
                        color: "#02050a"
                        font.pixelSize: 9
                        font.bold: true
                        font.letterSpacing: 1
                    }

                    MouseArea {
                        id: newsRefreshMouse
                        anchors.fill: parent
                        enabled: !newsRequestRunning
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            newsLoading = true
                            newsRequestRunning = true
                            newsError = ""
                            newsStatus = "LOADING NASA SPACE NEWS"
                            newsManager.fetchNews()
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 8
                color: "#050b12"
                border.color: "#263540"
                border.width: 1
                clip: true

                ListView {
                    id: newsListView
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10
                    clip: true
                    model: newsModel

                    delegate: Rectangle {
                        width: newsListView.width
                        height: 125
                        radius: 6
                        color: newsCardMouse.containsMouse ? "#111e28" : "#09131c"
                        border.color: newsCardMouse.containsMouse ? "#60717d" : "#1d2b35"
                        border.width: 1

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            width: 4
                            radius: 2
                            color: "#b7ff00"
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.right: openNewsButton.left
                            anchors.rightMargin: 18
                            anchors.top: parent.top
                            anchors.topMargin: 13
                            text: model.title
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.right: openNewsButton.left
                            anchors.rightMargin: 18
                            anchors.top: parent.top
                            anchors.topMargin: 51
                            text: model.description
                            color: "#8997a1"
                            font.pixelSize: 10
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 12
                            anchors.right: openNewsButton.left
                            anchors.rightMargin: 18
                            text: model.source + "   •   " + model.date
                            color: "#52616d"
                            font.pixelSize: 8
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Rectangle {
                            id: openNewsButton
                            anchors.right: parent.right
                            anchors.rightMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            width: 108
                            height: 34
                            radius: 3
                            color: openNewsMouse.containsMouse ? "#c9ff38" : "#b7ff00"

                            Text {
                                anchors.centerIn: parent
                                text: "OPEN ARTICLE"
                                color: "#02050a"
                                font.pixelSize: 8
                                font.bold: true
                                font.letterSpacing: 0.8
                            }

                            MouseArea {
                                id: openNewsMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    if (model.link && model.link.length > 0)
                                        Qt.openUrlExternally(model.link)
                                }
                            }
                        }

                        MouseArea {
                            id: newsCardMouse
                            anchors.fill: parent
                            anchors.rightMargin: 130
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: newsModel.count === 0 && !newsLoading
                        width: parent.width - 80
                        text: newsError.length > 0
                              ? "NEWS COULD NOT BE LOADED\n\n" + newsError
                              : "NO NEWS ARTICLES AVAILABLE"
                        color: newsError.length > 0 ? "#ff7777" : "#65737e"
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    BusyIndicator {
                        anchors.centerIn: parent
                        visible: newsLoading
                        running: newsLoading
                        width: 42
                        height: 42
                    }
                }
            }
        }
    }

    // ============================================================
    // SPACE PIONEERS
    // ============================================================

    Item {
        id: spacePioneersPage

        anchors.fill: parent
        visible: window.currentPage === "spacePioneers"

        property var pioneers: [
            {
                number: "01",
                name: "NICOLAUS COPERNICUS",
                field: "HELIOCENTRIC ASTRONOMY",
                years: "1473 — 1543",
                title: "The Sun-centered model",
                description: "Copernicus proposed that Earth and the other planets move around the Sun, helping transform our model of the Solar System.",
                theory: "Heliocentric model",
                impact: "Changed the way humanity understood planetary motion and our place in the Solar System."
            },
            {
                number: "02",
                name: "GALILEO GALILEI",
                field: "OBSERVATIONAL ASTRONOMY",
                years: "1564 — 1642",
                title: "The telescope opened a new sky",
                description: "Galileo used telescopic observations to study the Moon, Jupiter's moons and the phases of Venus, providing important evidence for a changing view of the heavens.",
                theory: "Telescopic astronomy",
                impact: "Helped establish observation and experiment as powerful tools for understanding the universe."
            },
            {
                number: "03",
                name: "JOHANNES KEPLER",
                field: "PLANETARY MOTION",
                years: "1571 — 1630",
                title: "Planets follow mathematical paths",
                description: "Kepler described planetary orbits with three laws, including the idea that planets travel in elliptical orbits.",
                theory: "Three laws of planetary motion",
                impact: "Provided the mathematical description of planetary orbits later explained by Newton's gravity."
            },
            {
                number: "04",
                name: "ISAAC NEWTON",
                field: "GRAVITY & MOTION",
                years: "1643 — 1727",
                title: "One law connects Earth and the heavens",
                description: "Newton developed laws of motion and universal gravitation that explain falling objects, orbits and much of classical celestial mechanics.",
                theory: "Universal gravitation",
                impact: "Created a unified mathematical framework for motion on Earth and in space."
            },
            {
                number: "05",
                name: "NIKOLA TESLA",
                field: "ELECTROMAGNETISM",
                years: "1856 — 1943",
                title: "Electricity, waves and wireless technology",
                description: "Tesla made major contributions to alternating-current power, high-frequency electrical systems and wireless technology. His work is an important part of the technological history behind modern communication systems.",
                theory: "Electromagnetic and wireless technology",
                impact: "Helped advance electrical engineering and wireless technology used in the broader history of modern communications.",
                note: "Tesla did not create a modern space theory like relativity; this section focuses on his genuine contributions to electromagnetism and wireless technology."
            },
            {
                number: "06",
                name: "ALBERT EINSTEIN",
                field: "RELATIVITY & SPACETIME",
                years: "1879 — 1955",
                title: "Space and time are connected",
                description: "Einstein's special and general theories of relativity changed our understanding of space, time, motion and gravity.",
                theory: "Special and general relativity",
                impact: "General relativity describes gravity as the geometry of spacetime and is fundamental to modern cosmology."
            },
            {
                number: "07",
                name: "KONSTANTIN TSIOLKOVSKY",
                field: "ROCKET SCIENCE",
                years: "1857 — 1935",
                title: "The mathematics of reaching space",
                description: "Tsiolkovsky developed theoretical ideas about multistage rockets, rocket propulsion and spaceflight and derived the rocket equation.",
                theory: "Rocket equation and astronautics",
                impact: "Provided mathematical foundations for modern rocketry and human spaceflight."
            },
            {
                number: "08",
                name: "ROBERT GODDARD",
                field: "ROCKET ENGINEERING",
                years: "1882 — 1945",
                title: "Liquid-fuel rockets became real",
                description: "Goddard developed and tested liquid-fuel rocket technology and demonstrated that rockets could operate in practical engineering systems.",
                theory: "Liquid-fuel rocket propulsion",
                impact: "His experiments helped establish the engineering foundations of modern launch vehicles."
            },
            {
                number: "09",
                name: "EDWIN HUBBLE",
                field: "GALAXIES & COSMOLOGY",
                years: "1889 — 1953",
                title: "The universe is much larger than our galaxy",
                description: "Hubble's observations established that galaxies exist beyond the Milky Way and contributed to the evidence that the universe is expanding.",
                theory: "Expanding universe observations",
                impact: "Transformed astronomy from the study of our galaxy into modern extragalactic astronomy and cosmology."
            },
            {
                number: "10",
                name: "STEPHEN HAWKING",
                field: "BLACK HOLES & COSMOLOGY",
                years: "1942 — 2018",
                title: "Black holes are not completely black",
                description: "Hawking made major theoretical contributions to black holes, quantum theory in curved spacetime and cosmology.",
                theory: "Hawking radiation",
                impact: "Connected ideas from quantum physics, gravity and thermodynamics in the study of black holes."
            }
        ]

        Rectangle {
            anchors.fill: parent
            color: "#02050a"
            opacity: 0.88
        }

        // Header
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 78
            anchors.top: parent.top
            anchors.topMargin: 125
            text: "SPACE PIONEERS"
            color: "#b7ff00"
            font.pixelSize: 11
            font.bold: true
            font.letterSpacing: 2.5
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 75
            anchors.top: parent.top
            anchors.topMargin: 151
            text: "THE MINDS BEHIND OUR\nUNDERSTANDING OF SPACE"
            color: "white"
            font.pixelSize: 38
            font.bold: true
            lineHeight: 0.9
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 80
            anchors.top: parent.top
            anchors.topMargin: 153
            width: 370
            text: "From the heliocentric model to relativity, rocketry and black holes — explore the scientists and engineers who changed our view of the cosmos."
            color: "#82909a"
            font.pixelSize: 12
            lineHeight: 1.35
            wrapMode: Text.WordWrap
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 76
            anchors.rightMargin: 76
            anchors.top: parent.top
            anchors.topMargin: 245
            height: 1
            color: "#263540"
        }

        Flickable {
            id: pioneersFlickable
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 76
            anchors.rightMargin: 76
            anchors.topMargin: 265
            anchors.bottomMargin: 30
            clip: true
            contentWidth: width
            contentHeight: pioneersColumn.height
            boundsBehavior: Flickable.StopAtBounds

            Column {
                id: pioneersColumn
                width: pioneersFlickable.width
                spacing: 18

                Grid {
                    id: pioneersGrid
                    width: parent.width
                    columns: 2
                    columnSpacing: 18
                    rowSpacing: 18

                    Repeater {
                        model: spacePioneersPage.pioneers

                        delegate: Rectangle {
                            id: pioneerCard
                            width: (pioneersGrid.width - pioneersGrid.columnSpacing) / 2
                            height: 178
                            radius: 7
                            color: pioneerMouse.containsMouse ? "#0b151e" : "#050b12"
                            border.color: pioneerMouse.containsMouse ? "#b7ff00" : "#263540"
                            border.width: 1

                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 4
                                radius: 2
                                color: "#b7ff00"
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 23
                                anchors.top: parent.top
                                anchors.topMargin: 16
                                text: modelData.number
                                color: "#b7ff00"
                                font.pixelSize: 9
                                font.bold: true
                                font.letterSpacing: 1.5
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 23
                                anchors.right: parent.right
                                anchors.rightMargin: 22
                                anchors.top: parent.top
                                anchors.topMargin: 38
                                text: modelData.name
                                color: "white"
                                font.pixelSize: 17
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 23
                                anchors.top: parent.top
                                anchors.topMargin: 66
                                text: modelData.field + "   •   " + modelData.years
                                color: "#b7ff00"
                                font.pixelSize: 8
                                font.bold: true
                                font.letterSpacing: 0.8
                                elide: Text.ElideRight
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 23
                                anchors.right: parent.right
                                anchors.rightMargin: 22
                                anchors.top: parent.top
                                anchors.topMargin: 91
                                text: modelData.title
                                color: "#c4cdd3"
                                font.pixelSize: 11
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 23
                                anchors.right: parent.right
                                anchors.rightMargin: 22
                                anchors.top: parent.top
                                anchors.topMargin: 114
                                text: modelData.description
                                color: "#778690"
                                font.pixelSize: 9
                                lineHeight: 1.25
                                wrapMode: Text.WordWrap
                                maximumLineCount: 3
                                elide: Text.ElideRight
                            }

                            Rectangle {
                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 13
                                width: 112
                                height: 28
                                radius: 3
                                color: pioneerOpenMouse.containsMouse ? "#c9ff38" : "#b7ff00"

                                Text {
                                    anchors.centerIn: parent
                                    text: "EXPLORE  →"
                                    color: "#02050a"
                                    font.pixelSize: 8
                                    font.bold: true
                                    font.letterSpacing: 1
                                }

                                MouseArea {
                                    id: pioneerOpenMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        pioneerDetailsName = modelData.name
                                        pioneerDetailsPopup.open()
                                    }
                                }
                            }

                            MouseArea {
                                id: pioneerMouse
                                anchors.fill: parent
                                anchors.rightMargin: 145
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    pioneerDetailsName = modelData.name
                                    pioneerDetailsPopup.open()
                                }
                            }
                        }
                    }
                }
            }
        }

        // Details popup
        Popup {
            id: pioneerDetailsPopup
            anchors.centerIn: Overlay.overlay
            width: Math.min(window.width - 120, 760)
            height: Math.min(window.height - 170, 500)
            padding: 0
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            property var selected: null

            onOpened: {
                for (var i = 0; i < spacePioneersPage.pioneers.length; i++) {
                    if (spacePioneersPage.pioneers[i].name === pioneerDetailsName) {
                        selected = spacePioneersPage.pioneers[i]
                        break
                    }
                }
            }

            background: Rectangle {
                radius: 8
                color: "#050b12"
                border.color: "#b7ff00"
                border.width: 1

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 5
                    radius: 3
                    color: "#b7ff00"
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 30
                text: pioneerDetailsPopup.selected ? pioneerDetailsPopup.selected.number : ""
                color: "#b7ff00"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 2
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.right: parent.right
                anchors.rightMargin: 70
                anchors.top: parent.top
                anchors.topMargin: 57
                text: pioneerDetailsPopup.selected ? pioneerDetailsPopup.selected.name : ""
                color: "white"
                font.pixelSize: 28
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 103
                text: pioneerDetailsPopup.selected
                      ? pioneerDetailsPopup.selected.field + "   •   " + pioneerDetailsPopup.selected.years
                      : ""
                color: "#b7ff00"
                font.pixelSize: 9
                font.bold: true
                font.letterSpacing: 1
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 32
                anchors.rightMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 133
                height: 1
                color: "#263540"
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.right: parent.right
                anchors.rightMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 155
                text: pioneerDetailsPopup.selected ? pioneerDetailsPopup.selected.description : ""
                color: "#b5c0c7"
                font.pixelSize: 12
                lineHeight: 1.35
                wrapMode: Text.WordWrap
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 235
                text: "KEY IDEA"
                color: "#52616d"
                font.pixelSize: 8
                font.bold: true
                font.letterSpacing: 1.5
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.right: parent.right
                anchors.rightMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 257
                text: pioneerDetailsPopup.selected ? pioneerDetailsPopup.selected.theory : ""
                color: "white"
                font.pixelSize: 18
                font.bold: true
                wrapMode: Text.WordWrap
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 310
                text: "WHY IT MATTERS"
                color: "#52616d"
                font.pixelSize: 8
                font.bold: true
                font.letterSpacing: 1.5
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.right: parent.right
                anchors.rightMargin: 32
                anchors.top: parent.top
                anchors.topMargin: 332
                text: pioneerDetailsPopup.selected ? pioneerDetailsPopup.selected.impact : ""
                color: "#8d9aa3"
                font.pixelSize: 11
                lineHeight: 1.35
                wrapMode: Text.WordWrap
            }

            Text {
                visible: pioneerDetailsPopup.selected && pioneerDetailsPopup.selected.note !== undefined
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.right: parent.right
                anchors.rightMargin: 32
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 55
                text: pioneerDetailsPopup.selected && pioneerDetailsPopup.selected.note !== undefined
                      ? "NOTE  /  " + pioneerDetailsPopup.selected.note
                      : ""
                color: "#65737e"
                font.pixelSize: 9
                lineHeight: 1.3
                wrapMode: Text.WordWrap
            }

            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 25
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                width: 90
                height: 30
                radius: 3
                color: pioneerCloseMouse.containsMouse ? "#c9ff38" : "#b7ff00"

                Text {
                    anchors.centerIn: parent
                    text: "CLOSE"
                    color: "#02050a"
                    font.pixelSize: 8
                    font.bold: true
                    font.letterSpacing: 1
                }

                MouseArea {
                    id: pioneerCloseMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: pioneerDetailsPopup.close()
                }
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 115
            width: 125
            height: 40
            radius: 3
            color: homePioneerMouse.containsMouse ? "#0d1821" : "#08111a"
            border.color: homePioneerMouse.containsMouse ? "#b7ff00" : "#263540"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "←  HOME"
                color: homePioneerMouse.containsMouse ? "#b7ff00" : "#9aa7b1"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1
            }

            MouseArea {
                id: homePioneerMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: window.currentPage = "home"
            }
        }
    }

    // ============================================================
    // SPACE THEORY LIBRARY
    // PDF-based learning library. Add your own legally obtained PDF
    // files to the project folder and list them in the .qrc file.
    // ============================================================

    Item {
        id: spaceTheoryPage

        anchors.fill: parent
        visible: window.currentPage === "spaceTheory"

        // --------------------------------------------------------
        // PDF LIBRARY DATA
        // --------------------------------------------------------

        ListModel {
            id: theoryLibrary

            ListElement {
                number: "01"
                title: "THEORY OF RELATIVITY"
                author: "Albert Einstein"
                description: "A beginner-friendly reference to special and general relativity, spacetime, gravity and the speed of light."
                fileName: "theory_of_relativity.pdf"
                category: "RELATIVITY"
            }

            ListElement {
                number: "02"
                title: "A BRIEF HISTORY OF TIME"
                author: "Stephen Hawking"
                description: "A classic journey through the universe, time, black holes, cosmology and our understanding of reality."
                fileName: "a_brief_history_of_time.pdf"
                category: "COSMOLOGY"
            }

            ListElement {
                number: "03"
                title: "THE UNIVERSE IN A NUTSHELL"
                author: "Stephen Hawking"
                description: "Ideas about quantum theory, relativity, spacetime, dimensions and the structure of the universe."
                fileName: "the_universe_in_a_nutshell.pdf"
                category: "UNIVERSE"
            }

            ListElement {
                number: "04"
                title: "COSMOS"
                author: "Carl Sagan"
                description: "A wide-ranging exploration of the universe, stars, planets, life and humanity's place in space."
                fileName: "cosmos.pdf"
                category: "SPACE"
            }

            ListElement {
                number: "05"
                title: "ASTROPHYSICS FOR PEOPLE IN A HURRY"
                author: "Neil deGrasse Tyson"
                description: "An accessible introduction to major astrophysics ideas, from cosmic history to dark matter and dark energy."
                fileName: "astrophysics_for_people_in_a_hurry.pdf"
                category: "ASTROPHYSICS"
            }

            ListElement {
                number: "06"
                title: "THE FABRIC OF THE COSMOS"
                author: "Brian Greene"
                description: "An exploration of space, time, quantum mechanics and the deeper structure of the cosmos."
                fileName: "the_fabric_of_the_cosmos.pdf"
                category: "SPACETIME"
            }

            ListElement {
                number: "07"
                title: "THE ELEGANT UNIVERSE"
                author: "Brian Greene"
                description: "A popular introduction to string theory, quantum physics, relativity and the search for a unified theory."
                fileName: "the_elegant_universe.pdf"
                category: "PHYSICS"
            }

            ListElement {
                number: "08"
                title: "THE FIRST THREE MINUTES"
                author: "Steven Weinberg"
                description: "The early universe, the Big Bang and the physical processes that shaped the cosmos in its first moments."
                fileName: "the_first_three_minutes.pdf"
                category: "BIG BANG"
            }
        }

        // --------------------------------------------------------
        // PAGE HEADER
        // --------------------------------------------------------

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 112

            text: "QUANTUM SPACE EXPLORER"
            color: "#b7ff00"
            font.pixelSize: 11
            font.bold: true
            font.letterSpacing: 3
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 62
            anchors.top: parent.top
            anchors.topMargin: 138

            text: "SPACE THEORY"
            color: "white"
            font.pixelSize: 42
            font.bold: true
            font.letterSpacing: 2
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 196

            text: "A library of books and reference PDFs about space, physics and the universe."
            color: "#82909b"
            font.pixelSize: 13
        }

        // --------------------------------------------------------
        // SCROLLABLE PDF LIBRARY
        // --------------------------------------------------------

        Flickable {
            id: theoryFlickable

            anchors.left: parent.left
            anchors.leftMargin: 65
            anchors.right: parent.right
            anchors.rightMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 235
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 35

            clip: true
            contentWidth: width
            contentHeight: theoryColumn.height
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Column {
                id: theoryColumn
                width: theoryFlickable.width
                spacing: 18

                Text {
                    text: "SPACE THEORY LIBRARY  /  08 DOCUMENTS"
                    color: "#b7ff00"
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 2
                }

                Grid {
                    id: theoryGrid

                    width: parent.width
                    columns: 2
                    columnSpacing: 18
                    rowSpacing: 18

                    Repeater {
                        model: theoryLibrary

                        delegate: Rectangle {
                            width: (theoryGrid.width - theoryGrid.columnSpacing) / 2
                            height: 205

                            radius: 7
                            color: cardMouse.containsMouse ? "#0b151e" : "#050b12"
                            border.color: cardMouse.containsMouse ? "#b7ff00" : "#263540"
                            border.width: 1

                            // Green document marker
                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 4
                                radius: 2
                                color: "#b7ff00"
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 24
                                anchors.top: parent.top
                                anchors.topMargin: 18

                                text: number
                                color: "#b7ff00"
                                font.pixelSize: 10
                                font.bold: true
                                font.letterSpacing: 1.5
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 24
                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 42

                                text: title
                                color: "white"
                                font.pixelSize: 18
                                font.bold: true
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 24
                                anchors.top: parent.top
                                anchors.topMargin: 88

                                text: author
                                color: "#7f8c96"
                                font.pixelSize: 11
                                font.bold: true
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 24
                                anchors.right: parent.right
                                anchors.rightMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 112

                                text: description
                                color: "#8f9ca6"
                                font.pixelSize: 11
                                lineHeight: 1.25
                                wrapMode: Text.WordWrap
                                maximumLineCount: 3
                                elide: Text.ElideRight
                            }

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: 24
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 17

                                text: category
                                color: "#52616d"
                                font.pixelSize: 9
                                font.bold: true
                                font.letterSpacing: 1.5
                            }

                            Rectangle {
                                z: 1
                                anchors.right: parent.right
                                anchors.rightMargin: 18
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 12

                                width: 125
                                height: 34
                                radius: 3

                                color: cardOpenMouse.containsMouse ? "#c9ff38" : "#b7ff00"

                                Text {
                                    anchors.centerIn: parent
                                    text: "OPEN PDF  →"
                                    color: "#02050a"
                                    font.pixelSize: 9
                                    font.bold: true
                                    font.letterSpacing: 1
                                }

                                MouseArea {
                                    id: cardOpenMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        Qt.openUrlExternally("qrc:/" + fileName)
                                    }
                                }
                            }

                            MouseArea {
                                id: cardMouse
                                anchors.fill: parent
                                z: 0
                                hoverEnabled: true
                            }
                        }
                    }
                }

                Text {
                    width: parent.width
                    text: "Add more PDF documents by adding another ListElement above and adding the same file to your .qrc resource file."
                    color: "#52616d"
                    font.pixelSize: 10
                    wrapMode: Text.WordWrap
                    topPadding: 4
                    bottomPadding: 15
                }
            }
        }

        // --------------------------------------------------------
        // HOME BUTTON
        // --------------------------------------------------------

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: 65
            anchors.top: parent.top
            anchors.topMargin: 115

            width: 125
            height: 40
            radius: 3

            color: homeTheoryMouse.containsMouse ? "#0d1821" : "#08111a"
            border.color: homeTheoryMouse.containsMouse ? "#b7ff00" : "#263540"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "←  HOME"
                color: homeTheoryMouse.containsMouse ? "#b7ff00" : "#9aa7b1"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1
            }

            MouseArea {
                id: homeTheoryMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    window.currentPage = "home"
                }
            }
        }
    }

    // ============================================================
    // NAV BUTTON COMPONENT
    // ============================================================

    component NavButton: Item {

        property string text: ""

        signal clicked()

        width: buttonText.implicitWidth + 24
        height: 42

        Text {
            id: buttonText

            anchors.centerIn: parent

            text: parent.text

            color: navMouse.containsMouse
                   ? "#b7ff00"
                   : "#a5b0b9"

            font.pixelSize: 10
            font.bold: true
            font.letterSpacing: 1.2
        }

        Rectangle {
            anchors.left: buttonText.left
            anchors.right: buttonText.right
            anchors.bottom: buttonText.bottom
            anchors.bottomMargin: -8

            height: 2

            color: "#b7ff00"

            opacity: navMouse.containsMouse ? 1 : 0
        }

        MouseArea {
            id: navMouse

            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                parent.clicked()
            }
        }
    }

    // ============================================================
    // MISSION METRIC COMPONENT
    // ============================================================

    component MissionMetric: Rectangle {
        property string title: ""
        property string value: ""

        width: 230
        height: 82
        radius: 5
        color: "#081018"
        border.color: "#263540"
        border.width: 1

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: parent.top
            anchors.topMargin: 12
            text: parent.title
            color: "#64727d"
            font.pixelSize: 8
            font.bold: true
            font.letterSpacing: 1.2
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 34
            text: parent.value
            color: "white"
            font.pixelSize: 14
            font.bold: true
            lineHeight: 1.15
            wrapMode: Text.WordWrap
        }
    }

    // ============================================================
    // STAT BOX COMPONENT
    // ============================================================

    component StatBox: Rectangle {

        property string title: ""
        property string value: ""

        Layout.fillWidth: true

        height: 75

        color: "#050b12"
        opacity: 0.92

        border.color: "#263540"
        border.width: 1

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: 2

            color: "#b7ff00"
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.top: parent.top
            anchors.topMargin: 14

            text: parent.title

            color: "#687682"

            font.pixelSize: 8
            font.bold: true
            font.letterSpacing: 1.5
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            text: parent.value

            color: "white"

            font.pixelSize: 23
            font.bold: true
        }
    }

    // ============================================================
    // PLANET INFORMATION POPUP - EXPANDED SCIENCE EXPLORER
    // Keeps the existing planet card and app navigation intact.
    // ============================================================

    property string selectedPlanetTab: "OVERVIEW"

    function planetScienceText(tab) {
        var data = {
            "MERCURY": {
                "OVERVIEW": "Mercury is the smallest planet and the closest to the Sun. It has an ancient, heavily cratered rocky surface and almost no atmosphere to retain heat. Its temperatures vary enormously between day and night.",
                "INTERIOR": "CRUST: A thin, solid silicate-rock outer shell, fractured by many impact craters.\n\nMANTLE: A rocky silicate layer surrounding a very large metallic core.\n\nCORE: An unusually large iron-rich core, with a liquid outer portion and a solid inner portion inferred from measurements.\n\nSCIENCE NOTE: Mercury's global magnetic field is weak, but it indicates that part of its core remains liquid.",
                "ATMOSPHERE": "Mercury has an extremely thin exosphere, not a substantial atmosphere. It contains atoms such as oxygen, sodium, hydrogen, helium and potassium, supplied by the solar wind, micrometeorite impacts and the surface. These particles escape into space and are replenished. There is no Earth-like weather system.",
                "MOTION": "ROTATION: about 58.6 Earth days.\n\nYEAR: about 88 Earth days.\n\nORBITAL SPEED: averages about 47.4 km/s, the fastest average orbital speed of the planets.\n\nAXIAL TILT: very small, about 0.03 degrees.\n\nGRAVITY: about 3.7 m/s², or 0.38 times Earth's gravity.",
                "SURFACE": "SURFACE: Rocky, cratered, with cliffs called lobate scarps formed as the planet cooled and contracted.\n\nTEMPERATURE: roughly -180°C at some night-side locations to 430°C in the hottest sunlit regions.\n\nWATER ICE: Found in permanently shadowed polar craters, protected from direct sunlight.\n\nMAGNETIC FIELD: Global but much weaker than Earth's.",
                "EXPLORATION": "MARINER 10: First spacecraft to visit Mercury, in 1974–1975.\n\nMESSENGER: Orbited Mercury from 2011 to 2015 and mapped the planet in detail.\n\nBEPICOLOMBO: ESA/JAXA mission launched in 2018; its planned Mercury science phase will investigate the planet's interior, surface and magnetic environment."
            },
            "VENUS": {
                "OVERVIEW": "Venus is a rocky planet similar in size to Earth, but its dense carbon-dioxide atmosphere creates an extreme greenhouse effect. Thick clouds hide its surface from ordinary visible-light observation.",
                "INTERIOR": "CRUST: Solid rocky surface, including volcanic plains, highlands and many volcanic features.\n\nMANTLE: A deep silicate-rock layer. Its detailed motion is not directly observed and remains an active research topic.\n\nCORE: Likely a mainly iron-rich metallic core; its exact state and size are not yet well constrained.\n\nSCIENCE NOTE: Venus has no confirmed Earth-like global magnetic field.",
                "ATMOSPHERE": "MAIN GAS: About 96.5% carbon dioxide, with most of the remainder nitrogen.\n\nCLOUDS: Sulfuric-acid droplets form extensive cloud layers.\n\nPRESSURE: About 92 times Earth's sea-level pressure at the surface.\n\nWINDS: Upper-atmosphere winds race around the planet much faster than the surface rotates. The atmosphere traps heat very efficiently.",
                "MOTION": "ROTATION: about 243 Earth days, and retrograde (opposite to most planets' rotation direction).\n\nYEAR: about 225 Earth days.\n\nORBITAL SPEED: about 35 km/s on average.\n\nAXIAL TILT: about 177 degrees when expressed using the usual north-pole convention, reflecting its retrograde spin.\n\nGRAVITY: about 8.87 m/s², roughly 0.90 Earth's gravity.",
                "SURFACE": "SURFACE TEMPERATURE: about 465°C across much of the surface.\n\nLANDSCAPE: Volcanic plains, mountains, impact craters and large lava-flow features.\n\nWATER: No stable surface liquid water today.\n\nGEOLOGY: Volcanic activity is strongly supported by observations, though the planet's present activity and rate remain under investigation.",
                "EXPLORATION": "VENERA: Soviet landers returned the first images from the surface.\n\nMAGELLAN: NASA radar-mapped most of Venus in the early 1990s.\n\nAKATSUKI: JAXA orbiter studied Venus's atmosphere.\n\nUPCOMING MISSIONS: NASA's DAVINCI and VERITAS and ESA's EnVision are planned to investigate its atmosphere, surface and geological history."
            },
            "EARTH": {
                "OVERVIEW": "Earth is the only world currently known to support life. Liquid-water oceans cover about 71% of its surface. Its atmosphere, magnetic field and active geology help make the surface habitable.",
                "INTERIOR": "CRUST: The thin, solid outer shell. Oceanic crust is generally thinner and denser than continental crust.\n\nMANTLE: Hot, mostly solid silicate rock that can slowly flow over geological timescales. Mantle convection helps drive plate tectonics.\n\nOUTER CORE: Liquid iron-rich metal. Its moving electrically conducting fluid generates Earth's global magnetic field.\n\nINNER CORE: Solid, iron-rich centre under immense pressure.\n\nCUTAWAY: The layers are shown schematically and are not to scale.",
                "ATMOSPHERE": "MAIN GASES: About 78% nitrogen and 21% oxygen, with argon, carbon dioxide and variable water vapour.\n\nPRESSURE: About 101.3 kPa at mean sea level.\n\nWEATHER: Driven by sunlight, atmospheric circulation, oceans and the water cycle.\n\nMAGNETOSPHERE: Deflects much of the solar wind and helps protect the atmosphere from charged particles.",
                "MOTION": "ROTATION: about 23 hours 56 minutes relative to distant stars; the mean solar day is 24 hours.\n\nYEAR: about 365.256 days relative to distant stars.\n\nORBITAL SPEED: about 29.8 km/s on average.\n\nAXIAL TILT: about 23.4 degrees, producing the seasons.\n\nGRAVITY: about 9.81 m/s² at the surface.",
                "SURFACE": "DIAMETER: about 12,742 km on average.\n\nSURFACE: Oceans, continents, mountains, deserts, glaciers and active volcanoes.\n\nAVERAGE SURFACE TEMPERATURE: commonly quoted as about 15°C, though it depends on the dataset and period used.\n\nGEOLOGY: Plate tectonics continually recycles crust and helps regulate the long-term carbon cycle.\n\nMOON: One natural satellite.",
                "EXPLORATION": "EARTH OBSERVATION: Satellites measure weather, oceans, land, ice, gravity and magnetic fields.\n\nMOON MISSIONS: Human and robotic exploration has expanded knowledge of the Earth–Moon system.\n\nSPACE STATIONS: Crews study Earth and conduct research in microgravity.\n\nONGOING SCIENCE: Climate, biodiversity, geophysics and near-Earth space are monitored by many international missions."
            },
            "MARS": {
                "OVERVIEW": "Mars is a cold, dusty rocky world with a thin atmosphere. Ancient river channels, lake-bed minerals and other features show that liquid water once shaped parts of its surface.",
                "INTERIOR": "CRUST: Solid basalt-rich rock; local thickness varies and the planet has enormous volcanic provinces.\n\nMANTLE: Silicate rock beneath the crust.\n\nCORE: A metallic iron-rich core containing lighter elements; seismic data from NASA's InSight mission improved estimates of its size and state.\n\nSCIENCE NOTE: Mars does not have a strong global magnetic field today, although parts of its crust preserve ancient magnetism.",
                "ATMOSPHERE": "MAIN GAS: About 95% carbon dioxide, with nitrogen and argon.\n\nPRESSURE: Less than 1% of Earth's sea-level pressure on average.\n\nWEATHER: Dust storms, dust devils, clouds and seasonal frost.\n\nWATER: Water ice exists at the poles and below parts of the surface; liquid water is not stable on most of today's exposed surface.",
                "MOTION": "ROTATION: about 24 hours 37 minutes, making a Martian solar day (sol) about 24 hours 39 minutes.\n\nYEAR: about 687 Earth days.\n\nORBITAL SPEED: about 24.1 km/s on average.\n\nAXIAL TILT: about 25.2 degrees, giving Mars seasons.\n\nGRAVITY: about 3.71 m/s², roughly 0.38 Earth's gravity.",
                "SURFACE": "LANDMARKS: Olympus Mons, a giant shield volcano; Valles Marineris, an enormous canyon system; ancient impact craters and dry channels.\n\nTEMPERATURE: global average around -60°C, with large local and seasonal variations.\n\nMOONS: Phobos and Deimos.\n\nLIFE: No confirmed evidence of past or present life has been found; Mars remains a major astrobiology target.",
                "EXPLORATION": "ORBITERS: Map the surface, atmosphere and seasonal changes.\n\nROVERS: Sojourner, Spirit, Opportunity, Curiosity and Perseverance explored the surface.\n\nINSIGHT: Recorded marsquakes and studied the interior.\n\nPERSEVERANCE: Studies ancient habitability and collects samples for a possible future return to Earth."
            },
            "JUPITER": {
                "OVERVIEW": "Jupiter is the largest planet, a gas giant dominated by hydrogen and helium. It has no solid surface like Earth's; deeper layers transition gradually into increasingly dense fluid.",
                "INTERIOR": "OUTER ATMOSPHERE: Cloud bands and storms sit above deeper gas layers.\n\nMOLECULAR HYDROGEN: Hydrogen becomes denser with depth as pressure rises.\n\nMETALLIC HYDROGEN: Under enormous pressure, hydrogen behaves like an electrically conducting fluid.\n\nCENTRAL REGION: Models suggest a dense core or diluted core mixed with surrounding material; its exact structure is still being studied.\n\nIMPORTANT: Jupiter has no solid crust to stand on.",
                "ATMOSPHERE": "MAIN GASES: Hydrogen and helium, with traces of methane, ammonia, water vapour and other compounds.\n\nCLOUDS: Ammonia ice clouds, with deeper cloud layers expected.\n\nWEATHER: Powerful jet streams, lightning and long-lived storms.\n\nGREAT RED SPOT: A huge storm that has persisted for centuries, though its size and appearance change.",
                "MOTION": "ROTATION: about 9 hours 56 minutes near the equator; the planet rotates differentially.\n\nYEAR: about 11.86 Earth years.\n\nORBITAL SPEED: about 13.1 km/s on average.\n\nAXIAL TILT: about 3.1 degrees.\n\nGRAVITY: about 24.8 m/s² at the cloud-top reference level; there is no solid surface level comparable to Earth's.",
                "SURFACE": "NO SOLID SURFACE: The visible clouds are the upper atmosphere. Pressure and temperature increase rapidly deeper inside.\n\nCLOUD-TOP TEMPERATURE: roughly -145°C, depending on altitude and location.\n\nMAGNETIC FIELD: Extremely powerful, produced by conducting metallic hydrogen.\n\nRINGS: Faint, dusty rings surround the planet.\n\nMOONS: Jupiter has many confirmed moons; counts can change as new small moons are confirmed.",
                "EXPLORATION": "PIONEER 10 AND 11: First spacecraft to fly past Jupiter.\n\nVOYAGER 1 AND 2: Revealed rings, active moons and complex atmospheric features.\n\nGALILEO: Orbited Jupiter and sent a probe into its atmosphere.\n\nJUNO: Studies Jupiter's gravity, magnetic field, atmosphere and interior.\n\nJUICE: ESA mission exploring Jupiter and its large icy moons.
"
            },
            "SATURN": {
                "OVERVIEW": "Saturn is a gas giant best known for its broad, bright rings. Like Jupiter, it has no solid surface; the visible cloud tops are part of a deep atmosphere.",
                "INTERIOR": "OUTER ATMOSPHERE: Hydrogen and helium form clouds and banded weather.\n\nDEEP HYDROGEN: Gas becomes a dense fluid as pressure increases.\n\nMETALLIC HYDROGEN: Likely exists deeper inside and contributes to the magnetic field.\n\nCORE: Models indicate a diffuse or partially mixed heavy-element core region rather than a simple sharply bounded sphere.\n\nIMPORTANT: Saturn has no Earth-like crust.",
                "ATMOSPHERE": "MAIN GASES: Hydrogen and helium, with traces of methane, ammonia and other compounds.\n\nWEATHER: Fast winds, large storms and a remarkable six-sided jet-stream pattern near the north pole.\n\nCLOUD-TOP TEMPERATURE: around -178°C as a broad reference value.\n\nDENSITY: Saturn's average density is lower than liquid water's, but the planet is not a hollow object.",
                "MOTION": "ROTATION: roughly 10.5 hours, with details complicated by differential rotation and internal radio measurements.\n\nYEAR: about 29.4 Earth years.\n\nORBITAL SPEED: about 9.7 km/s on average.\n\nAXIAL TILT: about 26.7 degrees, producing pronounced seasons.\n\nGRAVITY: about 10.4 m/s² at a commonly used cloud-top reference level.",
                "SURFACE": "RINGS: Made mainly of water ice with some rocky and dusty material; they are broad but comparatively thin.\n\nATMOSPHERE: There is no solid surface to land on.\n\nMAGNETIC FIELD: Generated within the planet and unusually well aligned with its rotation axis.\n\nMOONS: Saturn has a large and changing catalogue of confirmed moons, including Titan and Enceladus.\n\nTITAN: Has lakes and seas of liquid methane and ethane on its surface.",
                "EXPLORATION": "PIONEER 11: First close flyby in 1979.\n\nVOYAGER 1 AND 2: Studied Saturn and its rings during flybys.\n\nCASSINI: Orbited Saturn from 2004 to 2017.\n\nHUYGENS: Landed on Titan in 2005, returning the first images from its surface.\n\nCASSINI'S LEGACY: Revealed active water-rich plumes from Enceladus and complex ring dynamics."
            },
            "URANUS": {
                "OVERVIEW": "Uranus is an ice giant with a blue-green appearance caused mainly by methane absorbing red light. Its rotation axis is tilted dramatically, so it appears to roll around the Sun as it orbits.",
                "INTERIOR": "ATMOSPHERE: Hydrogen, helium and methane above deeper fluid layers.\n\nICE-RICH MANTLE: A hot, dense mixture of water, ammonia and methane compounds; planetary scientists use 'ices' as a composition term, not a claim that these layers are frozen solid.\n\nCORE: Likely a denser rocky material at the centre.\n\nUNCERTAINTY: Uranus's internal heat flow and detailed interior structure remain poorly constrained because only one spacecraft has visited it.",
                "ATMOSPHERE": "MAIN GASES: Hydrogen and helium, with methane contributing to the blue-green colour.\n\nWEATHER: Clouds, seasonal changes and high-altitude winds.\n\nTEMPERATURE: The upper atmosphere is extremely cold, often near -224°C in quoted minimum measurements.\n\nMAGNETIC FIELD: Strongly tilted and offset from the planet's centre compared with Earth's field.",
                "MOTION": "ROTATION: about 17 hours 14 minutes, retrograde under the usual convention.\n\nYEAR: about 84 Earth years.\n\nORBITAL SPEED: about 6.8 km/s on average.\n\nAXIAL TILT: about 98 degrees, producing extreme seasonal daylight patterns.\n\nGRAVITY: about 8.7 m/s² at a reference level near the cloud tops.",
                "SURFACE": "NO SOLID OUTER SURFACE: The visible surface is the cloud tops; pressure and temperature rise inward.\n\nRINGS: Narrow, dark rings.\n\nMOONS: A family of moons named largely after characters from Shakespeare and Alexander Pope.\n\nSEASONS: Because of its extreme tilt, each pole experiences decades-long periods of sunlight or darkness.\n\nGEOLOGY: Some moons show signs of complex histories, but much remains unknown.",
                "EXPLORATION": "VOYAGER 2: Made the only close flyby in January 1986, discovering new moons and rings and measuring the magnetic field.\n\nTELESCOPES: Hubble and modern ground-based telescopes monitor storms, rings and seasonal changes.\n\nFUTURE: A dedicated orbiter and probe has been identified as a high-priority future mission concept, but no Uranus orbiter has yet arrived."
            },
            "NEPTUNE": {
                "OVERVIEW": "Neptune is a distant ice giant with a deep blue appearance and extremely dynamic weather. It receives little sunlight, yet its atmosphere has powerful winds and large storms.",
                "INTERIOR": "ATMOSPHERE: Hydrogen, helium and methane over deeper fluid layers.\n\nICE-RICH MANTLE: Likely contains hot, dense water-, ammonia- and methane-rich materials. The word 'ice' describes composition in planetary science; the interior is not simply frozen.\n\nCORE: Models suggest a denser rocky centre.\n\nUNCERTAINTY: Its detailed interior is inferred from remote observations and gravity-related models; it has not been explored by an orbiter.",
                "ATMOSPHERE": "MAIN GASES: Hydrogen and helium, with methane and other trace compounds.\n\nWEATHER: Dark vortices, bright clouds and very fast winds.\n\nTEMPERATURE: The upper atmosphere is extremely cold, though measurements vary with altitude.\n\nHEAT: Neptune emits more energy than it receives from the Sun, indicating an internal heat source.",
                "MOTION": "ROTATION: about 16 hours.\n\nYEAR: about 164.8 Earth years.\n\nORBITAL SPEED: about 5.4 km/s on average.\n\nAXIAL TILT: about 28.3 degrees.\n\nGRAVITY: about 11.2 m/s² at a reference level near the cloud tops.",
                "SURFACE": "NO SOLID OUTER SURFACE: The visible disk is atmospheric cloud tops.\n\nSTORMS: Voyager 2 observed the Great Dark Spot in 1989; dark storm systems can form and disappear.\n\nRINGS: Faint rings and ring arcs.\n\nMOONS: Triton is the largest moon and travels in a retrograde orbit; it may be a captured Kuiper Belt object.\n\nWINDS: Among the fastest measured in the Solar System.",
                "EXPLORATION": "VOYAGER 2: Made the only close flyby in August 1989, observing storms, rings and Triton.\n\nTELESCOPES: Hubble and the James Webb Space Telescope study atmospheric features and chemistry.\n\nFUTURE: Neptune and Triton remain important targets for future planetary exploration."
            }
        }
        return data[window.selectedPlanetName] && data[window.selectedPlanetName][tab]
               ? data[window.selectedPlanetName][tab]
               : "Scientific information for this section is being expanded."
    }

    Popup {
        id: planetInfoPopup

        width: Math.min(window.width - 36, 1040)
        height: Math.min(window.height - 70, 720)
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        anchors.centerIn: Overlay.overlay
        padding: 0

        background: Rectangle {
            radius: 9
            color: "#050b12"
            border.color: "#33424e"
            border.width: 1
        }

        contentItem: Item {
            anchors.fill: parent
            clip: true

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 4
                color: "#b7ff00"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 26
                anchors.rightMargin: 26
                anchors.topMargin: 20
                anchors.bottomMargin: 18
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 18

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: "PLANET SCIENCE EXPLORER  /  " + window.selectedPlanetType.toUpperCase()
                            color: "#b7ff00"
                            font.pixelSize: 10
                            font.bold: true
                            font.letterSpacing: 1.7
                        }

                        Text {
                            text: window.selectedPlanetName
                            color: "white"
                            font.pixelSize: 28
                            font.bold: true
                            font.letterSpacing: 1.2
                        }

                        Text {
                            Layout.fillWidth: true
                            text: window.selectedPlanetDescription
                            color: "#9eacb7"
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                        }
                    }

                    Image {
                        Layout.preferredWidth: 104
                        Layout.preferredHeight: 104
                        source: window.selectedPlanetImage
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#263540"
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 5

                    Repeater {
                        model: ["OVERVIEW", "INTERIOR", "ATMOSPHERE", "MOTION", "SURFACE", "EXPLORATION"]

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 34
                            radius: 3
                            color: window.selectedPlanetTab === modelData ? "#b7ff00" : "#0a141d"
                            border.color: window.selectedPlanetTab === modelData ? "#b7ff00" : "#263540"

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: window.selectedPlanetTab === modelData ? "#071009" : "#9aa7b1"
                                font.pixelSize: 8
                                font.bold: true
                                font.letterSpacing: 0.6
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: window.selectedPlanetTab = modelData
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 18

                    Rectangle {
                        Layout.preferredWidth: 250
                        Layout.fillHeight: true
                        radius: 5
                        color: "#08111a"
                        border.color: "#1f303c"
                        clip: true

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 8

                            Text {
                                text: window.selectedPlanetTab === "INTERIOR" ? "INTERIOR STRUCTURE" : "PLANET PROFILE"
                                color: "#b7ff00"
                                font.pixelSize: 9
                                font.bold: true
                                font.letterSpacing: 1.2
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                visible: window.selectedPlanetTab === "INTERIOR"
                                clip: true

                                // Individual planet interior illustrations loaded from Qt resources.
                                // These are scientific-style models, not photographs of the planets' interiors.
                                Image {
                                    id: planetInteriorImage
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    anchors.topMargin: 8
                                    width: Math.min(parent.width, parent.height * 0.82)
                                    height: Math.min(parent.height - 64, width * 1.18)
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                    asynchronous: true
                                    visible: window.selectedPlanetName !== "EARTH"
                                    source: window.selectedPlanetName === "MERCURY" ? "qrc:/planets/mercury_interior.png"
                                          : window.selectedPlanetName === "VENUS" ? "qrc:/planets/venus_interior.png"
                                          : window.selectedPlanetName === "EARTH" ? "qrc:/planets/earth_interior.png"
                                          : window.selectedPlanetName === "MARS" ? "qrc:/planets/mars_interior.png"
                                          : window.selectedPlanetName === "JUPITER" ? "qrc:/planets/jupiter_interior.png"
                                          : window.selectedPlanetName === "SATURN" ? "qrc:/planets/saturn_interior.png"
                                          : window.selectedPlanetName === "URANUS" ? "qrc:/planets/uranus_interior.png"
                                          : "qrc:/planets/neptune_interior.png"

                                    onStatusChanged: {
                                        console.log("Planet interior image status:", status,
                                                    "source:", source)
                                    }
                                }

                                // Draw Earth's thin crust explicitly so it remains visible even
                                // if the bundled Earth cutaway image uses a simplified diagram.
                                Item {
                                    id: earthInteriorDiagram
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    anchors.topMargin: 24
                                    width: Math.min(parent.width - 12, 156)
                                    height: width
                                    visible: window.selectedPlanetName === "EARTH"

                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: parent.width
                                        height: width
                                        radius: width / 2
                                        color: "#d9e0d8" // thin crust
                                    }
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: parent.width - 5
                                        height: width
                                        radius: width / 2
                                        color: "#4e9b58" // mantle
                                    }
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: parent.width * 0.70
                                        height: width
                                        radius: width / 2
                                        color: "#d66b37" // outer core
                                    }
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: parent.width * 0.43
                                        height: width
                                        radius: width / 2
                                        color: "#f2c34e" // inner core boundary
                                    }
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: parent.width * 0.21
                                        height: width
                                        radius: width / 2
                                        color: "#8c3027" // inner core
                                    }
                                }
                            }

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                visible: window.selectedPlanetTab !== "INTERIOR"

                                Image {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.top
                                    anchors.topMargin: 4
                                    width: 190
                                    height: 190
                                    source: window.selectedPlanetImage
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                }

                                Text {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    text: "REFERENCE DATA\n\nTYPE: " + window.selectedPlanetType +
                                          "\nMOONS: " + window.selectedPlanetMoons +
                                          "\nSUN DISTANCE: " + window.selectedPlanetDistance +
                                          "\nTEMPERATURE: " + window.selectedPlanetTemperature
                                    color: "#c4ced5"
                                    font.pixelSize: 10
                                    lineHeight: 1.3
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 5
                        color: "#070e15"
                        border.color: "#1f303c"
                        clip: true

                        Flickable {
                            id: planetDetailFlick
                            anchors.fill: parent
                            anchors.margins: 20
                            contentWidth: width
                            contentHeight: detailColumn.implicitHeight
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                            Column {
                                id: detailColumn
                                width: planetDetailFlick.width
                                spacing: 12

                                Text {
                                    width: parent.width
                                    text: window.selectedPlanetTab === "OVERVIEW" ? "AT A GLANCE"
                                          : window.selectedPlanetTab === "INTERIOR" ? "LAYERS AND INTERNAL STRUCTURE"
                                          : window.selectedPlanetTab === "ATMOSPHERE" ? "ATMOSPHERE AND MAGNETIC ENVIRONMENT"
                                          : window.selectedPlanetTab === "MOTION" ? "ROTATION AND ORBIT"
                                          : window.selectedPlanetTab === "SURFACE" ? "SURFACE AND PHYSICAL ENVIRONMENT"
                                          : "MISSIONS AND SCIENTIFIC DISCOVERIES"
                                    color: "#b7ff00"
                                    font.pixelSize: 11
                                    font.bold: true
                                    font.letterSpacing: 1.2
                                    wrapMode: Text.WordWrap
                                }

                                Text {
                                    width: parent.width
                                    text: window.planetScienceText(window.selectedPlanetTab)
                                    color: "#c4ced5"
                                    font.pixelSize: 12
                                    lineHeight: 1.45
                                    wrapMode: Text.WordWrap
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: "#263540"
                                }

                                Text {
                                    width: parent.width
                                    text: "REFERENCE NOTE: Values are approximate and may depend on the measurement method, altitude, location or latest scientific updates. For giant planets, temperatures refer to atmospheric levels rather than a solid surface."
                                    color: "#647582"
                                    font.pixelSize: 9
                                    lineHeight: 1.3
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "QUANTUM SPACE EXPLORER  •  PLANETARY SCIENCE DATABASE"
                        color: "#52616d"
                        font.pixelSize: 8
                        font.letterSpacing: 0.7
                    }

                    Rectangle {
                        width: 100
                        height: 32
                        radius: 3
                        color: planetCloseMouse.containsMouse ? "#14202a" : "#081018"
                        border.color: planetCloseMouse.containsMouse ? "#b7ff00" : "#33424e"

                        Text {
                            anchors.centerIn: parent
                            text: "CLOSE"
                            color: planetCloseMouse.containsMouse ? "#b7ff00" : "#9aa7b1"
                            font.pixelSize: 9
                            font.bold: true
                            font.letterSpacing: 1
                        }

                        MouseArea {
                            id: planetCloseMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: planetInfoPopup.close()
                        }
                    }
                }
            }
        }
    }

    // ============================================================
    // PLANET CARD COMPONENT
    // ============================================================

    component PlanetCard: Rectangle {

        property string planetName: ""
        property string description: ""
        property string planetImage: ""

        radius: 8

        color: planetMouse.containsMouse
               ? "#111d27"
               : "#0a121a"

        border.color: planetMouse.containsMouse
                      ? "#b7ff00"
                      : "#263540"

        border.width: 1

        clip: true

        // --------------------------------------------------------
        // PLANET IMAGE
        // --------------------------------------------------------

        Rectangle {
            id: imageContainer

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            height: 155

            radius: 8

            color: "#02060b"

            clip: true

            Image {
                id: planetImageObject

                anchors.fill: parent

                source: planetImage

                fillMode: Image.PreserveAspectFit

                asynchronous: true
                smooth: true
                mipmap: true

                opacity: planetMouse.containsMouse ? 1.0 : 0.92

                scale: planetMouse.containsMouse ? 1.04 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: 180
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: 180
                    }
                }
            }

            // Dark bottom gradient
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                height: 70

                gradient: Gradient {

                    GradientStop {
                        position: 0.0
                        color: "#00000000"
                    }

                    GradientStop {
                        position: 1.0
                        color: "#0a121a"
                    }
                }
            }

            // Image loading indicator
            Rectangle {
                anchors.centerIn: parent

                width: 34
                height: 34

                radius: 17

                color: "#081018"

                border.color: "#263540"
                border.width: 1

                visible: planetImageObject.status !== Image.Ready

                Text {
                    anchors.centerIn: parent

                    text: "Q"

                    color: "#b7ff00"

                    font.pixelSize: 13
                    font.bold: true
                }
            }
        }

        // --------------------------------------------------------
        // PLANET NAME
        // --------------------------------------------------------

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 20

            anchors.top: imageContainer.bottom
            anchors.topMargin: 12

            text: planetName

            color: "white"

            font.pixelSize: 18
            font.bold: true
            font.letterSpacing: 1
        }

        // --------------------------------------------------------
        // DESCRIPTION
        // --------------------------------------------------------

        Text {
            anchors.left: parent.left
            anchors.right: parent.right

            anchors.top: imageContainer.bottom
            anchors.topMargin: 42

            anchors.leftMargin: 20
            anchors.rightMargin: 20

            text: description

            color: "#8e9ba7"

            font.pixelSize: 11

            wrapMode: Text.WordWrap
            maximumLineCount: 2

            elide: Text.ElideRight
        }

        // --------------------------------------------------------
        // EXPLORE LABEL
        // --------------------------------------------------------

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 20

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15

            text: "EXPLORE  →"

            color: planetMouse.containsMouse
                   ? "#b7ff00"
                   : "#74818c"

            font.pixelSize: 10
            font.bold: true
            font.letterSpacing: 1
        }

        // --------------------------------------------------------
        // HOVER LINE
        // --------------------------------------------------------

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 2

            color: "#b7ff00"

            opacity: planetMouse.containsMouse ? 1 : 0
        }

        // --------------------------------------------------------
        // CLICK / HOVER
        // --------------------------------------------------------

        MouseArea {
            id: planetMouse

            anchors.fill: parent

            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onClicked: {
                window.selectedPlanetName = planetName
                window.selectedPlanetTab = "OVERVIEW"
                window.selectedPlanetImage = planetImage
                window.selectedPlanetDescription = description

                // Planet facts shown in the information panel
                if (planetName === "MERCURY") {
                    window.selectedPlanetType = "Terrestrial"
                    window.selectedPlanetMoons = "0"
                    window.selectedPlanetDistance = "57.9 million km"
                    window.selectedPlanetTemperature = "-173°C to 427°C"
                } else if (planetName === "VENUS") {
                    window.selectedPlanetType = "Terrestrial"
                    window.selectedPlanetMoons = "0"
                    window.selectedPlanetDistance = "108.2 million km"
                    window.selectedPlanetTemperature = "about 464°C"
                } else if (planetName === "EARTH") {
                    window.selectedPlanetType = "Terrestrial"
                    window.selectedPlanetMoons = "1"
                    window.selectedPlanetDistance = "149.6 million km"
                    window.selectedPlanetTemperature = "about 15°C"
                } else if (planetName === "MARS") {
                    window.selectedPlanetType = "Terrestrial"
                    window.selectedPlanetMoons = "2"
                    window.selectedPlanetDistance = "227.9 million km"
                    window.selectedPlanetTemperature = "about -63°C"
                } else if (planetName === "JUPITER") {
                    window.selectedPlanetType = "Gas giant"
                    window.selectedPlanetMoons = "115"
                    window.selectedPlanetDistance = "778.5 million km"
                    window.selectedPlanetTemperature = "about -110°C"
                } else if (planetName === "SATURN") {
                    window.selectedPlanetType = "Gas giant"
                    window.selectedPlanetMoons = "293"
                    window.selectedPlanetDistance = "1.43 billion km"
                    window.selectedPlanetTemperature = "about -140°C"
                } else if (planetName === "URANUS") {
                    window.selectedPlanetType = "Ice giant"
                    window.selectedPlanetMoons = "28"
                    window.selectedPlanetDistance = "2.87 billion km"
                    window.selectedPlanetTemperature = "about -195°C"
                } else if (planetName === "NEPTUNE") {
                    window.selectedPlanetType = "Ice giant"
                    window.selectedPlanetMoons = "16"
                    window.selectedPlanetDistance = "4.50 billion km"
                    window.selectedPlanetTemperature = "about -200°C"
                }

                planetInfoPopup.open()
            }
        }
    }

    // Report / feedback option restored. Kept self-contained so existing pages remain unchanged.
    Button {
        id: reportFeedbackButton
        text: "REPORT / FEEDBACK"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 22
        anchors.bottomMargin: 18
        z: 1000
        padding: 14
        font.pixelSize: 12
        font.bold: true
        contentItem: Text {
            text: reportFeedbackButton.text
            color: "#101600"
            font: reportFeedbackButton.font
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color: reportFeedbackButton.down ? "#8ac900" : "#b7ff00"
            radius: 5
            border.color: "#b7ff00"
        }
        onClicked: reportFeedbackDialog.open()
    }

    Dialog {
        id: reportFeedbackDialog
        title: "Report / Feedback"
        modal: true
        anchors.centerIn: parent
        width: Math.min(560, window.width - 40)
        padding: 22
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        property bool reportSubmitting: false

        background: Rectangle {
            color: "#071019"
            radius: 8
            border.color: "#b7ff00"
            border.width: 1
        }

        header: Label {
            text: "REPORT / FEEDBACK"
            color: "#b7ff00"
            font.pixelSize: 16
            font.bold: true
            padding: 8
            background: Rectangle { color: "#071019" }
        }

        contentItem: ColumnLayout {
            spacing: 12

            Label {
                Layout.fillWidth: true
                text: "Explain what happened or share your suggestion (maximum 5000 characters)."
                color: "#a9bac9"
                wrapMode: Text.WordWrap
            }

            Label {
                text: "CATEGORY"
                color: "#b7ff00"
                font.pixelSize: 11
                font.bold: true
            }
            ComboBox {
                id: reportCategoryField
                Layout.fillWidth: true
                model: ["Bug / Error", "Incorrect Information", "User Interface", "Feature Request", "Other"]
            }

            Label {
                text: "SUBJECT"
                color: "#b7ff00"
                font.pixelSize: 11
                font.bold: true
            }
            TextField {
                id: reportSubjectField
                Layout.fillWidth: true
                placeholderText: "Short subject (required)"
                maximumLength: 150
                color: "white"
                background: Rectangle {
                    color: "#0c1721"
                    radius: 4
                    border.color: reportSubjectField.activeFocus ? "#b7ff00" : "#263540"
                }
            }

            TextArea {
                id: reportMessageField
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                placeholderText: "Write your report or feedback here..."
                wrapMode: TextArea.Wrap
                color: "white"
                selectByMouse: true
                onTextChanged: {
                    if (text.length > 5000)
                        text = text.substring(0, 5000)
                }
                background: Rectangle {
                    color: "#0c1721"
                    radius: 4
                    border.color: reportMessageField.activeFocus ? "#b7ff00" : "#263540"
                }
            }

            Label {
                Layout.fillWidth: true
                text: reportMessageField.text.length + " / 5000 characters"
                color: "#71879a"
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 11
            }

            Label {
                id: reportSubmitStatus
                Layout.fillWidth: true
                visible: text.length > 0
                wrapMode: Text.WordWrap
                color: text.indexOf("success") >= 0 ? "#b7ff00" : "#ff8b8b"
                text: ""
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Item { Layout.fillWidth: true }

                Button {
                    text: "CLOSE"
                    onClicked: reportFeedbackDialog.close()
                }

                Button {
                    id: reportSubmitButton
                    text: reportSubmitting ? "SENDING..." : "SUBMIT"
                    enabled: !reportSubmitting && reportMessageField.text.trim().length > 0 && reportSubjectField.text.trim().length > 0
                    onClicked: {
                        var xhr = new XMLHttpRequest()
                        var endpoint = "http://127.0.0.1/quantum_reports/submit_report.php"
                        reportSubmitting = true
                        reportSubmitStatus.color = "#a9bac9"
                        reportSubmitStatus.text = "Sending report to local server..."
                        xhr.open("POST", endpoint)
                        // Send JSON as text/plain to avoid a browser-style CORS preflight
                        // when the QML page is loaded from qrc:/; PHP still decodes php://input.
                        xhr.setRequestHeader("Content-Type", "text/plain; charset=UTF-8")
                        xhr.setRequestHeader("Accept", "application/json")
                        xhr.onreadystatechange = function() {
                            if (xhr.readyState !== XMLHttpRequest.DONE)
                                return
                            reportSubmitting = false
                            var result = {}
                            try {
                                result = JSON.parse(xhr.responseText)
                            } catch (e) {
                                console.log("Report endpoint returned non-JSON:", xhr.responseText)
                            }
                            if (xhr.status >= 200 && xhr.status < 300 && result.success === true) {
                                reportSubmitStatus.color = "#b7ff00"
                                reportSubmitStatus.text = "Report submitted successfully. Database row: " + result.id
                                reportMessageField.text = ""
                                reportSubjectField.text = ""
                                reportCategoryField.currentIndex = 0
                                console.log("Report submitted. Database row ID:", result.id)
                            } else {
                                reportSubmitStatus.color = "#ff8b8b"
                                reportSubmitStatus.text = result.error || ("Server request failed (HTTP " + xhr.status + "). Response: " + xhr.responseText)
                                console.log("Report submission failed:", xhr.status, xhr.responseText)
                            }
                        }
                        xhr.onerror = function() {
                            reportSubmitting = false
                            reportSubmitStatus.color = "#ff8b8b"
                            reportSubmitStatus.text = "Network error contacting " + endpoint + ". Check Apache and the endpoint URL."
                            console.log("Report network error. Endpoint:", endpoint)
                        }
                        xhr.ontimeout = function() {
                            reportSubmitting = false
                            reportSubmitStatus.color = "#ff8b8b"
                            reportSubmitStatus.text = "Report request timed out. Check that Apache and MySQL are running."
                        }
                        xhr.timeout = 15000
                        xhr.send(JSON.stringify({
                            category: reportCategoryField.currentText,
                            subject: reportSubjectField.text.trim(),
                            message: reportMessageField.text.trim(),
                            app_version: "1.0"
                        }))
                    }
                }
            }
        }
    }

}