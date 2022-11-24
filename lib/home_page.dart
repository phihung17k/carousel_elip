import 'dart:math';

import 'package:carousel/card_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? tweenAnimation;
  int durationSecond = 20;

  AnimationController? resetController;
  Animation<Matrix4>? resetTweenAnimation;

  TextEditingController? textController;
  TransformationController? transformationController;

  double a = 0;
  double b = 0;

  int numberOfCard = 5;

  List<CardModel> cards = [];
  List<String> imageExtensions = ["jdg", "jpeg", "gif", "png", "webp", "svg"];
  List<String> images = [
    "wlop-1se.jpg",
    "wlop-2se.jpg",
    "wlop-3se.jpg",
    "wlop-5se.jpg",
    "wlop-11s.jpg",
    "wlop-16se.jpg",
    "wlop-49sz.jpg",
    "wlop-50se.jpg",
    "wlop-51se.jpg",
    "wlop-65se.jpg",
    "wlop-66se.jpg",
  ];

  List<Uint8List> imageBytes = [];
  List<Widget> imageWidgets = [];
  List<Widget> cardWidgets = [];

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    transformationController = TransformationController();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: durationSecond));
    tweenAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(controller!);
    controller!.repeat();
    // controller!.forward();

    resetController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    cards.addAll(List.generate(numberOfCard, (index) => CardModel()));
  }

  Future getImages() async {
    // Directory images = Directory.fromUri(Uri.directory("/images"));
    // images.listSync().where((fileSystemEntity) {
    //   String path = fileSystemEntity.path.split(".").last;
    //   return imageExtensions.contains(path);
    // }).map((fileSystemEntity) {
    //   var k = fileSystemEntity.path;
    //   print(k);
    // });
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      List<XFile> files = await picker.pickMultiImage();
      if (files.isNotEmpty && files.length < 17) {
        imageBytes.clear();
        for (var file in files) {
          Uint8List bytes = await file.readAsBytes();
          imageBytes.add(bytes);
        }
      }
      getImageWidgetList();
    }
  }

  void getImageWidgetList() {
    imageWidgets = imageBytes.map<Widget>((byte) {
      return Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 10),
        child: Image.memory(
          byte,
          fit: BoxFit.contain,
        ),
      );
    }).toList();
  }

  void initCards(int totalCard) {
    numberOfCard = totalCard;
    cards.clear();
    cards.addAll(List.generate(numberOfCard, (index) => CardModel()));
  }

  /// angle: radian
  /// in circle, radius  r
  /// For a point M(0, r) appears on the circle
  /// We have M(x, y) ends up at x = r*cos(angle) and y = r*sin(angle)
  /// Total: x^2 + y^2 = r^2
  /// Similar elip: x' = x and y' = y * b/a
  /// with a is big radius (=r), and b is small radius: b < a and a = r
  /// M(x,y) <=> M(cos(angle), sin(angle))
  /// link: https://www.omnicalculator.com/math/unit-circle#what-is-a-unit-circle

  /// 4 <=> pi / 2
  /// 1 pi = 180°
  /// n cards <=> angle = 360° / n (degree)
  /// => n <=> angle * pi / 180° <=> (360° / n) * pi / 180° <=> 2 pi / n
  void setupCards(double angle) {
    if (cards.isNotEmpty) {
      for (var i = 0; i < cards.length; i++) {
        double radian = i * 2 * pi / cards.length;
        cards[i].x = a * cos(angle + radian);
        cards[i].y = b * sin(angle + radian);
        cards[i].z = -cards[i].y!;
        cards[i].rotateYAngle = angle + pi / 2 + radian;
        if (imageBytes.isEmpty) {
          cards[i].imagePath = "images/${images[i]}";
        } else {
          if (i < cards.length && i < imageBytes.length) {
            cards[i].imageByte = imageBytes[i];
          }
        }

        //2
        // cards[i].x = a * cos(angle + i * 2 * pi / 2);
        // cards[i].y = b * sin(angle + i * 2 * pi / 2);
        // cards[i].z = -cards[i].y!;
        // cards[i].rotateYAngle = angle + pi / 2 + i * 2 * pi / 2;

        //3
        // cards[i].x = a * cos(angle + i * 2 * pi / 3);
        // cards[i].y = b * sin(angle + i * 2 * pi / 3);
        // cards[i].z = -cards[i].y!;
        // cards[i].rotateYAngle = angle + pi / 2 + i * 2 * pi / 3;

        //4
        // cards[i].x = a * cos(angle + i * 2 * pi / 4);
        // cards[i].y = b * sin(angle + i * 2 * pi / 4);
        // cards[i].z = -cards[i].y!;
        // cards[i].rotateYAngle = angle + pi / 2 + i * 2 * pi / 4;

        //5
        // cards[i].x = a * cos(angle + i * 2 * pi / 5);
        // cards[i].y = b * sin(angle + i * 2 * pi / 5);
        // cards[i].z = -cards[i].y!;
        // cards[i].rotateYAngle = angle + pi / 2 + i * 2 * pi / 5;

        //6
        // cards[i].x = a * cos(angle + i * 2 * pi / 6);
        // cards[i].y = b * sin(angle + i * 2 * pi / 6);
        // cards[i].z = -cards[i].y!;
        // cards[i].rotateYAngle = angle + pi / 2 + i * 2 * pi / 6;
        cards[i].color = Colors.primaries[i];
      }
      cards.sort((cardA, cardB) => cardB.z!.compareTo(cardA.z!));
    }
  }

  void getCardWidgets() {
    if (cards.isNotEmpty) {
      cardWidgets = cards.map<Widget>((card) {
        Image image;
        if (imageBytes.isEmpty) {
          image = Image.asset(card.imagePath!, fit: BoxFit.contain);
        } else {
          image = Image.memory(
            card.imageByte!,
            fit: BoxFit.contain,
          );
        }

        return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(card.x, card.y!, card.z!)
              ..rotateY(card.rotateYAngle!),
            alignment: Alignment.center,
            origin: const Offset(0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  // color: card.color,
                  width: 300,
                  height: 200,
                  child: image,
                ),
                const SizedBox(
                  height: 10,
                ),
                Transform.rotate(
                  angle: pi,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 200,
                        child: image,
                      ),
                      Container(
                        foregroundDecoration: const BoxDecoration(
                          // color: Colors.transparent,
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.black,
                              Colors.transparent
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        width: 300,
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ],
            ));
      }).toList();
    } else {
      cardWidgets = [];
    }
  }

  void performInputNumberOfItemFunction(String value) {
    int? result = int.tryParse(value);
    if (result != null && result > 0) {
      if (imageBytes.isNotEmpty) {
        if (result <= imageBytes.length) {
          setState(() {
            initCards(result);
          });
        }
      } else {
        if (cards.isNotEmpty && result <= images.length) {
          setState(() {
            initCards(result);
          });
        }
      }
    }
  }

  void resetScreen(double width, double height) {
    resetTweenAnimation = Matrix4Tween(
            begin: transformationController!.value,
            end: Matrix4.identity()..translate(width / 2, height / 4))
        .animate(resetController!);

    resetTweenAnimation!.addListener(() {
      transformationController!.value = resetTweenAnimation!.value;
    });
    resetController!.reset();
    resetController!.forward();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    a = size.width / 3;
    b = size.height / 10;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            children: [
                              const Text("Nhập số lượng ảnh hiển thị: "),
                              SizedBox(
                                  width: 100,
                                  height: 20,
                                  child: TextField(
                                    controller: textController,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 20)),
                                    onSubmitted: (value) {
                                      performInputNumberOfItemFunction(value);
                                    },
                                  )),
                              const SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                alignment: Alignment.topLeft,
                                onPressed: () {
                                  performInputNumberOfItemFunction(
                                      textController!.text);
                                },
                                icon: const Icon(Icons.search),
                              ),
                              const Text("Thanh tốc độ: "),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 300,
                                child: Slider(
                                  onChanged: (value) {
                                    setState(() {
                                      durationSecond = value.toInt();

                                      controller!.duration =
                                          Duration(seconds: durationSecond);
                                      controller!.reset();
                                      controller!.repeat();
                                    });
                                  },
                                  value: durationSecond.toDouble(),
                                  divisions: 40,
                                  label: "$durationSecond",
                                  min: 1,
                                  max: 40,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    await getImages();
                                    initCards(imageBytes.length);
                                    setState(() {});
                                  },
                                  child: const Text("Chọn ảnh")),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Wrap(
                                  children: imageWidgets,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onDoubleTap: () => resetScreen(size.width, size.height),
                        child: InteractiveViewer.builder(
                          transformationController: transformationController,
                          scaleFactor: 1000,
                          boundaryMargin: EdgeInsets.all(size.height),
                          minScale: 0.5,
                          maxScale: 5,
                          builder: (context, viewport) {
                            return AnimatedBuilder(
                                animation: tweenAnimation!,
                                builder: (context, child) {
                                  if (imageBytes.isEmpty && cards.isEmpty) {
                                    return const SizedBox();
                                  }
                                  double angle = tweenAnimation!.value;
                                  // setCoordinate(angle);
                                  setupCards(angle);
                                  getCardWidgets();
                                  return Stack(children: cardWidgets
                                      // [
                                      //   Transform(
                                      //     transform: Matrix4.identity()
                                      //       ..setEntry(3, 2, 0.001)
                                      //       ..translate(x, y!, -y!)
                                      //       ..rotateY(angle + pi / 2),
                                      //     alignment: Alignment.center,
                                      //     origin: const Offset(0, 0),
                                      //     child: Container(
                                      //       color: Colors.blue,
                                      //       width: 150,
                                      //       height: 100,
                                      //     ),
                                      //   ),
                                      //   Transform(
                                      //     transform: Matrix4.identity()
                                      //       ..setEntry(3, 2, 0.001)
                                      //       ..translate(x2, y2!, -y2!)
                                      //       ..rotateY(angle),
                                      //     alignment: Alignment.center,
                                      //     origin: Offset(0, 0),
                                      //     child: Container(
                                      //       color: Colors.amber,
                                      //       width: 150,
                                      //       height: 100,
                                      //     ),
                                      //   ),
                                      // ],
                                      );
                                });
                          },
                        ),
                      ),
                    ),
                  ]),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    color: Colors.white70,
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Align(
                          alignment: Alignment.center,
                          child: Text("Hướng dẫn",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Text(
                            "• Nhập số lượng ảnh trong phạm vi từ 1 đến số ảnh được chọn"),
                        Text("• Số ảnh ban đầu mặc định tối đa 11 ảnh"),
                        Text("• Kéo thả màn hình để di chuyển ảnh"),
                        Text("• Phóng to, thu nhỏ ảnh bằng lăn chuột trên web"),
                        Text(
                            "• Double click để ảnh di chuyển về vị trí ban đầu"),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
