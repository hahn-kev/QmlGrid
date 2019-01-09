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
    property list<DataColumn> columns
    //count modified by events in column header
    property int visibleColumnCount: columns.length

    //rows is used to provide the data for the grid
    //the properties of each object in the list should
    //match with the values provided in columns
    property var rows

    //a height of -1 will cause the implicitHeight to be used instead
    property real rowHeight: 48
    property real leftMostColumnMargin: 24
    property real interColumnMargin: 56
    property real rightMostColumnMargin: 24
    property Component divider: DefaultDivider {}
    property Component columnHeader: DefaultHeader {}
    property Component cell: DefaultCell {}

    signal columnHeaderClicked(DataColumn column)
    signal cellClicked(var column, var row)

    GridLayout {
        id: gridId
        anchors.fill: parent
        columns: rootId.visibleColumnCount
        columnSpacing: 0
        rowSpacing: 0
        Repeater {
            id: columnDefRepeaterId
            model: rootId.columns.length
            Item {
                id:headerColumnId
                property DataColumn column: rootId.columns[index]
                property Item header
                visible: column.visible
                onVisibleChanged: rootId.visibleColumnCount += visible ? 1 : -1
                Layout.preferredWidth: {
                    if(column.columnWidth !== undefined && (typeof column.columnWidth) === 'string' ){
                        var percentage = parseInt(column.columnWidth.substring(0, column.columnWidth.indexOf('%'))) / 100;
                        var width = gridId.width * percentage;
                        return width + header.anchors.leftMargin + header.anchors.rightMargin;
                    } else if(column.columnWidth !== undefined && (typeof column.columnWidth) === 'number' ){
                        return column.columnWidth + header.anchors.leftMargin + header.anchors.rightMargin;
                    } else {
                        return header.implicitWidth + header.anchors.leftMargin + header.anchors.rightMargin
                    }
                }
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
                        "anchors.leftMargin": (index == 0 ? rootId.leftMostColumnMargin : rootId.interColumnMargin / 2),
                        "anchors.rightMargin": Qt.binding(function () {return index == (gridId.columns - 1) ? rootId.rightMostColumnMargin : rootId.interColumnMargin / 2}),
                        "anchors.verticalCenter": headerColumnId.verticalCenter,
                        "anchors.left": headerColumnId.left,
                        "column": column,
                        "width": Qt.binding(function () { return headerColumnId.width; })
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
            model: rootId.rows
            Repeater {
                id: cellRepeaterId
                property var row:  (typeof display !== 'undefined') ? display : rootId.rows[index]
                property var namespaces: ({})
                property int rowIndex: index
                model: rootId.columns.length
                Item {
                    id: cellId
                    property Item cell
                    property DataColumn column: rootId.columns[index]
                    visible: column.visible
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: {
                        if(column.columnWidth !== undefined && (typeof column.columnWidth) === 'string' ){
                            var percentage = parseInt(column.columnWidth.substring(0, column.columnWidth.indexOf('%'))) / 100;
                            var width = gridId.width * percentage;
                            return width + cell.anchors.leftMargin + cell.anchors.rightMargin;
                        } else if(column.columnWidth !== undefined && (typeof column.columnWidth) === 'number' ){
                            return column.columnWidth + cell.anchors.leftMargin + cell.anchors.rightMargin;
                        } else {
                            return cell.implicitWidth + cell.anchors.leftMargin + cell.anchors.rightMargin
                        }
                    }
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
                        var context = row;
                        var value;
                        if (column.namespace) {
                            if (!cellRepeaterId.namespaces[column.namespace]) {
                                cellRepeaterId.namespaces[column.namespace] = column.getValue(column.namespace, row);
                            }
                            context = cellRepeaterId.namespaces[column.namespace]
                        }
                        value = column.getValue(column.field, context);

                        var cellProperties = {
                            "anchors.leftMargin": (index == 0 ? rootId.leftMostColumnMargin : rootId.interColumnMargin / 2),
                            "anchors.rightMargin": Qt.binding(function () {return index == (gridId.columns - 1) ? rootId.rightMostColumnMargin : rootId.interColumnMargin / 2}),
                            "anchors.verticalCenter": cellId.verticalCenter,
                            "column": column,
                            "context": context,
                            "row": row,
                            "value": value,
                            "width": Qt.binding(function () { return cellId.width; })
                        };
                        if (column.type == "number") {
                            cellProperties["anchors.right"] = cellId.right;
                        } else {
                            cellProperties["anchors.left"] = cellId.left;
                        }
                        var cellComponent = rootId.cell;
                        if (column.cell) {
                            cellComponent = column.cell;
                        }

                        cellId.cell = cellComponent.createObject(cellId, cellProperties);
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
