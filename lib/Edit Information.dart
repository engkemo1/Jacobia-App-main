import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jacobia/view_model/database/local/cache_helper.dart';
import 'package:path/path.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({Key? key}) : super(key: key);

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  late TextEditingController nameController;
  late TextEditingController passController;
  late TextEditingController numController;
  late TextEditingController emailController;
  late TextEditingController nickController;
  late TextEditingController addressController;
  late TextEditingController nationalityController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  late Stream<DocumentSnapshot> _userStream;

  var imageFile;
  String? image;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_user?.uid) // Assuming `uid` is used as the document ID
        .snapshots();
    // Initialize TextEditingControllers
    nameController = TextEditingController();
    passController = TextEditingController();
    numController = TextEditingController();
    emailController = TextEditingController();
    nickController = TextEditingController();
    addressController = TextEditingController();
    nationalityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'البيانات',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return Center(child: Text('No data found'));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;

            // Set text controllers with Firestore data
            nameController.text = userData['name'] ?? '';
            passController.text = userData['password'] ?? '';
            numController.text = userData['phone'] ?? '';
            emailController.text = userData['email'] ?? '';
            nickController.text = userData['nick'] ?? '';
            addressController.text = userData['address'] ?? '';
            nationalityController.text = userData['nationality'] ?? '';

            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Account creation date
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 50,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userData['createdAt'] ?? 'N/A', // Example createdAt field
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(":تاريخ انشاء الحساب", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // User image or default avatar
                        imageFile != null
                            ? CircleAvatar(
                          radius: 100,
                          backgroundImage: FileImage(imageFile!),
                        )
                            : (userData['imageUrl'] == null
                            ? CircleAvatar(
                          backgroundColor: Colors.black12,
                          radius: 80,
                          child: Image.asset('assets/icons/logo.png'),
                        )
                            : CircleAvatar(
                          backgroundColor: Colors.black12,
                          radius: 80,
                          backgroundImage: NetworkImage(userData['imageUrl']),
                        )),
                        InkWell(
                          onTap: () async {
                            // Image picker logic here
                            final ImagePicker _picker = ImagePicker();
                            final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                imageFile = File(pickedFile.path);
                              });
                            }
                          },
                          child: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    // Fields for user data
                    _buildTextField('الاسم', nameController),
                    Divider(color: Colors.grey, thickness: 1),
                    _buildTextField('الكنية', nickController),
                    Divider(color: Colors.grey, thickness: 1),
                    _buildTextField('رقم الواتساب', numController),
                    Divider(color: Colors.grey, thickness: 1),
                    _buildTextField('مكان الاقامة', addressController),
                    Divider(color: Colors.grey, thickness: 1),
                    _buildTextField('الجنسية', nationalityController),
                    Divider(color: Colors.grey, thickness: 1),
                    _buildTextField('البريد الالكتروني', emailController),
                    Divider(color: Colors.grey, thickness: 1),
                    _buildTextField('الرقم السري', passController),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Set the background color
                        ),
                        onPressed: () async {
                          String picUrl = '';

                          if (imageFile != null) {
                            String _fileName = basename(imageFile!.path);
                            Reference _firebaseStorageRef = FirebaseStorage.instance
                                .ref()
                                .child('profilePics/$_fileName');

                            UploadTask _uploadTask = _firebaseStorageRef.putFile(imageFile!);
                            picUrl = await (await _uploadTask).ref.getDownloadURL();
                          }

                          // Update Firestore with the new data
                          await FirebaseFirestore.instance.collection('users').doc(_user?.uid).update({
                            'imageUrl': picUrl.isNotEmpty ? picUrl : userData['imageUrl'],
                            'name': nameController.text,
                            'phone': numController.text,
                            'nick': nickController.text,
                            'nationality': nationalityController.text,
                            'address': addressController.text,
                          }).then((value) {
                            Get.snackbar('', 'Successfully updated');
                            CacheHelper.put(key: 'imageUrl', value: picUrl.isNotEmpty ? picUrl : userData['imageUrl']);
                            CacheHelper.put(key: 'name', value: nameController.text.isNotEmpty ? nameController.text : CacheHelper.get(key: 'name'));
                            CacheHelper.put(key: 'phone', value: numController.text.isNotEmpty ? numController.text : CacheHelper.get(key: 'phone'));
                            CacheHelper.put(key: 'nick', value: nickController.text.isNotEmpty ? nickController.text : CacheHelper.get(key: 'nick'));
                            CacheHelper.put(key: 'nationality', value: nationalityController.text.isNotEmpty ? nationalityController.text : CacheHelper.get(key: 'nationality'));
                            CacheHelper.put(key: 'address', value: addressController.text.isNotEmpty ? addressController.text : CacheHelper.get(key: 'address'));
                            CacheHelper.put(key: 'email', value: emailController.text.isNotEmpty ? emailController.text : CacheHelper.get(key: 'email'));
                            CacheHelper.put(key: 'password', value: passController.text.isNotEmpty ? passController.text : CacheHelper.get(key: 'password'));
                          });
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      height: 80,
      child: ListTile(
        trailing: Text(
          ': $label',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            fontSize: 18,
            color: const Color(0xff00334a),
            height: 1.58,
          ),
        ),
        subtitle: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
