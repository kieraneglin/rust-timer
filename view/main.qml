import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
  width: Screen.desktopAvailableWidth
  height: Screen.desktopAvailableHeight
  title: "Timer GUI"
  Component.onCompleted: visible = true

  Image {
    id: icon
    width: 50
    height: 50
    anchors.horizontalCenter: parent.horizontalCenter
  }

  Button {
    id: start
    text: "Start"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: icon.bottom
    onClicked: function() {
      start.enabled = false
      icon.source = chooseIcon()
      timer.start_timer()
    }
  }

  Row {
    spacing: 2
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    Image {
      source: "icons/red.png"
      MouseArea {
        anchors.fill: parent
        onClicked: endTimer()
      }
    }
    Image {
      source: "icons/yellow.png"
      MouseArea {
        anchors.fill: parent
        onClicked: endTimer()
      }
    }
    Image {
      source: "icons/green.png"
      MouseArea {
        anchors.fill: parent
        onClicked: endTimer()
      }
    }
    Image {
      source: "icons/blue.png"
      MouseArea {
        anchors.fill: parent
        onClicked: endTimer()
      }
    }
    Image {
      source: "icons/purple.png"
      MouseArea {
        anchors.fill: parent
        onClicked: endTimer()
      }
    }
  }

  function endTimer() {
    start.enabled = true
    icon.source = ""
    timer.end_timer()
  }

  function chooseIcon() {
    var iconList = ["red", "yellow", "green", "blue", "purple"]
    var randomIcon = iconList[Math.floor(Math.random() * iconList.length)]

    return "icons/" + randomIcon + ".png"
  }
}
