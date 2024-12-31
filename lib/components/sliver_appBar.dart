// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class SliverAppBar extends StatefulWidget {
//   const SliverAppBar({super.key});

//   @override
//   State<SliverAppBar> createState() => _SliverAppBarState();
// }

// class _SliverAppBarState extends State<SliverAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             title: Text('SilverAppBar Example'),
//             expandedHeight: 200,
//             flexibleSpace: FlexibleSpaceBar(
//               background: Image.network(
//                 'https://example.com/image.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (BuildContext context, int index) {
//                 return ListTile(
//                   title: Text('Item $index'),
//                 );
//               },
//               childCount: 20,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }