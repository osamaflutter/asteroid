import 'dart:ui';

import 'package:asteroid/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cardd extends StatelessWidget {
  const Cardd({
    super.key,
    required this.imageText,
    required this.label,
    required this.text,
    required this.padd,
    required this.isRow,
  });

  final String label;
  final String imageText;
  final String text;
  final double padd;
  final bool isRow;

  @override
  Widget build(BuildContext context) {
    final children = [
      Text(
        label,
        style: GoogleFonts.rubik(color: AppColors.textPrimary, fontSize: 24),
      ),
      Padding(
        padding: EdgeInsets.only(left: padd),
        child: Image.asset(imageText, width: 70, height: 100, scale: 1),
      ),
    ];
    return Container(
      // margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        //Outer glow layer (not clipped)
        boxShadow: [
          BoxShadow(
            color: const Color(0xff00B8DB).withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 4,
            blurStyle: BlurStyle.outer,
          ),
          BoxShadow(
            color: const Color(0xffFB64B6).withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 4,
            blurStyle: BlurStyle.outer,
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                // margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(left: 10, top: 12),
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xffFF6900).withOpacity(0.9),
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 180,
                //margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(left: 10, top: 12),
                decoration: BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color(0xff00B8DB).withOpacity(0.3),
                  //     blurRadius: 100,
                  //     spreadRadius: 9,
                  //     blurStyle: BlurStyle.outer,
                  //     offset: Offset.fromDirection(3, 3),
                  //     //spreadRadius: ,
                  //   ),
                  //   BoxShadow(
                  //     color: Color(0xff00B8DB).withOpacity(0.3),
                  //     blurRadius: 100,
                  //     spreadRadius: 2,
                  //     blurStyle: BlurStyle.outer,
                  //     offset: Offset.fromDirection(3, 3),
                  //     //spreadRadius: ,
                  //   ),
                  //   BoxShadow(
                  //     color: Color.fromARGB(202, 0, 183, 219).withOpacity(0.3),
                  //     blurRadius: 100,
                  //     spreadRadius: 3,
                  //     blurStyle: BlurStyle.outer,
                  //     offset: Offset.fromDirection(3, 3),
                  //     //spreadRadius: ,
                  //   ),
                  // ],
                  border: Border.all(color: Color.fromARGB(197, 0, 183, 219)),
                  color: Color(0xff5C84D4).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isRow
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: children),
                            )
                          : Column(children: children),
                      //SizedBox(height: 60),
                      Row(
                        children: [
                          Text(
                            text,
                            style: GoogleFonts.robotoMono(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),

                          //SizedBox(width: 30),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
