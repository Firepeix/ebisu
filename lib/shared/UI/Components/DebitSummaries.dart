import 'package:ebisu/modules/expenditure/domain/ExpenditureSummary.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'Shimmer.dart';

class DebitSummary extends StatelessWidget {
  final DebitExpenditureSummary _summary;
  DebitSummary(this._summary);
  @override
  Widget build (BuildContext context) => Padding(padding: EdgeInsets.symmetric(vertical: 20),
    child: Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(height: 130, child: DebitChart(_summary.series),),
      ),
    ),
  );

}

class DebitChart extends StatefulWidget {
  final List<DebitExpenditureSummarySeries> _series;

  DebitChart(this._series);

  @override
  State<StatefulWidget> createState() => _DebitChartState();

  Widget build(BuildContext context, _DebitChartState state) => BarChart(
    state.mainBarData(_series),
    swapAnimationDuration: state.animDuration,
  );
}

class _DebitChartState extends State<DebitChart> {
  final Duration animDuration = Duration(milliseconds: 150);

  int touchedIndex = -1;

  bool isPlaying = false;

  List<BarChartGroupData> _mapSeries (List<DebitExpenditureSummarySeries> _series) {
    int xPos = 0;
    final List<BarChartGroupData> _data = [];
    _series.forEach((DebitExpenditureSummarySeries serie) {
      bool isTouched = touchedIndex == xPos;
      _data.add(BarChartGroupData(
        x: xPos,
        barRods: [
          BarChartRodData(
            y: serie.value.asDouble,
            colors: isTouched ? [serie.color.shade200] : [serie.color],
            width: 60,
            borderRadius: BorderRadius.circular(5)
          ),
        ],
      ));
      xPos++;
    });

    return _data;
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  BarChartData mainBarData(List<DebitExpenditureSummarySeries> _series) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                _series[groupIndex].value.real,
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          getTitles: (double value) => _series[value.toInt()].label
        ),
        topTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
            getTitles: (double value) => _series[value.toInt()].value.real
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _mapSeries(_series),
    );
  }
}

class DebitSummariesSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Shimmer(
        child: ShimmerLoading(
            isLoading: true,
            child: Column(
            children: [ Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child:Container(
                  width: 383.4,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    shape: BoxShape.rectangle,
                  ),
                )
            )
          ],
        )),
      );
}
