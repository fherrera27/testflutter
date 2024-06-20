import '/components/listinvitation_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'edit_guest_widget.dart' show EditGuestWidget;
import 'package:flutter/material.dart';

class EditGuestModel extends FlutterFlowModel<EditGuestWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for listinvitation component.
  late ListinvitationModel listinvitationModel;
  bool isDataUploading1 = false;
  FFUploadedFile uploadedLocalFile1 =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameTextController;
  String? Function(BuildContext, String?)? yourNameTextControllerValidator;
  // State field(s) for yourcustome widget.
  FocusNode? yourcustomeFocusNode;
  TextEditingController? yourcustomeTextController;
  String? Function(BuildContext, String?)? yourcustomeTextControllerValidator;
  // State field(s) for Switch widget.
  bool? switchValue;
  bool isDataUploading2 = false;
  FFUploadedFile uploadedLocalFile2 =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl2 = '';

  @override
  void initState(BuildContext context) {
    listinvitationModel = createModel(context, () => ListinvitationModel());
  }

  @override
  void dispose() {
    listinvitationModel.dispose();
    yourNameFocusNode?.dispose();
    yourNameTextController?.dispose();

    yourcustomeFocusNode?.dispose();
    yourcustomeTextController?.dispose();
  }
}
