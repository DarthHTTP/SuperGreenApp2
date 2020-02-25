import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_care_common/form/feed_care_common_form_bloc.dart';

class FeedToppingFormBloc extends FeedCareCommonFormBloc {
  FeedToppingFormBloc(MainNavigateToFeedCareCommonFormEvent args)
      : super(args);

  @override
  String cardType() {
    return 'FE_TOPPING';
  }
}
