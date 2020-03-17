/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/feed_light_card_bloc.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';

class FeedLightCardPage extends StatelessWidget {
  final Animation animation;

  const FeedLightCardPage(this.animation, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedLightCardBloc, FeedLightCardBlocState>(
        bloc: BlocProvider.of<FeedLightCardBloc>(context),
        builder: (context, state) => FeedCard(
              animation: animation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FeedCardTitle('assets/feed_card/icon_light.svg',
                      'Stretch control', state.feedEntry),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FeedCardDate(state.feedEntry),
                  ),
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _renderValues(state.params['values'],
                            state.params['initialValues']),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  List<Widget> _renderValues(
      List<dynamic> values, List<dynamic> initialValues) {
    int i = 0;
    return values
        .map<Map<String, int>>((v) {
          return {
            'i': i,
            'from': initialValues[i++],
            'to': v,
          };
        })
        .where((v) => v['from'] != v['to'])
        .map<Widget>((v) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('channel'),
                    Text('${v['i'] + 1}',
                        style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${v['from']}%',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward),
                    Text('${v['to']}%',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ],
            ),
          );
        })
        .toList();
  }
}
