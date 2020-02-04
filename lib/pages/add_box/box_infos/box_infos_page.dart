import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/add_box/box_infos/box_infos_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';
import 'package:super_green_app/widgets/green_button.dart';
import 'package:super_green_app/widgets/section_title.dart';

class BoxInfosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BoxInfosPageState();
}

class BoxInfosPageState extends State<BoxInfosPage> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: Provider.of<BoxInfosBloc>(context),
      listener: (BuildContext context, BoxInfosBlocState state) {
        if (state is BoxInfosBlocStateDone) {
          HomeNavigatorBloc.eventBus.fire(HomeNavigateToBoxFeedEvent(state.box));
          BlocProvider.of<MainNavigatorBloc>(context)
              .add(MainNavigateToSelectBoxDeviceEvent(state.box));
        }
      },
      child: BlocBuilder<BoxInfosBloc, BoxInfosBlocState>(
          bloc: Provider.of<BoxInfosBloc>(context),
          builder: (context, state) => Scaffold(
              appBar: SGLAppBar('New Box infos'),
              body: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: <Widget>[
                    SectionTitle(
                        title: 'Give a name to your new box:',
                        icon: 'assets/box_setup/icon_box_name.svg'),
                    Expanded(
                        child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black26),
                                borderRadius: BorderRadius.circular(3)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                              child: TextField(
                                textCapitalization: TextCapitalization.sentences,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText: 'Ex: BedroomGrow',
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 15),
                                controller: _nameController,
                                onChanged: (_) { setState(() {}); },
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GreenButton(
                          title: 'CREATE BOX',
                          onPressed: _nameController.value.text != '' ? () => _handleInput(context) : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  void _handleInput(BuildContext context) {
    Provider.of<BoxInfosBloc>(context, listen: false)
        .add(BoxInfosBlocEventCreateBox(_nameController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
