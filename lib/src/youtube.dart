import 'dart:convert';
import 'dart:io';
import 'bad_ssl.dart';

/// Basic data about the audio track.
class _YoutubeAudioData {
  final int bitrate;
  final String url;

  const _YoutubeAudioData(this.url, this.bitrate);
}

/// All possible qualities for youtube videos.
enum Quality {
  low_144p._('256x144'),
  low_240p._('426x240'),
  medium_360p._('640x360'),
  medium_480p._('854x480'),
  medium_720p._('1280x720'),
  high_1080p._('1920x1080'),
  high_1440p._('2560x1440'),
  high_2160p._('3840x2160'),
  super_2880p._('5120x2880'),
  super_3072p._('4096x3072'),
  super_4320p._('7680x4320');

  final String resolution;

  const Quality._(this.resolution);
}

/// Basic data about the video track.
class YoutubeVideoData {
  final Quality quality;
  final String url;

  final double width;
  final double height;

  const YoutubeVideoData(this.url, this.quality, this.width, this.height);
}

/// Regex pattern for youtube videos.
const String _youtubeRegexPattern =
    r'(?:https?:\/\/)?(?:m\.|www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|shorts\/|watch\?v=|watch\?.+&v=))((\w|-){11})(\?\S*)?$';

/// Returns default video data. Request is made as a beta android client.
Future<Map<String, dynamic>> _parseVideoData(String url) async {
  // Override once more in case function is executed inside of an isolate
  final HttpClient client = HttpClient();
  client.badCertificateCallback = badSSLCallback;

  final rt = await client.postUrl(
    Uri.parse('https://www.youtube.com/youtubei/v1/player?prettyPrint=false'),
  );

  // Add appropriate headers to simulate beta android client
  rt.headers.set('Content-Type', 'application/json');
  rt.headers.set('Origin', 'https://www.youtube.com');
  rt.headers.set('X-YouTube-Client-Name', 3);
  rt.headers.set('X-YouTube-Client-Version', '16.20');
  rt.headers.set(
    'User-Agent',
    'com.google.android.youtube/17.36.4 (Linux; U; Android 12; GB) gzip',
  );

  // Simulate beta android client data
  rt.add(
    utf8.encode(
      '''
    {
      "context": {
        "client": {
          'clientName': 'ANDROID',
          'clientVersion': '19.09.37',
          'androidSdkVersion': 30,
          'userAgent':
          'com.google.android.youtube/19.09.37 (Linux; U; Android 11) gzip',
          'hl': 'en',
          'timeZone': 'UTC',
          'utcOffsetMinutes': 0,
        }
	    },
      "videoId": "${RegExp(_youtubeRegexPattern).allMatches(url).map((x) => x.group(1)).toList().first}",
    }'''
          .trim(),
    ),
  );

  final String result = await (await rt.close()).transform(utf8.decoder).join();
  client.close();
  return Map.from(json.decode(result) as Map<String, dynamic>);
}

/// Parses youtube's audio and video links for provided video url. By default
/// tries to return 1440p video, if such is not found then looks for 1080p, and,
/// if there is no video with preferred quality then it returns the best one
/// available. Audio file is selected by it's bitrate.
Future<(YoutubeVideoData?, String?)> getYoutubeVideoStreams(
  String url, [
  Map<String, dynamic>? data,
]) async {
  try {
    final Map<String, dynamic> data0 = data ?? await _parseVideoData(url);

    // Create storage for video and audio urls
    final List<YoutubeVideoData> allVideoFormats = List.empty(growable: true);
    final List<_YoutubeAudioData> allAudioFormats = List.empty(growable: true);

    // Determines whether provided data is a video or an audio and add it to
    // the corresponding list
    void addToList(Map<String, dynamic> data) {
      if (data.toString().contains('width')) {
        try {
          allVideoFormats.add(
            YoutubeVideoData(
              data['url'] as String,
              Quality.values.firstWhere(
                (dt) => dt.resolution.split('x').last == '${data['height']}',
                orElse: () => Quality.values.firstWhere(
                  (qt) => qt.resolution.split('x').first == '${data['width']}',
                  orElse: () => Quality.values.firstWhere(
                    (qt) => qt.name.contains('${data['qualityLabel']}'),
                  ),
                ),
              ),
              double.tryParse(data['width'].toString()) ?? 0.0,
              double.tryParse(data['height'].toString()) ?? 0.0,
            ),
          );
        } catch (_) {
          /* Do nothing */
        }
      } else {
        allAudioFormats.add(
          _YoutubeAudioData(data['url'] as String, data['bitrate'] as int),
        );
      }
    }

    // Parse both ['formats'] and ['adaptiveFormats'] lists for video and audio
    // objects
    for (final Map<String, dynamic> map in List.from([
      ...data0['streamingData']['formats'] as List,
      ...data0['streamingData']['adaptiveFormats'] as List,
    ])) {
      addToList(map);
    }

    // Sort videos by quality from low to high and audio by its bitrate
    allVideoFormats.sort((a, b) => a.quality.index.compareTo(b.quality.index));
    allAudioFormats.sort((a, b) => a.bitrate.compareTo(b.bitrate));

    return (
      allVideoFormats.firstWhere(
        (video) => video.quality == Quality.high_1440p,
        orElse: () => allVideoFormats.firstWhere(
          (video) => video.quality == Quality.high_1080p,
          orElse: () => allVideoFormats.last,
        ),
      ),
      allAudioFormats.last.url,
    );
  } catch (_) {
    return (null, null);
  }
}
