import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:secondhand/controllers/auth_controller.dart';
import 'package:secondhand/views/widgets/custom_auth_snackbar.dart';

import 'colors.dart';

FirebaseAuth kfirebaseAuth = FirebaseAuth.instance;
FirebaseFirestore kfirestore = FirebaseFirestore.instance;
AuthController authCont = Get.find<AuthController>();
