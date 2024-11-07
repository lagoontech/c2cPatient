// careTaker information screen


/*
CustomLabel(
text: "Morning",
fontSize: 16.sp,
fontWeight: FontWeight.bold,
),
kHeight10,
Row(
children: [
Expanded(
child: SingleChildScrollView(
scrollDirection: Axis.horizontal,
child: Wrap(
spacing: 8.0,
children: zone.map((String name) {
return CustomChip(
label: name,
isSelected: morning.contains(name),
onSelected: (bool selected) {
setState(() {
if (selected) {
morning
..clear()
..add(name);
debugPrint("chip selected :$name");
} else {
morning.remove(name);
}
});
},
);
}).toList(),
),
),
),
],
),
kHeight10,
CustomLabel(
text: "Noon",
fontSize: 16.sp,
fontWeight: FontWeight.bold,
),
kHeight10,
Row(
children: [
Expanded(
child: SingleChildScrollView(
scrollDirection: Axis.horizontal,
child: Wrap(
spacing: 8.0,
children: zone.map((String name) {
return CustomChip(
label: name,
isSelected: noon.contains(name),
onSelected: (bool selected) {
setState(() {
if (selected) {
noon
..clear()
..add(name);
debugPrint("chip selected :$name");
} else {
noon.remove(name);
}
});
},
);
}).toList(),
),
),
),
],
),
kHeight10,
CustomLabel(
text: "Evening",
fontSize: 16.sp,
fontWeight: FontWeight.bold,
),
kHeight10,
Row(
children: [
Expanded(
child: SingleChildScrollView(
scrollDirection: Axis.horizontal,
child: Wrap(
spacing: 8.0,
children: zone.map((String name) {
return CustomChip(
label: name,
isSelected: morning.contains(name),
onSelected: (bool selected) {
setState(() {
if (selected) {
morning
..clear()
..add(name);
debugPrint("chip selected :$name");
} else {
morning.remove(name);
}
});
},
);
}).toList(),
),
),
),
],
),*/
