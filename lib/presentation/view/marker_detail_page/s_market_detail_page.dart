import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/domain/logic/market_Interaction_class.dart';
import 'package:fb_around_market/presentation/view/marker_detail_page/w_detail_widget/w_detail_map.dart';
import 'package:fb_around_market/presentation/view/marker_detail_page/w_detail_widget/w_detail_widgets.dart';
import 'package:fb_around_market/presentation/view/marker_detail_page/w_detail_widget/w_review_start.dart';
import 'package:fb_around_market/presentation/widget/market_add_widgets/w_row_star_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../common/color/color_box.dart';
import '../../../common/size_valiable/utill_size.dart';
import '../../../domain/logic/image_compress.dart';
import '../../../domain/model/market_add_data/map_marker_data.dart';
import '../../../ropository/detail_page_stream_impl/detail_data_impl.dart';
import '../../../ropository/firs_base_mixin/fire_base_queue.dart';
import '../../service/map_logic/map_logic.dart';
import '../../widget/market_add_widgets/w_button_widgets.dart';
import '../../widget/market_add_widgets/w_market_info.dart';
import '../login/login_riv_state.dart';

final convertString = StateProvider<String?>((ref) => "");

class MarketDetailPage extends ConsumerStatefulWidget {
  double gpsX;
  double gpsY;
  String id;
  String uid;
  String docId;
  List<dynamic> dayOfWeek;
  int? distance;

  MarketDetailPage(
      {super.key,
      required this.gpsX,
      required this.gpsY,
      required this.id,
      required this.uid,
      required this.docId,
      required this.dayOfWeek,
      this.distance});

  @override
  ConsumerState<MarketDetailPage> createState() =>
      _MarketDetailPageConsumerState();
}

class _MarketDetailPageConsumerState extends ConsumerState<MarketDetailPage>
    with FireBaseInitialize
    implements DetailStreamDataImpl {
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamMapData() {
    return firestoreInit
        .collection("mapMarker")
        .where("markerId", isEqualTo: widget.id)
        .snapshots();
  }

  //유저의 프로필을 불러오는 stream입니다.
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamProfileInfo() {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userUid", isEqualTo: widget.uid)
        .snapshots();
  }

  //유저의 리뷰를 불러오는 stream입니다.
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamReview() {
    final review = firestoreInit
        .collection("mapMarker")
        .doc(widget.docId)
        .collection("reviews")
        .orderBy("timestamp")
        .snapshots(); //마켓에 uid만 가져와서 users uid와 매치하는 이미지를 보여주자
    return review;
  }

//week list
  final List<String> weekList = ["월", "화", "수", "목", "금", "토", "일"];
  Uint8List? _imageData;
  int reviewScore = 0;
  TextEditingController reviewTec = TextEditingController();

  ///마켓과 사용자간 상호작용하는 메서드가 저장되어있는 인스턴스
  MarketInteractionClass marketInteractionClass = MarketInteractionClass();
  String? profileImage;
  bool isFavorite = false;

    XFile? image;
  Future<void> saveUserProfileImage() async {
    final ComplexImageLogicBox _imageCompress = ComplexImageLogicBox();
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref("marketImage/").child(
        "${DateTime.now().microsecondsSinceEpoch}_${image?.name ?? "??"}.jpg");
    final compressImage = await _imageCompress.imageCompressList(_imageData!);
    await storageRef.putData(compressImage);

    profileImage = await storageRef.getDownloadURL();

    await firestoreInit
        .collection("mapMarker")
        .doc(widget.docId)
        .update({"imagePath": profileImage});
  }

  @override
  Widget build(BuildContext context) {
    final cameraPosition = NCameraPosition(
      target: NLatLng(widget.gpsY, widget.gpsX),
      zoom: 15,
      bearing: 45,
      tilt: 30,
    );
    final marker =
        NMarker(id: 'test4', position: NLatLng(widget.gpsY, widget.gpsX));
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffFDFDFEFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: streamMapData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final marketData = snapshot.data?.docs[0];
                  final items = snapshot.data?.docs
                      .map((e) => MarketData.fromJson(e.data(),).copyWith(markerId: e.data()["markerId"],),).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightBox(50),
                      StreamBuilder(
                          stream: streamProfileInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final userDataAdapter = snapshot.data?.docs;
                              final userData = userDataAdapter
                                  ?.map((e) => e.data()["profileImage"]);
                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(userData
                                            .toString()
                                            .replaceAll("(", "")
                                            .replaceAll(")", "") ??
                                        ""),
                                  ),
                                  WidthBox(normalWidth),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "${userDataAdapter?.map((e) => e.data()["userId"]).join()}님이 등록하셨어요."
                                          .text
                                          .color(greyFontColor)
                                          .make(),
                                      HeightBox(smallHeight),
                                      "${marketData?["marketName"] == "" ? "매장 이름이 없어요!" : marketData?["marketName"]}"
                                          .text
                                          .fontWeight(FontWeight.w700)
                                          .size(biggestFontSize)
                                          .make(),
                                      HeightBox(smallHeight),
                                      "현재 위치에서 ${MapLogic.distanceConverter(widget.distance?.round() ?? 1232)} 걸려요"
                                          .text
                                          .color(Colors.grey[600])
                                          .make()
                                    ],
                                  ),
                                ],
                              ).pOnly(left: detailLeftRightPadding);
                            }
                            return Container();
                          }),
                      HeightBox(detailTopPadding),
                      VxBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //해당 부분만 rebuild
                            StatefulBuilder(builder: (context, setState) {
                              return DetailIconText(
                                colors: isFavorite ? baseColor : Colors.black,
                                icons: Ionicons.ribbon_outline,
                                title: "즐겨찾기",
                                callBack: () async {
                                  await marketInteractionClass.getFavoritePlace(
                                      snapshot,
                                      setState,
                                      isFavorite,
                                      widget.docId);
                                },
                              );
                            }),
                            DetailIconText(
                              icons: Ionicons.navigate_outline,
                              title: "길 안내",
                              callBack: () {},
                            ),
                            DetailIconText(
                              icons: Ionicons.pencil_outline,
                              title: "리뷰쓰기",
                              callBack: () {},
                            ),
                          ],
                        ).pOnly(top: 15),
                      )
                          .color(highGreyColor)
                          .width(mediaWidth - 50)
                          .height(80)
                          .withRounded(value: normalHeight)
                          .make()
                          .pOnly(left: 25),
                      HeightBox(detailTopPadding),
                      DetailMap(
                          mediaWidth: mediaWidth,
                          cameraPosition: cameraPosition,
                          marker: marker),
                      HeightBox(normalHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "가게 정보 & 메뉴"
                              .text
                              .color(greyFontColor)
                              .fontWeight(FontWeight.w700)
                              .size(bigFontSize)
                              .color(Colors.black)
                              .make(),
                          TextButtonWidget(
                            buttonName: "정보 수정",
                            callback: () {},
                          )
                        ],
                      ).pOnly(
                          left: detailLeftRightPadding,
                          right: detailLeftRightPadding),
                      HeightBox(normalHeight),
                      VxBox(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MarketInfoWidget(
                            intro: '도로명 주소',
                            value: "${marketData?["locationName"]}",
                          ),
                          MarketInfoWidget(
                            intro: '가게형태',
                            value: "${marketData?["marketType"]}",
                          ),
                          MarketInfoWidget(
                            intro: '결제방식',
                            value: "현금",
                          ),
                          MarketInfoWidget(
                            intro: '메뉴',
                            value: "${marketData?["categories"][0]}"
                                .replaceAll("(", "")
                                .replaceAll(")", ""),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "출몰 시기"
                                  .text
                                  .fontWeight(FontWeight.w700)
                                  .size(normalFontSize)
                                  .make()
                                  .pOnly(left: 60),
                              Row(
                                children:
                                    List.generate(weekList.length, (index) {
                                  bool isMatched = widget.dayOfWeek
                                      .contains(weekList[index]);
                                  return VxBox(
                                          child: Center(
                                              child: weekList[index]
                                                  .toString()
                                                  .text
                                                  .color(isMatched
                                                      ? Colors.white
                                                      : Colors.grey[200])
                                                  .make()))
                                      .size(30, 30)
                                      .color(
                                          isMatched ? baseColor : greyFontColor)
                                      .roundedFull
                                      .make()
                                      .pOnly(right: smallWidth);
                                }),
                              ).pOnly(right: 60)
                            ],
                          ),
                        ],
                      ))
                          .color(highGreyColor)
                          .width(mediaWidth - 50)
                          .height(200)
                          .withRounded(value: normalHeight)
                          .make()
                          .pOnly(left: 25),
                      HeightBox(detailTopPadding),

                      ///가게 사진
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "가게 사진"
                                  .text
                                  .color(greyFontColor)
                                  .fontWeight(FontWeight.w700)
                                  .size(bigFontSize)
                                  .color(Colors.black)
                                  .make(),
                              _imageData == null
                                  ? TextButtonWidget(
                                      buttonName: "사진 제보",
                                      callback: () async {
                                        ImagePicker imagePicker = ImagePicker();
                                        final img = await imagePicker.pickImage(
                                            source: ImageSource.gallery);
                                        _imageData = await img?.readAsBytes();
                                        setState(() {});
                                      },
                                    )
                                  : TextButtonWidget(
                                      buttonName: "사진 저장",
                                      callback: () async {
                                        await saveUserProfileImage();
                                      }),
                            ],
                          ).pOnly(
                              left: detailLeftRightPadding,
                              right: detailLeftRightPadding),
                          HeightBox(smallHeight),
                          items?[0].imagePath == null
                              ? VxBox(
                                      child: Center(
                                          child: "사진을 제보해주세요!"
                                              .text
                                              .fontWeight(FontWeight.w700)
                                              .size(bigFontSize)
                                              .color(Colors.grey[500])
                                              .make()))
                                  .color(highGreyColor)
                                  .width(mediaWidth - 50)
                                  .height(120)
                                  .withRounded(value: normalHeight)
                                  .make()
                                  .pOnly()
                              : SizedBox(
                                  width: 660,
                                  height: 100,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: items?.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          width: 100, height: 100,
                                          //image path를 리스트로 변경하면 두장이상 가능
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                items?[index]
                                                        .imagePath
                                                        .toString() ??
                                                    "",
                                                fit: BoxFit.cover,
                                              )),
                                        );
                                      }),
                                ),
                        ],
                      ),
                      HeightBox(detailTopPadding),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              "리뷰"
                                  .text
                                  .color(greyFontColor)
                                  .fontWeight(FontWeight.w700)
                                  .size(bigFontSize)
                                  .color(Colors.black)
                                  .make(),
                              PopupMenuButton(
                                  color: Colors.white,
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        child: const Text("리뷰 작성하기"),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, setState) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    title: const Text(
                                                        "이 가게를 추천하시나요?"),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const RowStars(),
                                                        HeightBox(normalHeight),
                                                        TextField(
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                          controller: reviewTec,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "리뷰를 남겨주세요(100자 이내)",
                                                            filled: true,
                                                            fillColor: Colors
                                                                .grey[100],
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              // 테두리에 라운드 적용
                                                              borderSide: BorderSide
                                                                  .none, // 테두리 제거
                                                            ),
                                                          ),
                                                          maxLines: 3,
                                                        )
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: const Text("취소"),
                                                      ),
                                                      Consumer(
                                                        builder: (context, ref,
                                                            child) {
                                                          final user = ref.watch(
                                                              userCredentialProvider);
                                                          final time = DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                  .month,
                                                              DateTime.now()
                                                                  .day);
                                                          return TextButton(
                                                            onPressed:
                                                                () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "mapMarker")
                                                                  .doc(widget
                                                                      .docId)
                                                                  .collection(
                                                                      "reviews")
                                                                  .add({
                                                                "uid": user
                                                                        ?.user
                                                                        ?.uid ??
                                                                    "",
                                                                "email": user
                                                                        ?.user
                                                                        ?.email ??
                                                                    "",
                                                                "review":
                                                                    reviewTec
                                                                        .text
                                                                        .trim(),
                                                                "timestamp":
                                                                    Timestamp
                                                                        .now(),
                                                                "writeTime":
                                                                    time,
                                                                "score":
                                                                    reviewScore +
                                                                        1
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                "등록"),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ];
                                  })
                            ],
                          ).pOnly(
                              left: detailLeftRightPadding,
                              right: detailLeftRightPadding),
                          HeightBox(smallHeight),
                          StreamBuilder(
                            stream: streamReview(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final item = snapshot.data?.docs ?? [];
                                if (item.isNotEmpty) {
                                  return SizedBox(
                                    width: 670,
                                    height: 300,
                                    child: ListView.separated(
                                        shrinkWrap: false,
                                        itemBuilder: (context, index1) {
                                          if (snapshot.hasData) {
                                            return GestureDetector(
                                                child: VxBox(
                                              child: reviewWidget(item, index1),
                                            )
                                                    .color(reviewPoPUp)
                                                    .withRounded(
                                                        value: normalWidth)
                                                    .make());
                                          } else if (!snapshot.hasData) {
                                            return VxBox(
                                                    child: Center(
                                                        child: "📷 리뷰를 작성해주세요!"
                                                            .text
                                                            .fontWeight(
                                                                FontWeight.w700)
                                                            .size(bigFontSize)
                                                            .color(Colors
                                                                .grey[500])
                                                            .make()))
                                                .color(highGreyColor)
                                                .width(mediaWidth - 50)
                                                .height(120)
                                                .withRounded(
                                                    value: normalHeight)
                                                .make()
                                                .pOnly();
                                          }
                                        },
                                        separatorBuilder: (ctx, idx) {
                                          return HeightBox(normalHeight);
                                        },
                                        itemCount: item.length),
                                  );
                                }
                              }
                              return VxBox(
                                      child: Center(
                                          child: "📷 리뷰를 작성해주세요!"
                                              .text
                                              .fontWeight(FontWeight.w700)
                                              .size(bigFontSize)
                                              .color(Colors.grey[500])
                                              .make()))
                                  .color(highGreyColor)
                                  .width(mediaWidth - 50)
                                  .height(120)
                                  .withRounded(value: normalHeight)
                                  .make()
                                  .pOnly();
                            },
                          )
                        ],
                      ),
                      const HeightBox(30),
                      widget.uid == userUid
                          ? Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        final db = FirebaseFirestore.instance;
                                        final col = db
                                            .collection("mapMarker")
                                            .doc(widget.docId)
                                            .delete();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("삭제")),
                                ),
                              ],
                            )
                          : Container(),
                      HeightBox(normalHeight),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }

  InkWell reviewWidget(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> item, int index1) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 400,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StreamBuilder(
                            stream: streamProfileInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final userDataAdapter = snapshot.data?.docs;
                                final userData = userDataAdapter
                                    ?.map((e) => e.data()["profileImage"]);
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(userData
                                              .toString()
                                              .replaceAll("(", "")
                                              .replaceAll(")", "") ??
                                          ""),
                                    ),
                                    WidthBox(normalWidth),
                                  ],
                                ).pOnly(left: detailLeftRightPadding);
                              }
                              return Container();
                            }),
                        "${item[index1]["email"]}"
                            .text
                            .size(normalFontSize)
                            .fontWeight(FontWeight.bold)
                            .make(),
                      ],
                    ),
                    HeightBox(normalHeight),
                    ReviewLogic.returnStar(item[index1]["score"])
                        .pOnly(left: 20),
                    HeightBox(bigHeight),
                    "${item[index1]["review"]}"
                        .text
                        .size(bigFontSize)
                        .fontWeight(FontWeight.w700)
                        .make()
                        .pOnly(left: 20),
                    HeightBox(bigHeight),
                  ],
                ),
              ],
            ),
          ),
        ],
      ).p(normalWidth),
    );
  }
}
