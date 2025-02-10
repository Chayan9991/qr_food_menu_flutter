# self_order_qr_menu

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### [App Bar] Old Styles
AppBar(
elevation: 0,
toolbarHeight: 110,
flexibleSpace: Container(
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Colors.teal.shade300,
Colors.teal.shade800,
],
),
),
),
title: Padding(
padding: EdgeInsets.only(right: screenWidth * 0.05),
child: Row(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
CircleAvatar(
radius: 30, // Slightly larger avatar
backgroundColor: Colors.teal.shade900, // Border-like effect
child: const CircleAvatar(
radius: 28, // Inner avatar size
backgroundImage: NetworkImage(
"https://images.pexels.com/photos/7507581/pexels-photo-7507581.jpeg?auto=compress&cs=tinysrgb&w=600",
),
),
),
SizedBox(width: 12),
const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
"Brew Haven Coffee & Bistro",
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 20,
color: Colors.white,
),
),
SizedBox(height: 5),
Text(
"123 Java Lane, Espresso District, Bean City, CA 98765",
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(fontSize: 12, color: Colors.white70),
),
Text(
"Timing: 10.00 AM - 11.00 PM",
style: TextStyle(fontSize: 12, color: Colors.white70),
),
],
),
),
],
),
),
actions: [
if (screenWidth > 600) const CustomSearchBar(),
Builder(
builder: (context) => IconButton(
icon: const Icon(
Icons.menu_rounded,
size: 30,
color: Colors.white,
),
onPressed: () {
Scaffold.of(context).openEndDrawer();
},
),
),
],
),


