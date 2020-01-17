import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feeds/feed_entries/feed_media/form/bloc/feed_media_form_bloc.dart';

class FeedMediaFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<FeedMediaFormBloc>(context),
      listener: (BuildContext context, FeedMediaFormBlocState state) {
        if (state is FeedMediaFormBlocStateDone) {
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigatorActionPop());
        }
      },
      child: BlocBuilder<FeedMediaFormBloc, FeedMediaFormBlocState>(
          bloc: Provider.of<FeedMediaFormBloc>(context),
          builder: (context, state) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Add media change',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Column(children: [
                Text('MediaChange',
                    style: TextStyle(color: Colors.white)),
                RaisedButton(
                  child: Text('OK'),
                  onPressed: () =>
                      BlocProvider.of<FeedMediaFormBloc>(context)
                          .add(FeedMediaFormBlocEventCreate('Test')),
                ),
              ]))),
    );
  }
}