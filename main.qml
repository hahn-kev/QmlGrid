import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    visible: true
    width: 640
    height: 600
    title: qsTr("Hello World")
        Column {
            spacing: 15
            Label {
                text: "Simple Grid"
            }
            Switch {
                id: visibleAgeColumnSwitchId
                text: "Age column visible"
            }

            ExampleGrid1 {
                ageColumn.visible: visibleAgeColumnSwitchId.checked
            }
            Label {
                text: "Sortable Grid, click column headers to sort"
            }
            
            AdvancedExample {
            }
            
            
        }
    
}
