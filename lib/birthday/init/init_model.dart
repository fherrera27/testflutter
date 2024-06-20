import '/flutter_flow/flutter_flow_util.dart';
import 'init_widget.dart' show InitWidget;
import 'package:flutter/material.dart';

class InitModel extends FlutterFlowModel<InitWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for switchSingInUp widget.
  bool? switchSingInUpValue;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for emailField widget.
  FocusNode? emailFieldFocusNode;
  TextEditingController? emailFieldTextController;
  String? Function(BuildContext, String?)? emailFieldTextControllerValidator;
  // State field(s) for passwordField widget.
  FocusNode? passwordFieldFocusNode;
  TextEditingController? passwordFieldTextController;
  late bool passwordFieldVisibility;
  String? Function(BuildContext, String?)? passwordFieldTextControllerValidator;
  // State field(s) for emailCreateField widget.
  FocusNode? emailCreateFieldFocusNode;
  TextEditingController? emailCreateFieldTextController;
  String? Function(BuildContext, String?)?
      emailCreateFieldTextControllerValidator;
  // State field(s) for passwordCreateField widget.
  FocusNode? passwordCreateFieldFocusNode;
  TextEditingController? passwordCreateFieldTextController;
  late bool passwordCreateFieldVisibility;
  String? Function(BuildContext, String?)?
      passwordCreateFieldTextControllerValidator;
  // State field(s) for passwordCreateConfirmField widget.
  FocusNode? passwordCreateConfirmFieldFocusNode;
  TextEditingController? passwordCreateConfirmFieldTextController;
  late bool passwordCreateConfirmFieldVisibility;
  String? Function(BuildContext, String?)?
      passwordCreateConfirmFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordFieldVisibility = false;
    passwordCreateFieldVisibility = false;
    passwordCreateConfirmFieldVisibility = false;
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();

    passwordFieldFocusNode?.dispose();
    passwordFieldTextController?.dispose();

    emailCreateFieldFocusNode?.dispose();
    emailCreateFieldTextController?.dispose();

    passwordCreateFieldFocusNode?.dispose();
    passwordCreateFieldTextController?.dispose();

    passwordCreateConfirmFieldFocusNode?.dispose();
    passwordCreateConfirmFieldTextController?.dispose();
  }
}
