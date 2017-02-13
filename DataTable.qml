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
    property var columns
    //rows is used to provide the data for the grid
    //the properties of each object in the list should
    //match with the values provided in columns
    property alias rows: rowRepeaterId.model
    
    //a height of -1 will cause the implicitHeight to be used instead
    property real rowHeight: 48
    property real leftMostColumnMargin: 24
    property real interColumnMargin: 56
    property real rightMostColumnMargin: 24
    property Component divider: DefaultDivider {}
    property Component columnHeader: DefaultHeader {}
    property Component cell: DefaultCell {}
    
    signal columnHeaderClicked(var column)
    signal cellClicked(var column, var row)
    
    GridLayout {
        id: gridId
        anchors.fill: parent
        columns: columnDefRepeaterId.count
        columnSpacing: 0
        rowSpacing: 0
        Repeater {
            id: columnDefRepeaterId
            model: rootId.columns.length
            Item {
                id:headerColumnId
                property var column: rootId.columns[index]
                property Item header
                Layout.preferredWidth: header.implicitWidth + header.anchors.leftMargin + header.anchors.rightMargin
                Layout.preferredHeight: rootId.rowHeight
                Layout.fillWidth: true
                Layout.fillHeight: true
                implicitHeight: header.implicitHeight
                Component.onCompleted: {
                    if (rootId.divider) {
                        rootId.divider.createObject(headerColumnId, {
                                                        "anchors.bottom": headerColumnId.bottom,
                                                        "anchors.left": headerColumnId.left,
                                                        "anchors.right": headerColumnId.right
                                                    });
                    }
                    var headerProperties = {
                        "anchors.leftMargin": (index == 0 ? rootId.leftMostColumnMargin : rootId.interColumnMargin),
                        "anchors.rightMargin": (index == (columnDefRepeaterId.count - 1) ? rootId.rightMostColumnMargin : 0),
                        "anchors.verticalCenter": headerColumnId.verticalCenter,
                        "anchors.left": headerColumnId.left,
                        "column": column
                    };
                    
                    headerColumnId.header = rootId.columnHeader.createObject(headerColumnId, headerProperties);
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: rootId.columnHeaderClicked(column)
                }
            }
        }
        
        Repeater {
            id: rowRepeaterId
            Repeater {
                id: cellRepeaterId
                property var row:  (typeof display !== 'undefined') ? display : modelData
                property int rowIndex: index
                model: rootId.columns.length
                Item {
                    id: cellId
                    property Item cell
                    property var column: rootId.columns[index]
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth : cell.implicitWidth + cell.anchors.leftMargin + cell.anchors.rightMargin
                    Layout.preferredHeight: rootId.rowHeight
                    implicitHeight: cell.implicitHeight
                    Component.onCompleted: {
                        if (rootId.divider) {
                            var dviderProperties = {
                                "anchors.bottom": cellId.bottom,
                                "anchors.left": cellId.left,
                                "anchors.right": cellId.right
                            };
                            rootId.divider.createObject(cellId, dviderProperties);
                        }
                        
                        var value = getValue(column, row);
                        if (column.format) value = column.format(value, row);
                        var cellProperties = {
                            "anchors.leftMargin": (index == 0 ? rootId.leftMostColumnMargin : rootId.interColumnMargin),
                            "anchors.rightMargin": (index == (cellRepeaterId.count - 1) ? rootId.rightMostColumnMargin : 0),
                            "anchors.verticalCenter": cellId.verticalCenter,
                            "column": column,
                            "row": row,
                            "value": value
                        };
                        if (column.type == "number") {
                            cellProperties["anchors.right"] = cellId.right;
                        } else {
                            cellProperties["anchors.left"] = cellId.left;
                        }
                        
                        cellId.cell = rootId.cell.createObject(cellId, cellProperties);
                    }
                    function getValue(column, row) {
                        
                        var i = column.name.indexOf(".");
                        if (i == -1) return row[column.name];
                        var from = 0;
                        var tmp = row;
                        do {
                            tmp = tmp[column.name.substring(from, i)];
                            from = i + 1;
                            i = column.name.indexOf(".", from);
                        } while (i !== -1);
                        tmp = tmp[column.name.substring(from, column.name.length)];
                        print(tmp);
                        return tmp;
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: rootId.cellClicked(column, row);
                    }                    
                }
            }
        }
    }
}