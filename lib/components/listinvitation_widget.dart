import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'listinvitation_model.dart';
export 'listinvitation_model.dart';

class ListinvitationWidget extends StatefulWidget {
  const ListinvitationWidget({super.key});

  @override
  State<ListinvitationWidget> createState() => _ListinvitationWidgetState();
}

class _ListinvitationWidgetState extends State<ListinvitationWidget> {
  late ListinvitationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListinvitationModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          FFLocalizations.of(context).getText(
            '1lb1v5z2' /* Personajes NO dsponibles */,
          ),
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                letterSpacing: 0.0,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
              ),
        ),
        Expanded(
          child: StreamBuilder<List<UserInvitationRecord>>(
            stream: queryUserInvitationRecord(
              queryBuilder: (userInvitationRecord) =>
                  userInvitationRecord.where(
                'guestConfirmed',
                isEqualTo: true,
              ),
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: SpinKitPumpingHeart(
                      color: FlutterFlowTheme.of(context).primary,
                      size: 40.0,
                    ),
                  ),
                );
              }
              List<UserInvitationRecord> containerUserInvitationRecordList =
                  snapshot.data!;
              return Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                constraints: const BoxConstraints(
                  minHeight: 100.0,
                  maxHeight: 200.0,
                ),
                decoration: const BoxDecoration(),
                child: Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final userinvitationlistview =
                                  containerUserInvitationRecordList.toList();
                              if (userinvitationlistview.isEmpty) {
                                return Image.asset(
                                  'assets/images/Icono_AkitaTu.png',
                                  fit: BoxFit.cover,
                                );
                              }
                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: userinvitationlistview.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 20.0),
                                itemBuilder:
                                    (context, userinvitationlistviewIndex) {
                                  final userinvitationlistviewItem =
                                      userinvitationlistview[
                                          userinvitationlistviewIndex];
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            userinvitationlistviewItem
                                                .guestCostume
                                                .maybeHandleOverflow(
                                              maxChars: 15,
                                              replacement: '…',
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLargeFamily,
                                                  letterSpacing: 0.0,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLargeFamily),
                                                ),
                                          ),
                                          Container(
                                            width: 40.0,
                                            height: 40.0,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: CachedNetworkImage(
                                              fadeInDuration:
                                                  const Duration(milliseconds: 500),
                                              fadeOutDuration:
                                                  const Duration(milliseconds: 500),
                                              imageUrl: userinvitationlistviewItem
                                                              .photoUrl !=
                                                          ''
                                                  ? userinvitationlistviewItem
                                                      .photoUrl
                                                  : FFAppState().urlDefault,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ].divide(const SizedBox(width: 20.0)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
