import 'package:flutter/material.dart';
import 'package:sindicatos/Components/FullScreenUrl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sindicatos/Model/ImageNews.dart';
import '../../Components/AppDrawer.dart';
import '../../Components/CustomAppBar.dart';
import '../../Components/PageHeader.dart';
import '../../Components/LoadingComponent.dart';
import '../../Model/CustomMenuItem.dart';
import '../../Model/History.dart';
import '../../Model/User.dart';
import '../../Components/FullScreenImage.dart';
import '../../Network/HistoryCalls.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final Future<History> fetchHistoryFuture = fetchHistory();
  History history;

  @override
  void initState() {
    super.initState();

    fetchHistoryFuture.then((fetchedHistory) {
      setState(() {
        history = fetchedHistory;
      });
    });
  }

  _getListOfImages(List<ImageNews> imagesUrls) {
    List<Widget> imageUrlWidgets = [];
    if (imagesUrls.length > 0) {
      for (var j = 0; j < imagesUrls.length; j++) {
        imageUrlWidgets.add(InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext contet) => FullScreenImage(
                      imageUrl: imagesUrls[j].image,
                    )));
          },
          child: Image(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
              image: (imagesUrls[j] == null)
                  ? AssetImage('assets/images/placeholderImage.jpg')
                  : NetworkImage(imagesUrls[j].video
                      ? imagesUrls[j].prevVideo
                      : imagesUrls[j].image),
              fit: BoxFit.cover),
        ));
      }
    } else {
      imageUrlWidgets.add(Image(
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          image: AssetImage('assets/images/no-image.jpg'),
          fit: BoxFit.cover));
    }

    return imageUrlWidgets;
  }

  _getCarousel(List<ImageNews> imagesUrls) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1.0,
        enlargeCenterPage: false,
      ),
      items: _getListOfImages(imagesUrls),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0, 75),
        child: CustomAppBar(),
      ),
      backgroundColor: Colors.grey[300],
      drawer: new AppDrawer(
        user: widget.user,
      ),
      body: new Container(
        decoration: new BoxDecoration(color: Colors.white),
        child: new Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                    color: Color(0xFF5EA0D6),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0),
                    )),
                child: Column(
                  children: <Widget>[
                    PageHeader(
                      menuItem: CustomMenuItem.get(
                          CustomMenuItemType.history, widget.user),
                    ),
                    SizedBox(height: 20.0)
                  ],
                ),
              ),
              Expanded(
                child: history == null
                    ? LoadingComponent()
                    : ListView(
                      children: <Widget>[
                        ClipRRect(
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: <Widget>[
                                  _getCarousel(history.images),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(history.title,
                                        maxLines: 4,
                                        style: TextStyle(
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0XFF494949)),
                                        textAlign: TextAlign.center),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Html(
                                        data: history.content,
                                        onLinkTap: (src,
                                            RenderContext contextc,
                                            Map<String, String> attributes,
                                            dom.Element element) async {
                                          //open URL in webview, or launch URL in browser, or any other logic here
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          contet) =>
                                                      FullScreenUrl(
                                                          imageUrl: src)));
                                        }),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        )
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
