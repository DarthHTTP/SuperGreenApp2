import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_entries.dart';
import 'package:super_green_app/pages/feeds/feed/feed_bloc.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedBlocState>(
      bloc: BlocProvider.of<FeedBloc>(context),
      builder: (BuildContext context, FeedBlocState state) {
        if (state is FeedBlocStateLoaded) {
          return _renderCards(context, state);
        }
        return Text('FeedPage loading');
      },
    );
  }

  Widget _renderCards(BuildContext context, FeedBlocStateLoaded state) {
    return Container(
      color: Color(0xfffafafa),
      child: ListView.builder(
        itemCount: state.entries.length,
        itemBuilder: (context, i) {
          return FeedEntriesHelper.cardForFeedEntry(state.feed, state.entries[i]);
        }),
    );
  }
}