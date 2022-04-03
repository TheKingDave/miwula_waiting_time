import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:influxdb_client/api.dart';
import 'package:miwula_waiting_time/time.dart';

void main(List<String> arguments) async {
  final env = DotEnv(includePlatformEnvironment: true)..load();
  
  final client = InfluxDBClient(
    url: env['INFLUX_URL'] ?? 'http://localhost:8086',
    token: env['INFLUX_TOKEN'],
    org: env['INFlUX_ORG'],
    bucket: env['INFLUX_BUCKET'],
  );
  final writeApi = WriteService(client);

  print('Service started');

  await getAndStoreTime(writeApi);
  final duration = Duration(seconds: int.parse(env['RESOLUTION'] ?? '60'));
  Timer.periodic(duration, (timer) => getAndStoreTime(writeApi));
}

Future<void> getAndStoreTime(WriteService client) async {
  final waitingTime = await getWaitingTime();
  if(waitingTime == null) return;
  await storeWaitingTime(client, waitingTime);
}

Future<int?> getWaitingTime() async {
  final client = HttpClient();
  try {
    HttpClientRequest request = await client
        .getUrl(Uri.parse('https://api.miniatur-wunderland.de/v1/current/'));
    HttpClientResponse response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();
    final jsonData = json.decode(stringData);

    final from = Time.parse(jsonData['openingTime']['from']);
    final to = Time.parse(jsonData['openingTime']['to']);
    final current = Time.parse(jsonData['waitingTime']);
    
    final waitingTime = int.parse(jsonData['waitingMin']);
    
    if (current.isInBetween(from, to)) {
      return waitingTime;
    }
  } finally {
    client.close();
  }
  return null;
}

Future<void> storeWaitingTime(WriteService client, int waitingTime) async {
  final point = Point('miwula')
      .addField('waiting_time', waitingTime);
  
  await client.write(point);
}
