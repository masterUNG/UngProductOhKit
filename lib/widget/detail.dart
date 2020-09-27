import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final String barCode;
  final List<String> images;
  Detail({Key key, this.barCode, this.images}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String barCode;
  List<String> images;
  Widget showImage;
  int indexShow = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barCode = widget.barCode;
    images = widget.images;
    showImage = Image.network(
      images[0],
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(barCode),
      ),
      body: Column(
        children: [
          buildBigImage(),
          buildListView(),
        ],
      ),
    );
  }

  Widget buildListView() => Container(
        height: 110,
        child: Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) => Container(
              width: 100,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    indexShow = index;
                    setState(() {
                      showImage = Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      );
                    });
                  },
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Row buildBigImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          height: 200,
          child: GestureDetector(
            child: showImage,
            onTap: () {
              print('You click indexShow ==>> $indexShow');
              setState(() {
                images.removeAt(indexShow);
                indexShow = 0;
                showImage = Image.network(images[0]);
                print('images current ==>> ${images.length}');
              });
            },
          ),
        ),
      ],
    );
  }
}
