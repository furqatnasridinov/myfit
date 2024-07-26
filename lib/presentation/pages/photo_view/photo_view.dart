import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

@RoutePage()
class PhotoViewScreen extends StatelessWidget {
  final List<String> photos;
  final int index;
  const PhotoViewScreen({super.key, required this.photos, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            context.router.pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PhotoViewGallery.builder(
        itemCount: photos.length,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: //Image.asset(dummyPhotos[index]),
              Hero(
                tag: index,
                child: CachedNetworkImage(
                    imageUrl: "${AppConstants.baseUrl}image/${photos[index]}",
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: AppColors.blueColor))),
              ),
          minScale: PhotoViewComputedScale.covered,
        ),
        pageController: PageController(initialPage: index),
      ),
    );
  }
}
