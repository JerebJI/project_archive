red [title: "Single User Contacts App" needs: 'view]
if not exists? %contacts [write %contacts ""]
display/close "Contacts" [
    t: table 78x34 options [
        "Name" left .3 "Address" left .4 "Phone" left .3
    ] data (load %contacts) [set-texts [n a p] t/selected]
    f: panel data [
        after 2
        text 18 "Name:"     n: field
        text 18 "Address:"  a: field
        text 18 "Phone:"    p: field
        reverse
        button " Submit " [
            attempt [t/remove-row (index? find t/data t/selected) + 2 / 3]
            t/add-row/position reduce [
                copy n/text copy a/text copy p/text
            ] 1
            set-texts [n a p] ""
        ]
        button " New " [set-texts [n a p] ""  t/redraw]
        button " Delete "  [
            t/remove-row (index? find t/data t/selected) + 2 / 3
            set-texts [n a p] ""
        ]
    ]
] [save %contacts t/data  alert "saved"  quit]
do-events