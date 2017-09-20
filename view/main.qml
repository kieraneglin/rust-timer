import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

ApplicationWindow {
  width: 400
  height: 300
  title: "COSC GUI"
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
      icon.source = "icons/red.png"
      timer.start_timer()
    }
  }

  Button {
    text: "End"
    onClicked: function() {
      timer.end_timer()
    }
  }
}
