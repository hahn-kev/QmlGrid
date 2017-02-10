import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

DataTable {
    id: tableId
    property var sortedColumn
    property bool inverted: false    
    function sortBy(column) {
        var inverse = false;
        if (sortedColumn == column.name) inverse = !inverted
        function compareNumber(a, b) {
            return (a[column.name] - b[column.name]) * (inverse ? -1 : 1);
        }
        function compareString(a, b) {
            return a[column.name].localeCompare(b[column.name]) * (inverse ? -1 : 1);
        }
        var rows = tableId.rows;
        rows.sort(column.type == "string" ? compareString : compareNumber);
        tableId.rows = rows;
        sortedColumn = column.name;
        inverted = inverse;
    }
    
    columns: [
        {name:"name", label: "First Name", type:"string"},
        {name:"lastName", label: "Last Name", type:"string"},
        {name:"age", type:"number"},
    ]
    rows: [
        {lastName: "Bobberson", name:"bob", age: 4}, 
        {lastName: "be", name: "jo", age: 6},
        {lastName: "ington", name: "Alex", age: 50},
        {lastName: "Butterfly", name: "Rebekah", age: 22},
    ]
    onColumnHeaderClicked: {
        print("sorting column: " + column.name);
        sortBy(column);
    }
    onCellClicked: print("clicked cell:" + column.name + "|" + row.name)
    columnHeader: Row {
        property var column
        Text {
            text: sortedColumn !== column.name ? " " : (inverted ? "\u25B2" : "\u25BC")
        }
        Label {
            text: column.label || column.name
        }
    }
}