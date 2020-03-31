import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:super_green_app/data/backend/time_series/time_series_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feed/app_bar/plant_feed_app_bar_bloc.dart';
import 'package:super_green_app/widgets/fullscreen.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class PlantFeedAppBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantFeedAppBarBloc, PlantFeedAppBarBlocState>(
      builder: (BuildContext context, PlantFeedAppBarBlocState state) {
        Widget body;
        if (state is PlantFeedAppBarBlocStateInit) {
          body = FullscreenLoading(
            title: 'Loading..',
            textColor: Colors.white,
          );
        } else if (state is PlantFeedAppBarBlocStateLoaded) {
          if (state.graphData[0].data.length == 0 &&
              state.graphData[1].data.length == 0 &&
              state.graphData[2].data.length == 0) {
            body = Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white60,
                border: Border.all(color: Color(0xffdedede), width: 1),
              ),
              child: Fullscreen(
                title: 'Not enough data to display graphs yet',
                subtitle: 'try again in a few minutes',
                fontSize: 20,
                fontWeight: FontWeight.normal,
                child: Container(),
                childFirst: false,
              ),
            );
          } else {
            body = _renderGraphs(context, state);
          }
        }
        return AnimatedSwitcher(
            duration: Duration(milliseconds: 200), child: body);
      },
    );
  }

  Widget _renderGraphs(
      BuildContext context, PlantFeedAppBarBlocStateLoaded state) {
    Widget graphs = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white70,
        border: Border.all(color: Color(0xffdedede), width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Hero(
              tag: 'graphs',
              child: charts.TimeSeriesChart(state.graphData,
                  animate: false,
                  defaultRenderer: charts.LineRendererConfig(),
                  customSeriesRenderers: [
                    charts.PointRendererConfig(customRendererId: 'customPoint')
                  ]),
            ),
          ),
          Positioned(
              bottom: 0,
              right: -3,
              child: IconButton(
                  icon: Icon(Icons.fullscreen, color: Colors.white70, size: 30),
                  onPressed: () {
                    BlocProvider.of<MainNavigatorBloc>(context).add(
                        MainNavigateToMetrics(state.plant, state.graphData));
                  })),
        ],
      ),
    );
    if (state.graphData[0].data.length < 4 &&
        state.graphData[1].data.length < 4 &&
        state.graphData[2].data.length < 4) {
      graphs = Stack(children: [
        graphs,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white60,
            border: Border.all(color: Color(0xffdedede), width: 1),
          ),
          child: Fullscreen(
            title: 'Still not enough data\nto show a graph',
            subtitle: 'try again in a few hours',
            fontSize: 20,
            fontWeight: FontWeight.normal,
            child: Container(),
            childFirst: false,
          ),
        ),
      ]);
    }
    String tempUnit = AppDB().getAppData().freedomUnits ? '°F' : '°C';
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              height: 60,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(width: 4),
                    _renderMetric(
                        Colors.green,
                        'Temp',
                        '${state.graphData[0].data[state.graphData[0].data.length - 1].metric.toInt()}$tempUnit',
                        '${TimeSeriesAPI.min(state.graphData[0].data).metric.toInt()}$tempUnit',
                        '${TimeSeriesAPI.max(state.graphData[0].data).metric.toInt()}$tempUnit'),
                    _renderMetric(
                        Colors.blue,
                        'Humi',
                        '${state.graphData[1].data[state.graphData[1].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[1].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[1].data).metric.toInt()}%'),
                    _renderMetric(
                        Colors.cyan,
                        'Ventilation',
                        '${state.graphData[3].data[state.graphData[3].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[3].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[3].data).metric.toInt()}%'),
                    _renderMetric(
                        Colors.yellow,
                        'Light',
                        '${state.graphData[2].data[state.graphData[2].data.length - 1].metric.toInt()}%',
                        '${TimeSeriesAPI.min(state.graphData[2].data).metric.toInt()}%',
                        '${TimeSeriesAPI.max(state.graphData[2].data).metric.toInt()}%'),
                    Container(width: 4),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: graphs,
          ),
        ],
      ),
    );
  }

  Widget _renderMetric(
      Color color, String name, String value, String min, String max) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Text(name, style: TextStyle(color: Colors.white)),
          Row(
            children: <Widget>[
              Text(value,
                  style: TextStyle(
                    color: color,
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                  )),
              Column(
                children: <Widget>[
                  Text(max,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300)),
                  Text(min,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
