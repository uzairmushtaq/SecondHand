// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:get/get.dart';
// import 'package:secondhand/constants/colors.dart';
// import 'package:secondhand/utils/size_config.dart';
// import 'package:secondhand/views/widgets/no_data_widget.dart';
// import 'package:secondhand/views/widgets/show_loading.dart';
// import '../../../../../controllers/articles_controller.dart';
// import '../../../../../controllers/auth_controller.dart';
// import '../../../../../controllers/loading_controller.dart';
// import '../../../../../models/article_model.dart';
// import '../../../item details/items_details.dart';

// class LikedItems extends StatefulWidget {
//   const LikedItems({
//     Key? key,
//     required this.uid,
//   }) : super(key: key);
//   final String uid;
//   @override
//   State<LikedItems> createState() => _LikedItemsState();
// }

// class _LikedItemsState extends State<LikedItems> {
//   List<ArticleModel> likeItem = [];
//   final authCont = Get.find<authController>();

//   @override
//   Widget build(BuildContext context) {
//     authCont.isLoading.value = true;
//     //FOR CHECKING RECENT SEARCH ITEMS
//     List<ArticleModel> article = Get.find<ArticlesController>().gettingArticles;
//     for (int i = 0; i < article.length; i++) {
//       if (article[i].likedBy!.contains(widget.uid)) {
//         likeItem.add(article[i]);

//         //print("Added all");
//       }
//     }
//     authCont.isLoading.value = false;
//     return GetX<authController>(
//         init: authController(),
//         builder: (authController load) {
//           return ShowLoading(
//               child: likedItemsUI(context), inAsyncCall: load.isLoading.value);
//         });
//   }

//   Widget likedItemsUI(BuildContext context) {
//     return SingleChildScrollView(
//       physics:
//           const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//       scrollDirection: Axis.horizontal,
//       child: likeItem.isNotEmpty
//           ? AnimationLimiter(
//               child: Row(
//                 children: AnimationConfiguration.toStaggeredList(
//                   duration: const Duration(milliseconds: 375),
//                   childAnimationBuilder: (widget) => SlideAnimation(
//                     horizontalOffset: 100.0,
//                     child: FadeInAnimation(
//                       child: widget,
//                     ),
//                   ),
//                   children: [
//                     ...List.generate(
//                         likeItem.length,
//                         (index) => InkWell(
//                             onTap: () {
//                               Get.to(
//                                   () => ItemDetailsPage(
//                                         article: likeItem,
//                                         index: index,
//                                       ),
//                                   transition: Transition.rightToLeft);
//                             },
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   height: SizeConfig.heightMultiplier * 20,
//                                   width: SizeConfig.widthMultiplier * 42,
//                                   margin: EdgeInsets.only(
//                                       right: SizeConfig.widthMultiplier * 2,
//                                       top: SizeConfig.heightMultiplier * 2,
//                                       bottom: SizeConfig.heightMultiplier * 2),
//                                   decoration: BoxDecoration(
//                                       color: kPrimaryColor,
//                                       borderRadius: BorderRadius.circular(12)),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(15),
//                                     child: ShaderMask(
//                                       shaderCallback: (rect) {
//                                         return LinearGradient(
//                                           begin: Alignment.topCenter,
//                                           end: Alignment.bottomCenter,
//                                           colors: [
//                                             Colors.black,
//                                             Colors.black,
//                                             Colors.black,
//                                             Colors.black.withOpacity(0.2),
//                                           ],
//                                         ).createShader(Rect.fromLTRB(
//                                             0, 0, rect.width, rect.height));
//                                       },
//                                       blendMode: BlendMode.dstIn,
//                                       child: Image.network(
//                                         likeItem[index].images![0] ?? "",
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                     bottom: SizeConfig.heightMultiplier * 3,
//                                     left: SizeConfig.widthMultiplier * 3,
//                                     child: SizedBox(
//                                       width: SizeConfig.widthMultiplier * 38,
//                                       child: Text(
//                                         likeItem[index].title ?? "",
//                                         maxLines: 2,
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w700,
//                                             fontSize:
//                                                 SizeConfig.textMultiplier *
//                                                     2.1),
//                                       ),
//                                     ))
//                               ],
//                             )))
//                   ],
//                 ),
//               ),
//             )
//           : SizedBox(
//               height: SizeConfig.heightMultiplier * 20,
//               width: SizeConfig.widthMultiplier*90,
//               child: const NoDataWidget()),
//     );
//   }
// }
