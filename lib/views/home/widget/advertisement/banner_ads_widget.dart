import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/components/box/box_height.dart';
import 'package:flutter_quiz_app/components/button/button_field.dart';
import 'package:flutter_quiz_app/model/advertisement.dart';
import 'package:flutter_quiz_app/theme/color.dart';
import 'package:flutter_quiz_app/theme/network_image.dart';
import 'package:flutter_quiz_app/theme/responsive_size.dart';
import 'package:flutter_quiz_app/theme/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerAdsWidget extends StatefulWidget {
  const BannerAdsWidget({super.key});

  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  int _currentIndex = 0;
  final textStyle = TextStyleCustom();
  final networkImage = NetworkImageWidget();
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: ads.length, 
        itemBuilder: (context, index, realIndex) {
          return _cardAds(ads[index],networkImage,textStyle);
        }, 
        options: CarouselOptions(
          height: StyleSize(context).widthPercent(180),
          enlargeCenterPage: false,
          aspectRatio: 16/9,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          autoPlayInterval: const Duration(seconds: 30),
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        )
    );
  }
  
  //Card
  Widget _cardAds(Advertisement ads, NetworkImageWidget networkImage, TextStyleCustom textStyle){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: StyleSize(context).screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(image: CachedNetworkImageProvider(ads.urlImage),fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10)
        ),
        child: _informationAds(ads)
      ),
    );
  }

  // O V E R L A Y
  Widget _overlay(){
    return Positioned.fill(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black12.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }

  Widget _loadingOverlay() {
    return const Center(
      child: CircularProgressIndicator(color: primaryColor,),
    );
  }

  Widget _errorOverlay() {
    return const Center(
      child: Text(
        'Error loading image',
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  Widget _informationAds(Advertisement ads){
    return Stack(
      children: [
        _overlay(),
        Positioned(
          top: 30,
          left: 20,
          child: Text(ads.title,style: textStyle.subTitleTextStyle(FontWeight.bold, Colors.white),),
        ),
        Positioned(
          top: 60,
          left: 20,
          child: SizedBox(width:StyleSize(context).widthPercent(200), child: Text(ads.description,maxLines:3,overflow:TextOverflow.ellipsis, style: textStyle.smallTextStyle(FontWeight.w400, Colors.white),)),
        ),
        Positioned(
          bottom: 10,
          left: 20,
          child: ButtonField(text: 'Play Now', function: (){
            launchUrl(Uri.parse(ads.url));
          }),
        ),


        FutureBuilder(
          future: precacheImage(CachedNetworkImageProvider(ads.urlImage), context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loadingOverlay(); // Hiển thị trạng thái loading
            } else if (snapshot.hasError) {
              return _errorOverlay(); // Hiển thị trạng thái lỗi
            } else {
              return const SizedBox.shrink(); // Không hiển thị gì khi tải thành công
            }
          },
        ),


      ],
    );
  }


}
