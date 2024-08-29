import 'package:decoderstest/ImageGalley/Api/imageapi.dart';
import 'package:flutter/material.dart';

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({super.key});

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery View')),
      body: FutureBuilder(
          future: APIService().getPhotos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var listofPhotos = snapshot.data?.length ?? 0;
              return listofPhotos == 0 ? const Text('No Photos Available', style: TextStyle(fontSize: 17),) : GridView.builder(
                  itemCount: listofPhotos,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    var photo_url = snapshot.data?[index].url ?? "";

                    return photo_url == '' ? const SizedBox() : Container(
                        decoration:  BoxDecoration(
                            image:  DecorationImage(
                                image:  NetworkImage(photo_url),
                                fit: BoxFit.cover)));
                  });
            } else if (snapshot.hasError) {
            return const Text('Error Retriving Data', style: TextStyle(fontSize: 17),);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
