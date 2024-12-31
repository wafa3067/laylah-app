import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class SliderComp extends StatefulWidget {
  const SliderComp({super.key});

  @override
  State<SliderComp> createState() => _SliderCompState();
}

class _SliderCompState extends State<SliderComp> {
  List Images = [
    'images/land1.jpg',
    'images/land2.jpg',
    'images/land3.jpg',
    'images/land4.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 160,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('slider').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Images.length,
                      itemBuilder: (context, int index) {
                        return Container(
                            padding: EdgeInsets.all(12),
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FullScreenWidget(
                                  disposeLevel: DisposeLevel.High,
                                  child: CachedNetworkImage(
                                    imageUrl:'${snapshot.data!.docs[index]['image']}',
                                    height: 200,
                                    fit: BoxFit.fill,
                                  ),
                                )));
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
