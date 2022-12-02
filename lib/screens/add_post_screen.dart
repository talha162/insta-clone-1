import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone162/providers/user_provider.dart';
import 'package:instaclone162/resources/firestore_methods.dart';
import 'package:instaclone162/extras/extra_func.dart';
import 'package:instaclone162/widgets/text_field.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  Uint8List? _file;
  TextEditingController captionController = TextEditingController();
  selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Cancel'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Scaffold(
            body: Center(
              child: IconButton(
                  onPressed: () => selectImage(context),
                  icon: Icon(Icons.upload)),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () =>
                        addPost(user!.uid, user.username, user.photoUrl),
                    child: Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
              backgroundColor: Colors.blue,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    _file = null;
                  });
                },
              ),
            ),
            body: isLoading
                ? LinearProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          backgroundImage: NetworkImage(user!.photoUrl)),
                      SizedBox(
                          child: TextField(
                              controller: captionController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: 'Write caption here',
                                  border: InputBorder.none)),
                          width: MediaQuery.of(context).size.width * 0.55),
                      SizedBox(
                          height: 45,
                          width: 45,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: MemoryImage(_file!),
                                      fit: BoxFit.fill,
                                      alignment: FractionalOffset.topCenter)),
                            ),
                          ))
                    ],
                  ));
  }

  void addPost(String uid, String username, String profilePhotoUrl) async {
    String result;
    setState(() {
      isLoading = true;
    });
    try {
      result = await FireStoreMethods().uploadPost(
          captionController.text, _file!, uid, username, profilePhotoUrl);
    } catch (err) {
      result = err.toString();
    }
    setState(() {
      isLoading = false;
    });
    if (result == "posted") {
      setState(() {
        _file = null;
      });
    }
    showSnackBar(result, context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
  }
}
