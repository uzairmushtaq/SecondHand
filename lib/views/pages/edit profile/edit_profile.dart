import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/utils/size_config.dart';
import 'package:secondhand/views/pages/edit%20profile/components/edit_profile_options.dart';
import 'package:path/path.dart';
import '../../../constants/icons.dart';
import '../../../controllers/auth_controller.dart';
import '../../../services/firebase_api.dart';
import 'components/add_name_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool? showMynumber;
  bool? showOnlyAlias;
  //for uploading profilePic
  File? file;
  String? imgPath, imgURL;
  UploadTask? imgTask;
  Future onImgSelected() async {
    //Picking from the files
    final result = await FilePicker.platform
        .pickFiles(type: FileType.image /*Only pick images from file*/);
    //if img is not picked then return simple
    if (result == null) return;
    //it will convert the filepath from the mobile files
    final path = result.files.single.path;
    //we have to set the path to local variables which we are using in uploading dunction
    setState(() {
      file = File(path!);
      imgPath = path;
    });
    onImageUploaded();
  }

  Future onImageUploaded() async {
    //if file is null
    if (file == null) return;
    //it will remove brackets and other unuseable words from the path
    final fileName = basename(file!.path);
    //we have to add file/ before the path to make the path useable
    final destination = 'files/$fileName';
    //Here the img will be uploaded on firestore storage
    imgTask = FirebaseApi.uploadImg(destination, file!);
    //if img is not uploading then it will return simple
    if (imgTask == null) return;
    //on completing upload that will generates a link which we store in imgURL
    final snapshot = await imgTask?.whenComplete(() {});
    imgURL = await snapshot!.ref.getDownloadURL();

    // uploading img to the userdatabase
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(Get.find<AuthController>().userss!.uid)
        .update({"ProfilePic": imgURL});
  }

////Upload meter
  Widget buildUploadTask(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data;
          final progress = snap!.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);

          return SizedBox(
            height: SizeConfig.heightMultiplier * 5,
            child: Center(
              child: Text(
                  percentage == "100.00"
                      ? AppLocalizations.of(context)!
                          .image_uploaded //"Your image is uploaded"
                      : AppLocalizations.of(context)!.uploading +
                          " $percentage", //"Uploading $percentage%",
                  style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.8,
                      fontWeight: FontWeight.w500)),
            ),
          );
        } else {
          return const SizedBox();
        }
      });
  TextEditingController nameCont = TextEditingController();
  TextEditingController aliasCont = TextEditingController();
  @override
  void initState() {
    super.initState();
    showOnlyAlias = Get.find<AuthController>().userInfo?.showAlias;
    showMynumber = Get.find<AuthController>().userInfo?.showNumber;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Center(
            child: GetX<AuthController>(
                init: AuthController(),
                builder: (AuthController _) {
              
                  return Column(
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
                      //profile image widget
                      Center(
                        child: InkWell(
                          onTap: () {
                            onImgSelected();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: SizeConfig.heightMultiplier * 10,
                                width: SizeConfig.widthMultiplier * 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 12)
                                    ],
                                    border: Border.all(
                                        width: 2, color: kPrimaryColor),
                                    shape: BoxShape.circle,
                                    image:
                                        _.userInfo?.profilePic != "N/A"
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    _.userInfo?.profilePic ?? ""),
                                                fit: BoxFit.cover)
                                            : null),
                                child: _.userInfo?.profilePic != "N/A"
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Image.asset(
                                          noProfileIcon,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black26,
                                radius: SizeConfig.widthMultiplier * 5,
                                child: const Icon(
                                  FeatherIcons.camera,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //name email and phone widget
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 1,
                      ),
                      Center(
                        child: Text(
                          _.userInfo?.fullName ??
                              AppLocalizations.of(context)!.loading,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 2.5),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 0.5,
                      ),
                      Center(
                        child: Text(
                          "${_.userInfo?.email ?? AppLocalizations.of(context)!.loading} - ${_.userInfo?.phone ?? "..."}",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.5,
                              color: const Color(0xFF94A3B8)),
                        ),
                      ),
                      imgTask != null
                          ? buildUploadTask(imgTask!)
                          : SizedBox(
                              height: SizeConfig.heightMultiplier * 5,
                            ),
                      Center(
                        child: Container(
                          width: SizeConfig.widthMultiplier * 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 1.5),
                              borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 4,
                            vertical: SizeConfig.heightMultiplier * 2.5,
                          ),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.alias,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF475569),
                                    fontSize: SizeConfig.textMultiplier * 2.1),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  if (_.userInfo?.alias != "Optional") {
                                    aliasCont.text = _.userInfo?.alias??'';
                                  }
                                  Get.dialog(AddNameDialog(
                                    hintText: "alias",
                                    controller: aliasCont,
                                    addButtonText:_.userInfo?.alias != "Optional"? "Edit":"Add",
                                    onAdd: () async {
                                      await FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(Get.find<AuthController>()
                                              .userss!
                                              .uid)
                                          .update({"Alias": aliasCont.text})
                                          .then((val) => ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .alias_added //Alias successfully added!"
                                                      ))))
                                          .then((value) => Get.back());
                                    },
                                  ));
                                },
                                child: Text(
                                  _.userInfo?.alias == "Optional"
                                      ? "Optional"
                                      : "${_.userInfo?.alias}  (edit)",
                                  style: TextStyle(
                                      fontSize: SizeConfig.textMultiplier * 1.6,
                                      color: const Color(0xFF94A3B8)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      Center(
                        child: Container(
                          width: SizeConfig.widthMultiplier * 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 1.5),
                              borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier * 4,
                              right: SizeConfig.widthMultiplier * 4,
                              bottom: SizeConfig.heightMultiplier * 0.5,
                              top: SizeConfig.heightMultiplier * 0.8),
                          child: Column(
                            children: [
                              //add name only
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 6,
                                width: SizeConfig.widthMultiplier * 100,
                                child: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF475569),
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.1),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        _.userInfo?.fullName == "N/A"
                                            ? Get.dialog(AddNameDialog(
                                                hintText: "name",
                                                controller: nameCont,
                                                onAdd: () async {
                                                  await FirebaseFirestore.instance
                                                      .collection("Users")
                                                      .doc(Get.find<
                                                              AuthController>()
                                                          .userss!
                                                          .uid)
                                                      .update({
                                                    "Fullname": nameCont.text
                                                  }).then((val)=>ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .name_added //"Name successfully added!"
                                                            )))).then((value) => Get.back());
                                                },
                                              ))
                                            : (){};
                                      },
                                      child: Text(
                                        _.userInfo?.fullName == "N/A"
                                            ? "Add Name"
                                            : _.userInfo?.fullName ??
                                                AppLocalizations.of(context)!
                                                    .loading,
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.textMultiplier * 1.6,
                                            color: const Color(0xFF94A3B8)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: SizeConfig.heightMultiplier * 0.7,
                                thickness: 1,
                                color: const Color(0xFFE2E8F0),
                              ),
                              EditProfileOptionsWidget(
                                  title: AppLocalizations.of(context)!.email,
                                  subtitle: _.userInfo?.email ??
                                      AppLocalizations.of(context)!.loading),
                              EditProfileOptionsWidget(
                                isDivider: false,
                                  title:
                                      AppLocalizations.of(context)!.phone_number,
                                  subtitle: _.userInfo?.phone ?? ""),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
    
                      ///switcher options
                      Center(
                        child: Container(
                          width: SizeConfig.widthMultiplier * 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 1.5),
                              borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier * 4,
                              right: SizeConfig.widthMultiplier * 4,
                              bottom: SizeConfig.heightMultiplier * 0.5,
                              top: SizeConfig.heightMultiplier * 0.8),
                          child: Column(
                            children: [
                              //show my number
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 6,
                                width: SizeConfig.widthMultiplier * 100,
                                child: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .show_my_number,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF475569),
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.1),
                                    ),
                                    const Spacer(),
                                    Transform.scale(
                                      scale: 0.75,
                                      child: CupertinoSwitch(
                                          value: showMynumber!,
                                          onChanged: (value) {
                                            FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(Get.find<AuthController>()
                                                    .userss!
                                                    .uid)
                                                .update({"ShowNumber": value});
                                            setState(() {
                                              showMynumber = value;
                                            });
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: SizeConfig.heightMultiplier * 0.7,
                                thickness: 1,
                                color: const Color(0xFFE2E8F0),
                              ),
                              //show only my aliaz
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 6,
                                width: SizeConfig.widthMultiplier * 100,
                                child: Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .show_only_my_alias,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF475569),
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.1),
                                    ),
                                    const Spacer(),
                                    Transform.scale(
                                      scale: 0.75,
                                      child: CupertinoSwitch(
                                          value: showOnlyAlias!,
                                          onChanged: (value) {
                                            FirebaseFirestore.instance
                                                .collection("Users")
                                                .doc(Get.find<AuthController>()
                                                    .userss!
                                                    .uid)
                                                .update({"ShowAlias": value});
                                            setState(() {
                                              showOnlyAlias = value;
                                            });
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
