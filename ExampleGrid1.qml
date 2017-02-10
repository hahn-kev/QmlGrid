import QtQuick 2.0

DataTable {
    id: tableId
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
    }
    onCellClicked: print("clicked cell:" + column.name + "|" + row.name)
}