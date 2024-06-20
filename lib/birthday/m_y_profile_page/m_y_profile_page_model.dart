import '/components/logout_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'm_y_profile_page_widget.dart' show MYProfilePageWidget;
import 'package:flutter/material.dart';

class MYProfilePageModel extends FlutterFlowModel<MYProfilePageWidget> {
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
