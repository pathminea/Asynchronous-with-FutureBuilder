Future<String> getWeatherForecast() async {
  return Future.delayed(Duration(seconds: 5), () => "Partly cloudy");
}


Future<void> fetchWeatherForecast() async {
  print("start: fetchWeatherForecast");
  final forecast = await getWeatherForecast();
  // forecast.then(
  //   (value) => print("fetchWeatherForecast: $value"),
  // );
  print("end: fetchWeatherForecast");
}


void main  () async {
  print('start: main');
  await fetchWeatherForecast();
  print('end: main');
}

