import 'package:audio_service/audio_service.dart';

class MediaLibrary {
  List<MediaItem> _items = List();
  MediaItem defaultItem = MediaItem(
      id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      );

  MediaLibrary(List<String> urls) {
    // not best practice; a long list of urls would be too slow to process
      urls.forEach(
              (element) {_items.add(defaultItem.copyWith(id: element));}
              );
      print(_items);
    }
    // print(_items);

  List<MediaItem> get items => _items;
}