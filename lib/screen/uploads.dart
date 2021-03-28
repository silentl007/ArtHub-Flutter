import 'package:ArtHub/common/model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_client/cloudinary_client.dart';

class Uploads extends StatefulWidget {
  @override
  _UploadsState createState() => _UploadsState();
}

class _UploadsState extends State<Uploads> {
  Widgets classWidget = Widgets();
  UploadWorks uploadworksClass = UploadWorks();
  final client = CloudinaryClient(
      '915364875791742', 'xXs8EIDnGzWGCFVZpr4buRyDOQk', 'mediacontrol');
  final picker = ImagePicker();
  final _key = GlobalKey<FormState>();
  List<ArtType> arttypes = [ArtType('Painting', 1), ArtType('Sculptor', 2)];
  int defaultarttype = 0;
  String arttypechoice;
  int avataruploadcontroller = 0;
  Color _radiocolor = Colors.black;
  Color _avatarcolor = Colors.black;
  Color _multicolor = Colors.black;
  List<String> worksimages = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double fontSize15 = size.height * 0.01870;
    double padding40 = size.height * 0.05;
    final node = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: classWidget.apptitleBar(context, 'Uploads'),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/appimages/welcomeback.png'),
                    fit: BoxFit.cover),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _key,
                child: Container(
                  padding: EdgeInsets.only(left: padding40, right: padding40),
                  child: Column(
                    children: [
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          labelText: 'Name of Artwork',
                          icon: Icon(Icons.art_track),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                        onSaved: (value) {
                          uploadworksClass.productName = value;
                        },
                      ),
                      TextFormField(
                        maxLength: 160,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          icon: Icon(Icons.book),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          } else if (value.length > 260) {
                            return 'The description is too long';
                          }
                        },
                        onSaved: (value) {
                          uploadworksClass.description = value;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Artwork type',
                            style: TextStyle(
                                fontSize: fontSize15, color: _radiocolor),
                          )),
                      Column(
                        children: arttypes
                            .map((data) => RadioListTile(
                                  title: Text('${data.artype}'),
                                  activeColor: AppColors.purple,
                                  value: data.index,
                                  groupValue: defaultarttype,
                                  onChanged: (value) {
                                    setState(() {
                                      defaultarttype = data.index;
                                      uploadworksClass.type = data.artype;
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Upload avatar of artwork',
                            style: TextStyle(
                                fontSize: fontSize15, color: _avatarcolor),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            onPressed: () => _avatarFuture(),
                            color: AppColors.purple,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(150))),
                            child: Row(
                              children: [
                                Icon(Icons.upload_file, color: Colors.white),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Upload',
                                  style: TextStyle(
                                      fontSize: fontSize15,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: fontSize15,
                          ),
                          RaisedButton(
                            color: AppColors.purple,
                            onPressed: () => removeavatar(),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(150))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                      fontSize: fontSize15,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Upload at least a picture of the artwork (${uploadworksClass.images.length}/4)',
                            style: TextStyle(
                                fontSize: fontSize15, color: _multicolor),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          RaisedButton(
                            color: AppColors.purple,
                            onPressed: () => _multiFuture(),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(150))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Upload',
                                  style: TextStyle(
                                      fontSize: fontSize15,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: fontSize15,
                          ),
                          RaisedButton(
                            color: AppColors.purple,
                            onPressed: () => removeimage(),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(150))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'Remove Previous',
                                  style: TextStyle(
                                      fontSize: fontSize15,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        decoration: InputDecoration(
                          labelText: 'Cost (₦)',
                          icon: Icon(Icons.money),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          } else if (value.contains(',')) {
                            return 'Please remove the ,';
                          }
                          else if (value.contains('.')) {
                            return 'Please remove the .';
                          }
                        },
                        onSaved: (value) {
                          uploadworksClass.cost = num.tryParse(value);
                        },
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Weight (KG)',
                            icon: Icon(Icons.pan_tool_sharp)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                        onSaved: (value) {
                          uploadworksClass.weight = double.tryParse(value);
                        },
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Height (Inchs)',
                          icon: Icon(Icons.height),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                        onSaved: (value) {
                          uploadworksClass.height = double.tryParse(value);
                        },
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Width (Inchs)',
                          icon: Icon(Icons.linear_scale),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                        onSaved: (value) {
                          uploadworksClass.width = double.tryParse(value);
                        },
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                            labelText: 'Materials used (separate with , )',
                            icon: Icon(Icons.carpenter_rounded)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is empty';
                          }
                        },
                        onSaved: (value) {
                          uploadworksClass.materials = value;
                        },
                      ),
                      RaisedButton(
                        color: AppColors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Text(
                          'Upload',
                          style: TextStyle(
                              fontSize: fontSize15, color: Colors.white),
                        ),
                        onPressed: () {
                          final keyForm = _key.currentState;
                          if (keyForm.validate()) {
                            if (uploadworksClass.avatar == '') {
                              setState(() {
                                _avatarcolor = Colors.red;
                              });
                            } else if (uploadworksClass.images.isEmpty) {
                              setState(() {
                                _multicolor = Colors.red;
                              });
                            } else if (defaultarttype == 0) {
                              setState(() {
                                _radiocolor = Colors.red;
                              });
                            } else {
                              keyForm.save();
                              _uploadProcess();
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _avatarimagePicker() async {
    if (uploadworksClass.avatar != '') {
      return null;
    } else {
      var image = await picker.getImage(source: ImageSource.gallery);
      try {
        var response =
            await client.uploadImage(image.path, folder: 'arthub_folder');
        return response.secure_url;
      } catch (exception) {
        print(exception);
      }
    }
  }

  _avatarFuture() {
    return showDialog(
        context: context,
        child: FutureBuilder(
          future: _avatarimagePicker(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (uploadworksClass.avatar != '') {
              return AlertDialog(
                content: Text('Avatar already uploaded'),
              );
            } else if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                color: Colors.transparent,
                child: AlertDialog(
                  content: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(AppColors.purple),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              uploadworksClass.avatar = snapshot.data;
              changeAvatarColor();
              return AlertDialog(
                content: Text('Avatar upload complete'),
              );
            } else
              return AlertDialog(
                content: Text(
                    'Unable to upload connect, please check your connetion'),
              );
          },
        ));
  }

  changeAvatarColor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _avatarcolor = Colors.green;
      });
    });
  }

  removeavatar() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        uploadworksClass.avatar = '';
        _avatarcolor = Colors.black;
      });
    });
  }

  _multiimagePicker() async {
    if (uploadworksClass.images.length == 4) {
      return null;
    } else {
      var image = await picker.getImage(source: ImageSource.gallery);
      try {
        var response = await client.uploadImage(
          image.path,
        );
        return response.secure_url;
      } catch (exception) {
        print(exception);
      }
    }
  }

  _multiFuture() {
    return showDialog(
        context: context,
        child: FutureBuilder(
          future: _multiimagePicker(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (uploadworksClass.images.length == 4) {
              return AlertDialog(
                content: Text('Maximum number of images uploaded'),
              );
            } else if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                color: Colors.transparent,
                child: AlertDialog(
                  content: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(AppColors.purple),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              uploadworksClass.images.add(snapshot.data);
              uploadsCounter();
              return AlertDialog(
                content: Text('Image upload complete'),
              );
            } else
              return AlertDialog(
                content: Text(
                    'Unable to upload connect, please check your connetion'),
              );
          },
        ));
  }

  _uploadProcess() {
    return showDialog(
        context: context,
        child: FutureBuilder(
            future: uploadworksClass.upload(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return Container(
                  color: Colors.transparent,
                  child: AlertDialog(
                    content: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(AppColors.purple),
                    ),
                  ),
                );
              }
              return Container(
                  child: snapshot.data == 200
                      ? _uploadSuccess()
                      : _uploadFailed());
            }));
  }

  _uploadSuccess() {
    clearData();
    return AlertDialog(
      content: Text('Upload Successful!'),
    );
  }

  _uploadFailed() {
    return AlertDialog(
      content: Text('Upload Unsuccessful, please check your connection'),
    );
  }

  clearData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyForm = _key.currentState;
      keyForm.reset();
      setState(() {
        defaultarttype = 0;
        uploadworksClass.images = [];
        uploadworksClass.avatar = '';
        uploadworksClass.images.length;
      });
    });
  }

  uploadsCounter() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        uploadworksClass.images.length;
        _multicolor = Colors.green;
      });
    });
  }

  removeimage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (uploadworksClass.images.isNotEmpty) {
        if (uploadworksClass.images.length == 1) {
          uploadworksClass.images.removeAt(uploadworksClass.images.length - 1);
          setState(() {
            uploadworksClass.images.length;
            _multicolor = Colors.black;
          });
        } else {
          uploadworksClass.images.removeAt(uploadworksClass.images.length - 1);
          setState(() {
            uploadworksClass.images.length;
            _multicolor = Colors.green;
          });
        }
      } else {
        return showDialog(
            context: context,
            child: AlertDialog(
              content: Text('There is no upload to remove!'),
            ));
      }
    });
  }
}

class ArtType {
  String artype;
  int index;
  ArtType(this.artype, this.index);
}
