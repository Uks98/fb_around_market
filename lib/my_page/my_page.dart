import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/firs_base_mixin/fire_base_queue.dart';
import 'package:fb_around_market/my_page/logic/my_page_steam_logic.dart';
import 'package:fb_around_market/my_page/widgets/w_achivement_widgets.dart';
import 'package:fb_around_market/my_page/widgets/w_favorite_widget.dart';
import 'package:fb_around_market/notification_widget/w_toast_notification.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../logic/map/market_add_data/map_marker_data.dart';
import '../logic/map/market_add_widgets/w_load_widget.dart';


class MyPage extends StatefulWidget {
  MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}
//유저의 리뷰를 불러오는 stream입니다.

class _MyPageState extends State<MyPage> with FireBaseInitialize{
  MyPageStreamLogic myPageStreamLogic = MyPageStreamLogic(); // mypage에 사용되는 stream 관련 로직


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 1,
        title: const Text(
          "마이 페이지",
          style: TextStyle(color:Colors.white),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () async{
          await fireBaseAuthInit.signOut();}, icon: const Icon(Ionicons.log_in_outline,size: 30,))],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeightBox(biggestHeight),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                //bool isChecked = _userInfo.funUserCheck(UserInfoData.user!.uid);
                if (index == 0) {
                    return StreamBuilder(
                        stream: myPageStreamLogic.streamProfileInfo(),
                        builder: (context, snapshot) {
                          final userData = snapshot.data?.docs.first;
                          if(snapshot.hasData){
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 80,
                                  backgroundImage:NetworkImage(userData?["profileImage"].toString().replaceAll("(", "").replaceAll(")","") ?? ""),
                                ),
                                HeightBox(normalHeight),
                                "${userData?["userId"] ?? "데이터가 존재하지 않습니다." }".text.fontWeight(FontWeight.w700).size(biggestFontSize +5).make(),
                              ],
                            );
                          }
                          return CustomLodeWidget.loadingWidget();
                        }
                    );
                }else if(index == 1){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightBox(biggestHeight),
                      "즐겨찾기".text.make(),
                      "내가 좋아하는 가게는 ?".text.size(bigFontSize).fontWeight(FontWeight.w700).make(),
                      HeightBox(biggestHeight),
                      StreamBuilder(stream: myPageStreamLogic.streamUserFavorite(), builder: (context,snapshot){
                        final favoriteList = snapshot.data?.docs ?? [];
                        if (snapshot.hasData){
                          return SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index){
                                        //final mainSumImage = favoriteList[index]["categoryImage"].toString().replaceAll("(", "").replaceAll(")","");
                                        final favoriteIndex = favoriteList[index];
                                        if(favoriteList.isNotEmpty){
                                          return FavoriteWidget(
                                              imagePath : favoriteIndex["favoriteItem"]["categoryImage"].toString().replaceAll("(", "").replaceAll(")",""),
                                              categories : favoriteIndex["favoriteItem"]["categories"][0],
                                              marketName : favoriteIndex["favoriteItem"]["marketName"],
                                              kindOfCash : favoriteIndex["favoriteItem"]["kindOfCash"][0]

                                          );
                                        }
                                        return CustomLodeWidget.loadingWidget();

                                  }, separatorBuilder: (ctx,index)=>WidthBox(bigWidth), itemCount: favoriteList.length,),
                                ),
                              ],
                            ),
                          );
                        }else if(snapshot.data!.docs.isEmpty){
                          return CustomLodeWidget.loadingWidget();
                        }
                        return CustomLodeWidget.loadingWidget();
                      }
                      ),
                    ],
                  );
                } else if (index == 2) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightBox(biggestHeight),
                      "내 가게".text.make(),
                      HeightBox(smallHeight),
                      "내가 추가한 가게 알아보기".text.size(bigFontSize).fontWeight(FontWeight.w700).make(),

                      HeightBox(biggestHeight),
                      StreamBuilder(stream: myPageStreamLogic.streamUserWriteList(), builder: (context,snapshot){
                        final userWriteList = snapshot.data?.docs ?? [];
                        if (snapshot.hasData){
                          return SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context,index){
                                      //final mainSumImage = favoriteList[index]["categoryImage"].toString().replaceAll("(", "").replaceAll(")","");
                                      final userWriteListIndex = userWriteList[index];
                                      if(userWriteList.isNotEmpty){
                                        return FavoriteWidget(
                                            imagePath : userWriteListIndex["categoryImage"].toString().replaceAll("(", "").replaceAll(")",""),
                                            categories : userWriteListIndex["categories"][0],
                                            marketName : userWriteListIndex["marketName"],
                                            kindOfCash : userWriteListIndex["kindOfCash"][0]
                                        );
                                      }
                                      return CustomLodeWidget.loadingWidget();
                                    }, separatorBuilder: (ctx,index)=>WidthBox(bigWidth), itemCount: userWriteList.length,),
                                ),
                              ],
                            ),
                          );
                        }else if(snapshot.data!.docs.isEmpty){
                          return CustomLodeWidget.loadingWidget();
                        }
                        return CustomLodeWidget.loadingWidget();
                      }
                      ),
                    ],
                  );
                }else if(index == 3){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightBox(biggestHeight),
                      "내 칭호".text.make(),
                      HeightBox(smallHeight),
                      "미션을 완료해 칭호를 획득하세요!".text.size(bigFontSize).fontWeight(FontWeight.w700).make(),

                      HeightBox(biggestHeight),
                      StreamBuilder(stream: myPageStreamLogic.streamUserWriteList(), builder: (context,snapshot){
                        final userWriteList = snapshot.data?.docs ?? [];
                        if (snapshot.hasData){
                          if(int.parse(userWriteList.length.toString()) == 1){
                            ToastNotification.missionWriteLen(context,'축하합니다. "첫만남은 어려워" 칭호를 획득하셨습니다.');
                          }
                          return Row(
                            children: [
                              int.parse(userWriteList.length.toString()) > 1 ?
                              AchievementWidget(image: 'assets/app_pro_color.png', aciName: '첫 만남은 어려워', color: baseColor,).pOnly(left: 20):
                              AchievementWidget(image: 'assets/app_pro_darks.png', aciName: '첫 만남은 어려워', color: greyFontColor,).pOnly(left: 20)
                              //AchievementWidget(image: 'assets/app_pro_color.png', aciName: '첫 만남은 어려워', color: baseColor,).pOnly(left: 20):
                              ,AchievementWidget(image: 'assets/nice_dark.png', aciName: '붕어빵 사냥꾼', color: greyFontColor,).pOnly(left: 20)
                            ],
                          );
                        }else if(snapshot.data!.docs.isEmpty){
                          return CustomLodeWidget.loadingWidget();
                        }
                        return CustomLodeWidget.loadingWidget();
                      }
                      ),
                    ],
                  );
                }
                return Container();
              },
              itemCount: 5,
            ),
          ),
        ],
      ).pOnly(left: 20),
    );
  }
  Widget campingListWidget(String imaUrl, String name, String location, String x, double width, double height) {
    return Stack(
      children: [
        Row(
          children: [
            const WidthBox(20),
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(imaUrl), fit: BoxFit.fill),
              ),
            ),
            const WidthBox(20),
            SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16),
                  ),
                 const HeightBox(20),
                  Text(
                    location.toString(),
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  const HeightBox(20),
                  Text(x,
                      style:
                      const TextStyle(fontSize: 13,color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

