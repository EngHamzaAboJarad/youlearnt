import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatefulWidget {
  final List<String> galleryItems;

  const GalleryScreen(this.galleryItems);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late bool _appBarVisible;
  late Color backgroundColor;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    backgroundColor = const Color(0xffFAFAFA);
    _appBarVisible = true;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _toggleAppBarVisibility() {
    _appBarVisible = !_appBarVisible;
    _appBarVisible ? _controller!.forward() : _controller!.reverse();
  }

  Widget get _imageWidget {
    return Center(
      child: GestureDetector(
        onTap: () => setState(() {
          _toggleAppBarVisibility();
        }),
        child: Container(
            child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            currentIndex = index;
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.galleryItems[index]),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryItems[index]),
            );
          },
          itemCount: widget.galleryItems.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value:
                    event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> offsetAnimation = new Tween<Offset>(
      begin: Offset(0.0, -70),
      end: Offset(0.0, 0.0),
    ).animate(_controller!);

    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _imageWidget,
          SlideTransition(
            position: offsetAnimation,
            child: Container(
              height: 60,
              child: AppBar(
                backgroundColor: Colors.white12,
                actions: <Widget>[
                  IconButton(
                      padding: EdgeInsetsDirectional.only(end: 10),
                      tooltip: 'download',
                      onPressed: () {
                        /*
                        ArchivesGetxController.to.downloadImage(widget.galleryItems[currentIndex],context);
                     */
                      },
                      icon: Icon(Icons.arrow_downward))
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

/*loadImage(context, String urlImage) async {
    var imageId = await ImageDownloader.downloadImage(urlImage);
    var path = await ImageDownloader.findPath(imageId).then((value) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('success download image'),
      ));
    });
    //File image = File(path);
  }*/
}
