import '/components/logout_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  bool? showCart = false;

  ///  State fields for stateful widgets in this page.

  // Model for logout component.
  late LogoutModel logoutModel;

  @override
  void initState(BuildContext context) {
    logoutModel = createModel(context, () => LogoutModel());
  }

  @override
  void dispose() {
    logoutModel.dispose();
  }
}
