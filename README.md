# QmlGrid
`DataTable.qml` has the main control, it depends on a couple other files.

Some examples are shown in `ExampleGrid1.qml` and `AdvancedExample.qml`

## Simple grid
![image](https://cloud.githubusercontent.com/assets/4575355/22850897/ef876344-efc7-11e6-93eb-17f08f77bb43.PNG)
```qml
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

```

## Advanced grid
![image](https://cloud.githubusercontent.com/assets/4575355/22850898/ef88fd26-efc7-11e6-9a27-f170dc42a398.PNG)
