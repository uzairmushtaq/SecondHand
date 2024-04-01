import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/firebase.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/models/article_model.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/widgets/my_profile_email.dart';
import 'package:secondhand/views/widgets/show_loading.dart';
import '../../../controllers/articles_controller.dart';

import '../../widgets/no_data_widget.dart';
import 'components/my_post_tile.dart';

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({Key? key}) : super(key: key);

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  List<ArticleModel> myPosts = [];
  gettingDraftItems() {
    authCont.isLoading.value = true;
    //FOR CHECKING RECENT SEARCH ITEMS
    List<ArticleModel> article = Get.find<ArticlesController>().getMyArticles;
       myPosts.addAll(article);

    authCont.isLoading.value = false;
  }

  @override
  void initState() {
    gettingDraftItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: SizeConfig.heightMultiplier * 2,
                    color: Colors.grey,
                  )),
              const Center(child: MyProfileAndEmailWidget()),
              Center(
                child: Container(
                    width: SizeConfig.widthMultiplier * 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 4,
                        vertical: SizeConfig.heightMultiplier * 2),
                    child: ShowLoading(
                      inAsyncCall: authCont.isLoading.value,
                      child:myPosts.isEmpty?NoDataWidget(): ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemCount: myPosts.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              MYPostTile(index: index, article: myPosts)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
