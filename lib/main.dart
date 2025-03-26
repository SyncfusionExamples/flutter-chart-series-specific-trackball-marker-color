import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CustomTrackballMarker(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CustomTrackballMarker extends StatefulWidget {
  const CustomTrackballMarker({super.key});

  @override
  _CustomTrackballMarkerPageState createState() =>
      _CustomTrackballMarkerPageState();
}

class _CustomTrackballMarkerPageState extends State<CustomTrackballMarker> {
  late List<RangeData> chartData1;
  late List<RangeData> chartData2;

  @override
  void initState() {
    super.initState();
    chartData1 = [
      RangeData(x: 'Product A', low: 10, high: 100),
      RangeData(x: 'Product B', low: 20, high: 120),
      RangeData(x: 'Product C', low: 10, high: 150),
      RangeData(x: 'Product D', low: 20, high: 120),
      RangeData(x: 'Product E', low: 10, high: 140),
    ];

    chartData2 = [
      RangeData(x: 'Product A', low: 150, high: 190),
      RangeData(x: 'Product B', low: 160, high: 220),
      RangeData(x: 'Product C', low: 180, high: 240),
      RangeData(x: 'Product D', low: 140, high: 180),
      RangeData(x: 'Product E', low: 200, high: 260),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        plotAreaBorderWidth: 0,
        enableSideBySideSeriesPlacement: false,
        primaryYAxis: const NumericAxis(),
        primaryXAxis: const CategoryAxis(),
        trackballBehavior: _CustomTrackballBehavior(),
        series: [
          RangeColumnSeries<RangeData, String>(
            width: 0.2,
            dataSource: chartData1,
            xValueMapper: (RangeData data, int index) => data.x,
            lowValueMapper: (RangeData data, int index) => data.low,
            highValueMapper: (RangeData data, int index) => data.high,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.diamond,
              height: 25,
              width: 25,
            ),
          ),
          RangeColumnSeries<RangeData, String>(
            width: 0.2,
            dataSource: chartData2,
            xValueMapper: (RangeData data, int index) => data.x,
            lowValueMapper: (RangeData data, int index) => data.low,
            highValueMapper: (RangeData data, int index) => data.high,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.diamond,
              height: 25,
              width: 25,
            ),
          ),
        ],
      ),
    );
  }
}

class RangeData {
  RangeData({required this.x, required this.low, required this.high});

  final String x;
  final double low;
  final double high;
}

// ignore: must_be_immutable
class _CustomTrackballBehavior extends TrackballBehavior {
  @override
  bool get enable => true;

  @override
  ActivationMode get activationMode => ActivationMode.singleTap;

  @override
  TrackballMarkerSettings? get markerSettings => const TrackballMarkerSettings(
    markerVisibility: TrackballVisibilityMode.visible,
    shape: DataMarkerType.diamond,
    borderWidth: 1,
  );

  @override
  void onPaint(
    PaintingContext context,
    Offset offset,
    SfChartThemeData chartThemeData,
    ThemeData themeData,
  ) {
    super.onPaint(context, offset, chartThemeData, themeData);
    _drawCustomMarker(context);
  }

  void _drawCustomMarker(PaintingContext context) {
    if (chartPointInfo.isEmpty || parentBox == null) {
      return;
    }

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;
    const Size lineMarkerSize = Size(15, 15);
    final translatePos = Offset(
      -lineMarkerSize.width / 2,
      -lineMarkerSize.height / 2,
    );

    if (chartPointInfo.isNotEmpty) {
      final int length = chartPointInfo.length;
      for (int i = 0; i < length; i++) {
        fillPaint.color = chartPointInfo[i].color!;

        // High position.
        Offset position = Offset(
          chartPointInfo[i].xPosition!,
          chartPointInfo[i].yPosition!,
        );
        paint(
          canvas: context.canvas,
          rect:
              position.translate(translatePos.dx, translatePos.dy) &
              lineMarkerSize,
          shapeType: ShapeMarkerType.diamond,
          paint: fillPaint,
        );

        // Low position.
        position = Offset(
          chartPointInfo[i].xPosition!,
          chartPointInfo[i].lowYPosition!,
        );
        paint(
          canvas: context.canvas,
          rect:
              position.translate(translatePos.dx, translatePos.dy) &
              lineMarkerSize,
          shapeType: ShapeMarkerType.diamond,
          paint: fillPaint,
        );
      }
    }
  }
}
