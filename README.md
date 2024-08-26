This package allows you to parse audio and video steams for provided YouTube video with best possible quality found. Retrieved streams do not have buffering issues and can be played in any player, like [media_kit](https://pub.dev/packages/media_kit). Library was created from the source code of a popular flutter gaming modification app named [ExLoader](https://en.exloader.net) that is also written on Dart & Flutter. Well tested on thounsands of different devices and from many  countries for several years with help of previously mentioned ExLoader client.

Example of usage:
```dart
  final (YoutubeVideoData? video, String? audio) = await getYoutubeVideoStreams(
    'https://www.youtube.com/watch?v=pW14qPkhSoc',
  );
  print(
    [
      'Height: ${video?.height}',
      'Quality: ${video?.quality}',
      'Video url: ${video?.url}',
      "Audio: $audio",
    ].join('\n'),
  );
```

Output:
```
flutter: Height: 1080.0
Quality: _Quality.high_1080p
Video url: https://rr1---sn-whqp-f5fe.googlevideo.com/videoplayback?expire=1724715879&ei=B7_MZqKxF7K26dsPsvbtsAg&ip=109.233.92.66&id=o-ALJGx3lNZoDyGOzW4YnGQy8gg2Z9xC9CUjAuBfN5hf1V&itag=137&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&mh=Dv&mm=31%2C29&mn=sn-whqp-f5fe%2Csn-f5f7lne6&ms=au%2Crdu&mv=m&mvi=1&pl=21&initcwndbps=2095000&vprv=1&svpuc=1&mime=video%2Fmp4&rqh=1&gir=yes&clen=1600725220&dur=3338.633&lmt=1714567383515416&mt=1724693829&fvip=5&keepalive=yes&c=ANDROID_TESTSUITE&txp=5535434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cvprv%2Csvpuc%2Cmime%2Crqh%2Cgir%2Cclen%2Cdur%2Clmt&sig=AJfQdSswRAIgF0jVTzz5PqLHTJVa19bxzkifLEGctRn1rSpMDHc0Yd4CIF70bqZEvCx_Jbn76Dx8SCQNzveTwkPKwSOG0TfoV9Dj&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AGtxev0wRQIgdIotzhdBGdbsY1cQVYG8_XAGuiY4baAbF1ykbLE2tgsCIQC-Qip7rRqfJM_cgnQ3sJJ5JtuWq_uJFy-Uo43dMhQAmw%3D%3D
Audio: https://rr1---sn-whqp-f5fe.googlevideo.com/videoplayback?expire=1724715879&ei=B7_MZqKxF7K26dsPsvbtsAg&ip=109.233.92.66&id=o-ALJGx3lNZoDyGOzW4YnGQy8gg2Z9xC9CUjAuBfN5hf1V&itag=251&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&mh=Dv&mm=31%2C29&mn=sn-whqp-f5fe%2Csn-f5f7lne6&ms=au%2Crdu&mv=m&mvi=1&pl=21&initcwndbps=2095000&vprv=1&svpuc=1&mime=audio%2Fwebm&rqh=1&gir=yes&clen=59089084&dur=3338.661&lmt=1714549744063225&mt=1724693829&fvip=5&keepalive=yes&c=ANDROID_TESTSUITE&txp=5532434&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cvprv%2Csvpuc%2Cmime%2Crqh%2Cgir%2Cclen%2Cdur%2Clmt&sig=AJfQdSswRQIhAK3u2H8Zv4SOg5RoSva3PlEsDYqygdFfrSW68VTindelAiBow9g3q_pS61w2eYWGnuue3fWQINfsuOfY6dt2S74WgQ%3D%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AGtxev0wRQIgdIotzhdBGdbsY1cQVYG8_XAGuiY4baAbF1ykbLE2tgsCIQC-Qip7rRqfJM_cgnQ3sJJ5JtuWq_uJFy-Uo43dMhQAmw%3D%3D
```