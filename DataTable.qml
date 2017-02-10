import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: rootId
    implicitHeight: gridId.implicitHeight
    implicitWidth: gridId.implicitWidth
    //columns should be an array of objects with the properties
    //name, type and label
    //name is the field name used to fetch the value from each row
    //type is used to indicate how we align the columns, string or number are the only options
    //label is the column display name, if non is provided it will fallback to name
    property alias columns: columnDefRepeaterId.model
    //rows is used to provide the data for the grid
    //the properties of each object in the list should
    //match with the values provided in columns
    property alias rows: rowRepeaterId.model
    
    property real rowHeight: 48
    property real leftMostColumnMargin: 24
    property real interColumnMargin: 56
    property real rightMostColumnMargin: 24
    property Component divider: Rectangle {
        height: 1
        color: "black"
        opacity: 0.12
    }
    
    signal columnHeaderClicked(var column)
    signal cellClicked(var column, var row)
    
    GridLayout {
        id: gridId
        columns: columnDefRepeaterId.count
        columnSpacing: 0
        rowSpacing: 0
        Repeater {
            id: columnDefRepeaterId            
            Item {
                id:headerColumnId
                Layout.preferredWidth: columnLabelId.implicitWidth + columnLabelId.anchors.leftMargin + columnLabelId.anchors.rightMargin
                Layout.preferredHeight: rootId.rowHeight
                Layout.fillWidth: true
                Layout.fillHeight: true
                Component.onCompleted: {
                    if (rootId.divider) {
                        rootId.divider.createObject(headerColumnId, {
                                                        "anchors.bottom": headerColumnId.bottom,
                                                        "anchors.left": headerColumnId.left,
                                                        "anchors.right": headerColumnId.right
                                                    });
                    }
                }
                Label {
                    id: columnLabelId
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: index == 0 ? rootId.leftMostColumnMargin : rootId.interColumnMargin
                    anchors.rightMargin: index == (columnDefRepeaterId.count - 1) ? rootId.rightMostColumnMargin : 0
                    opacity: 0.54
                    text: modelData.label || modelData.name
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: rootId.columnHeaderClicked(modelData)
                }
            }
        }
        
        Repeater {
            id: rowRepeaterId
            Repeater {
                id: cellRepeaterId
                property var row: modelData
                property int rowIndex: index
                Component.onCompleted: model = columnDefRepeaterId.model
                Item {
                    id: cellId
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth :labelId.implicitWidth + labelId.anchors.leftMargin + labelId.anchors.rightMargin
                    Layout.preferredHeight: rootId.rowHeight
                    Component.onCompleted: {
                        if (rootId.divider) {
                            rootId.divider.createObject(cellId, {
                                                            "anchors.bottom": cellId.bottom,
                                                            "anchors.left": cellId.left,
                                                            "anchors.right": cellId.right
                                                        });
                        }
                    }
                    Label {
                        id: labelId
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: index == 0 ? rootId.leftMostColumnMargin : rootId.interColumnMargin
                        anchors.rightMargin: index == (cellRepeaterId.count - 1) ? rootId.rightMostColumnMargin : 0
                        Component.onCompleted: {
                            if (modelData.type == "number") {
                                anchors.right = parent.right
                            } else {
                                anchors.left = parent.left
                            }
                        }
                        opacity: 0.87
                        text: row[modelData.name]
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: rootId.cellClicked(modelData, row);
                    }                    
                }
            }
        }
    }
}