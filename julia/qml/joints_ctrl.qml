import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
// import QtQml

ApplicationWindow {
  id: root
  title: "Joint Angle Controller"
  width: 612
  height: 300
  visible: true
  onClosing: Qt.quit()

  ColumnLayout {
    spacing: 6
    anchors.fill: parent

    
    Repeater {
        id: repeater
        model: 2
        RowLayout {
            Slider {
                id: slider
                Layout.alignment: Qt.AlignLeft
                Layout.fillWidth: false
                scale: 1
                clip: false
                wheelEnabled: false
                minimumValue: 0.0
                maximumValue: 180.0
                value: 90
                onValueChanged: {
                    observables.numbers[1] = slider.value;
                    console.log("Value changed: ", observables.numbers[1], slider.value, (index + 1));
                    console.log("Joint angles: ", joints.angles);
                }
            }

            Text {
                Layout.alignment: Qt.AlignRight
                text: slider.value
                font.pixelSize: 0.1*root.height
            }
        }        
    }

    Slider {
      value: observables.input
      Layout.alignment: Qt.AlignCenter
      Layout.fillWidth: true
      minimumValue: 0.0
      maximumValue: 180.0
      stepSize: 1.0
      onValueChanged: {
        observables.input = value;
        observables.output = observables.input;
      }
    }

    Text {
      Layout.alignment: Qt.AlignCenter
      text: observables.output
      font.pixelSize: 0.1*root.height
    }
  }

}
