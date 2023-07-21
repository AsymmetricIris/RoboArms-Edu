import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

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
            model: observables.num_joints
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
                    stepSize: 1 //0.25
                    value: 90
                    onValueChanged: {
                        Julia.changeAngleQml(index + 1, value);
                        Julia.showAnglesQml();
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignRight
                    text: slider.value
                    font.pixelSize: 0.1*root.height
                }
            }        
        }
    }
}
