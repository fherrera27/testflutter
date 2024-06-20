import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/modal_custom/modal_custom_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'init_model.dart';
export 'init_model.dart';

class InitWidget extends StatefulWidget {
  const InitWidget({super.key});

  @override
  State<InitWidget> createState() => _InitWidgetState();
}

class _InitWidgetState extends State<InitWidget> with TickerProviderStateMixin {
  late InitModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InitModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'init'});
    _model.switchSingInUpValue = false;
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _model.emailFieldTextController ??= TextEditingController();
    _model.emailFieldFocusNode ??= FocusNode();

    _model.passwordFieldTextController ??= TextEditingController();
    _model.passwordFieldFocusNode ??= FocusNode();

    _model.emailCreateFieldTextController ??= TextEditingController();
    _model.emailCreateFieldFocusNode ??= FocusNode();

    _model.passwordCreateFieldTextController ??= TextEditingController();
    _model.passwordCreateFieldFocusNode ??= FocusNode();

    _model.passwordCreateConfirmFieldTextController ??= TextEditingController();
    _model.passwordCreateConfirmFieldFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 1.0,
            constraints: const BoxConstraints(
              maxWidth: double.infinity,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFC81D77),
                  FlutterFlowTheme.of(context).secondary
                ],
                stops: const [0.0, 1.0],
                begin: const AlignmentDirectional(0.03, -1.0),
                end: const AlignmentDirectional(-0.03, 1.0),
              ),
            ),
            child: Align(
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 60.0, 0.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 24.0),
                            child: Wrap(
                              spacing: 16.0,
                              runSpacing: 16.0,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              runAlignment: WrapAlignment.start,
                              verticalDirection: VerticalDirection.down,
                              clipBehavior: Clip.none,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                    minWidth: 100.0,
                                    maxWidth: 500.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Align(
                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                FFLocalizations.of(context)
                                                    .getText(
                                                  '3hn16327' /* ¡Estás Invitado!
¡No te lo pue... */
                                                  ,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 5,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displaySmallFamily,
                                                          letterSpacing: 2.0,
                                                          useGoogleFonts: GoogleFonts
                                                                  .asMap()
                                                              .containsKey(
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .displaySmallFamily),
                                                          lineHeight: 2.0,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 500.0,
                                  height: double.infinity,
                                  constraints: const BoxConstraints(
                                    minHeight: 100.0,
                                    maxWidth: 500.0,
                                    maxHeight: 600.0,
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 12.0,
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        offset: const Offset(
                                          0.0,
                                          0.0,
                                        ),
                                        spreadRadius: 8.0,
                                      )
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        FlutterFlowTheme.of(context).secondary,
                                        const Color(0xFFC81D77)
                                      ],
                                      stops: const [0.0, 1.0],
                                      begin: const AlignmentDirectional(1.0, -0.98),
                                      end: const AlignmentDirectional(-1.0, 0.98),
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 16.0, 12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (!_model.switchSingInUpValue!)
                                          Padding(
                                            padding:
                                                const EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 0.0, 4.0),
                                            child: Text(
                                              FFLocalizations.of(context)
                                                  .getText(
                                                'fcivjcip' /* Estamos emocionados de tú asis... */,
                                              ),
                                              textAlign: TextAlign.center,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLargeFamily,
                                                        letterSpacing: 3.0,
                                                        useGoogleFonts: GoogleFonts
                                                                .asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelLargeFamily),
                                                        lineHeight: 1.0,
                                                      ),
                                            ),
                                          ),
                                        Switch.adaptive(
                                          value: _model.switchSingInUpValue!,
                                          onChanged: (newValue) async {
                                            setState(() =>
                                                _model.switchSingInUpValue =
                                                    newValue);
                                            if (newValue) {
                                              logFirebaseEvent(
                                                  'INIT_PAGE_switchSingInUp_ON_TOGGLE_ON');
                                            } else {
                                              logFirebaseEvent(
                                                  'INIT_PAGE_switchSingInUp_ON_TOGGLE_OFF');
                                            }
                                          },
                                          activeColor: const Color(0xFFC81D77),
                                          activeTrackColor:
                                              FlutterFlowTheme.of(context)
                                                  .accent1,
                                          inactiveTrackColor: const Color(0x5B1BA4DD),
                                          inactiveThumbColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                        ),
                                        if (_model.switchSingInUpValue ?? true)
                                          Flexible(
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  1.0,
                                              height: 100.0,
                                              constraints: const BoxConstraints(
                                                minHeight: 400.0,
                                                maxHeight: 600.0,
                                              ),
                                              decoration: const BoxDecoration(),
                                              child: Container(
                                                height: double.infinity,
                                                constraints: BoxConstraints(
                                                  minHeight:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          1.0,
                                                  maxHeight:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          1.0,
                                                ),
                                                decoration: const BoxDecoration(),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const Alignment(0.0, 0),
                                                      child: TabBar(
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  fontSize:
                                                                      28.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyLargeFamily),
                                                                ),
                                                        unselectedLabelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLargeFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  useGoogleFonts: GoogleFonts
                                                                          .asMap()
                                                                      .containsKey(
                                                                          FlutterFlowTheme.of(context)
                                                                              .bodyLargeFamily),
                                                                ),
                                                        padding:
                                                            const EdgeInsets.all(4.0),
                                                        tabs: [
                                                          Tab(
                                                            text: FFLocalizations
                                                                    .of(context)
                                                                .getText(
                                                              'rlrleueu' /* Ingreso */,
                                                            ),
                                                          ),
                                                          Tab(
                                                            text: FFLocalizations
                                                                    .of(context)
                                                                .getText(
                                                              '6959blpi' /* Registro */,
                                                            ),
                                                          ),
                                                        ],
                                                        controller: _model
                                                            .tabBarController,
                                                        onTap: (i) async {
                                                          [
                                                            () async {},
                                                            () async {}
                                                          ][i]();
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: TabBarView(
                                                        controller: _model
                                                            .tabBarController,
                                                        children: [
                                                          SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            18.0,
                                                                            8.0,
                                                                            9.0),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              _model.emailFieldTextController,
                                                                          focusNode:
                                                                              _model.emailFieldFocusNode,
                                                                          autofocus:
                                                                              false,
                                                                          obscureText:
                                                                              false,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                FFLocalizations.of(context).getText(
                                                                              '4hbjt4rn' /* correo */,
                                                                            ),
                                                                            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                                  lineHeight: 1.0,
                                                                                ),
                                                                            alignLabelWithHint:
                                                                                false,
                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            errorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedErrorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 1.0,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                lineHeight: 1.0,
                                                                              ),
                                                                          maxLength:
                                                                              100,
                                                                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                                                              null,
                                                                          keyboardType:
                                                                              TextInputType.emailAddress,
                                                                          cursorColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          validator: _model
                                                                              .emailFieldTextControllerValidator
                                                                              .asValidator(context),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            8.0),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              _model.passwordFieldTextController,
                                                                          focusNode:
                                                                              _model.passwordFieldFocusNode,
                                                                          autofocus:
                                                                              true,
                                                                          obscureText:
                                                                              !_model.passwordFieldVisibility,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                FFLocalizations.of(context).getText(
                                                                              '9fwymond' /* contraseña */,
                                                                            ),
                                                                            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                                  lineHeight: 1.0,
                                                                                ),
                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            errorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedErrorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            suffixIcon:
                                                                                InkWell(
                                                                              onTap: () => setState(
                                                                                () => _model.passwordFieldVisibility = !_model.passwordFieldVisibility,
                                                                              ),
                                                                              focusNode: FocusNode(skipTraversal: true),
                                                                              child: Icon(
                                                                                _model.passwordFieldVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                                                size: 20.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 1.0,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                lineHeight: 1.0,
                                                                              ),
                                                                          maxLength:
                                                                              100,
                                                                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                                                              null,
                                                                          cursorColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          validator: _model
                                                                              .passwordFieldTextControllerValidator
                                                                              .asValidator(context),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          8.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      logFirebaseEvent(
                                                                          'INIT_PAGE_buttonLoginEmail_ON_TAP');
                                                                      Function()
                                                                          navigate =
                                                                          () {};
                                                                      if (FFAppConstants
                                                                              .emails
                                                                              .contains(_model.emailFieldTextController.text) ==
                                                                          true) {
                                                                        logFirebaseEvent(
                                                                            'buttonLoginEmail_auth');
                                                                        GoRouter.of(context)
                                                                            .prepareAuthEvent();

                                                                        final user =
                                                                            await authManager.signInWithEmail(
                                                                          context,
                                                                          _model
                                                                              .emailFieldTextController
                                                                              .text,
                                                                          _model
                                                                              .passwordFieldTextController
                                                                              .text,
                                                                        );
                                                                        if (user ==
                                                                            null) {
                                                                          return;
                                                                        }

                                                                        navigate = () => context.goNamedAuth(
                                                                            'homePage',
                                                                            context.mounted);

                                                                        navigate();
                                                                        return;
                                                                      } else {
                                                                        logFirebaseEvent(
                                                                            'buttonLoginEmail_bottom_sheet');
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: const ModalCustomWidget(
                                                                                title: FFAppConstants.WARNTITLE,
                                                                                message: FFAppConstants.WARNMESSAGE,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));

                                                                        return;
                                                                      }

                                                                      navigate();
                                                                    },
                                                                    text: FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      '5d1jjuy6' /* Ingresar */,
                                                                    ),
                                                                    icon: const Icon(
                                                                      Icons
                                                                          .login,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          230.0,
                                                                      height:
                                                                          44.0,
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: const Color(
                                                                          0x2FC81D77),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                          ),
                                                                      elevation:
                                                                          0.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40.0),
                                                                      hoverColor:
                                                                          const Color(
                                                                              0xAA1BA4DD),
                                                                      hoverBorderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          8.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      logFirebaseEvent(
                                                                          'INIT_PAGE_buttonLoginGoogle_ON_TAP');
                                                                      logFirebaseEvent(
                                                                          'buttonLoginGoogle_auth');
                                                                      GoRouter.of(
                                                                              context)
                                                                          .prepareAuthEvent();
                                                                      final user =
                                                                          await authManager
                                                                              .signInWithGoogle(context);
                                                                      if (user ==
                                                                          null) {
                                                                        return;
                                                                      }
                                                                      if (FFAppConstants
                                                                              .emails
                                                                              .contains(currentUserEmail) ==
                                                                          true) {
                                                                        logFirebaseEvent(
                                                                            'buttonLoginGoogle_navigate_to');

                                                                        context.pushNamedAuth(
                                                                            'homePage',
                                                                            context.mounted);
                                                                      } else {
                                                                        logFirebaseEvent(
                                                                            'buttonLoginGoogle_bottom_sheet');
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: const ModalCustomWidget(
                                                                                title: FFAppConstants.WARNTITLE,
                                                                                message: FFAppConstants.WARNMESSAGE,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));

                                                                        logFirebaseEvent(
                                                                            'buttonLoginGoogle_reset_form_fields');
                                                                        setState(
                                                                            () {
                                                                          _model.switchSingInUpValue =
                                                                              false;
                                                                        });
                                                                        logFirebaseEvent(
                                                                            'buttonLoginGoogle_reset_form_fields');
                                                                        setState(
                                                                            () {
                                                                          _model
                                                                              .emailFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .emailCreateFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordCreateFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordCreateConfirmFieldTextController
                                                                              ?.clear();
                                                                        });
                                                                        logFirebaseEvent(
                                                                            'buttonLoginGoogle_auth');
                                                                        await authManager
                                                                            .deleteUser(context);
                                                                        return;
                                                                      }
                                                                    },
                                                                    text: FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'niqwd8sb' /*  */,
                                                                    ),
                                                                    icon:
                                                                        const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .google,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          230.0,
                                                                      height:
                                                                          44.0,
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: const Color(
                                                                          0x2FC81D77),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                          ),
                                                                      elevation:
                                                                          0.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40.0),
                                                                      hoverColor:
                                                                          const Color(
                                                                              0xAA1BA4DD),
                                                                      hoverBorderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            8.0,
                                                                            8.0,
                                                                            9.0),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              _model.emailCreateFieldTextController,
                                                                          focusNode:
                                                                              _model.emailCreateFieldFocusNode,
                                                                          autofocus:
                                                                              false,
                                                                          obscureText:
                                                                              false,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                FFLocalizations.of(context).getText(
                                                                              'zipz2xek' /* correo */,
                                                                            ),
                                                                            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                                  lineHeight: 1.0,
                                                                                ),
                                                                            alignLabelWithHint:
                                                                                false,
                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                ),
                                                                            errorStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                  color: FlutterFlowTheme.of(context).error,
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                  lineHeight: 1.0,
                                                                                ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            errorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedErrorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 1.0,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                lineHeight: 1.0,
                                                                              ),
                                                                          maxLength:
                                                                              100,
                                                                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                                                              null,
                                                                          keyboardType:
                                                                              TextInputType.emailAddress,
                                                                          cursorColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          validator: _model
                                                                              .emailCreateFieldTextControllerValidator
                                                                              .asValidator(context),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            8.0),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              _model.passwordCreateFieldTextController,
                                                                          focusNode:
                                                                              _model.passwordCreateFieldFocusNode,
                                                                          autofocus:
                                                                              true,
                                                                          obscureText:
                                                                              !_model.passwordCreateFieldVisibility,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                FFLocalizations.of(context).getText(
                                                                              '5yltsksb' /* contraseña */,
                                                                            ),
                                                                            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                                  lineHeight: 1.0,
                                                                                ),
                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            errorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedErrorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            suffixIcon:
                                                                                InkWell(
                                                                              onTap: () => setState(
                                                                                () => _model.passwordCreateFieldVisibility = !_model.passwordCreateFieldVisibility,
                                                                              ),
                                                                              focusNode: FocusNode(skipTraversal: true),
                                                                              child: Icon(
                                                                                _model.passwordCreateFieldVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                                                size: 20.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 1.0,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                lineHeight: 1.0,
                                                                              ),
                                                                          maxLength:
                                                                              100,
                                                                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                                                              null,
                                                                          cursorColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          validator: _model
                                                                              .passwordCreateFieldTextControllerValidator
                                                                              .asValidator(context),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            8.0,
                                                                            0.0,
                                                                            8.0,
                                                                            8.0),
                                                                        child:
                                                                            TextFormField(
                                                                          controller:
                                                                              _model.passwordCreateConfirmFieldTextController,
                                                                          focusNode:
                                                                              _model.passwordCreateConfirmFieldFocusNode,
                                                                          autofocus:
                                                                              true,
                                                                          obscureText:
                                                                              !_model.passwordCreateConfirmFieldVisibility,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                FFLocalizations.of(context).getText(
                                                                              '4z0grc1e' /* confirma contraseña */,
                                                                            ),
                                                                            labelStyle: FlutterFlowTheme.of(context).labelLarge.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelLargeFamily,
                                                                                  letterSpacing: 1.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                                  lineHeight: 1.0,
                                                                                ),
                                                                            hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                  letterSpacing: 0.0,
                                                                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).primaryText,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).secondary,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            errorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            focusedErrorBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: FlutterFlowTheme.of(context).error,
                                                                                width: 3.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(24.0),
                                                                            ),
                                                                            suffixIcon:
                                                                                InkWell(
                                                                              onTap: () => setState(
                                                                                () => _model.passwordCreateConfirmFieldVisibility = !_model.passwordCreateConfirmFieldVisibility,
                                                                              ),
                                                                              focusNode: FocusNode(skipTraversal: true),
                                                                              child: Icon(
                                                                                _model.passwordCreateConfirmFieldVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                                                size: 20.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                                                                letterSpacing: 1.0,
                                                                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                                                                lineHeight: 1.0,
                                                                              ),
                                                                          maxLength:
                                                                              100,
                                                                          buildCounter: (context, {required currentLength, required isFocused, maxLength}) =>
                                                                              null,
                                                                          cursorColor:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          validator: _model
                                                                              .passwordCreateConfirmFieldTextControllerValidator
                                                                              .asValidator(context),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          8.0,
                                                                          0.0,
                                                                          16.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      logFirebaseEvent(
                                                                          'INIT_PAGE_buttonSingUpEmail_ON_TAP');
                                                                      Function()
                                                                          navigate =
                                                                          () {};
                                                                      if (FFAppConstants
                                                                              .emails
                                                                              .contains(_model.emailCreateFieldTextController.text) ==
                                                                          true) {
                                                                        // actionCreateAccountEmail
                                                                        logFirebaseEvent(
                                                                            'buttonSingUpEmail_actionCreateAccountEma');
                                                                        GoRouter.of(context)
                                                                            .prepareAuthEvent();
                                                                        if (_model.passwordCreateFieldTextController.text !=
                                                                            _model.passwordCreateConfirmFieldTextController.text) {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            const SnackBar(
                                                                              content: Text(
                                                                                'Passwords don\'t match!',
                                                                              ),
                                                                            ),
                                                                          );
                                                                          return;
                                                                        }

                                                                        final user =
                                                                            await authManager.createAccountWithEmail(
                                                                          context,
                                                                          _model
                                                                              .emailCreateFieldTextController
                                                                              .text,
                                                                          _model
                                                                              .passwordCreateFieldTextController
                                                                              .text,
                                                                        );
                                                                        if (user ==
                                                                            null) {
                                                                          return;
                                                                        }

                                                                        await UsersRecord
                                                                            .collection
                                                                            .doc(user.uid)
                                                                            .update({
                                                                          ...mapToFirestore(
                                                                            {
                                                                              'created_time': FieldValue.serverTimestamp(),
                                                                              'last_active_time': FieldValue.serverTimestamp(),
                                                                            },
                                                                          ),
                                                                        });

                                                                        navigate = () => context.goNamedAuth(
                                                                            'homePage',
                                                                            context.mounted);

                                                                        navigate();
                                                                        return;
                                                                      } else {
                                                                        logFirebaseEvent(
                                                                            'buttonSingUpEmail_reset_form_fields');
                                                                        setState(
                                                                            () {
                                                                          _model.switchSingInUpValue =
                                                                              false;
                                                                        });
                                                                        logFirebaseEvent(
                                                                            'buttonSingUpEmail_reset_form_fields');
                                                                        setState(
                                                                            () {
                                                                          _model
                                                                              .emailCreateFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordCreateFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordCreateConfirmFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .emailFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordFieldTextController
                                                                              ?.clear();
                                                                        });
                                                                        // actionCreateAccountAlert
                                                                        logFirebaseEvent(
                                                                            'buttonSingUpEmail_actionCreateAccountAle');
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: const ModalCustomWidget(
                                                                                title: FFAppConstants.WARNTITLE,
                                                                                message: FFAppConstants.WARNMESSAGE,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));

                                                                        return;
                                                                      }

                                                                      navigate();
                                                                    },
                                                                    text: FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'yjkwfbi7' /* registrar */,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          230.0,
                                                                      height:
                                                                          44.0,
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: const Color(
                                                                          0xFFC81D77),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                          ),
                                                                      elevation:
                                                                          0.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40.0),
                                                                      hoverColor:
                                                                          const Color(
                                                                              0xAA1BA4DD),
                                                                      hoverBorderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          16.0),
                                                                  child:
                                                                      FFButtonWidget(
                                                                    onPressed:
                                                                        () async {
                                                                      logFirebaseEvent(
                                                                          'INIT_PAGE_buttonSingUpGoogle_ON_TAP');
                                                                      // ActionCreateAccountGoogle
                                                                      logFirebaseEvent(
                                                                          'buttonSingUpGoogle_ActionCreateAccountGo');
                                                                      GoRouter.of(
                                                                              context)
                                                                          .prepareAuthEvent();
                                                                      final user =
                                                                          await authManager
                                                                              .signInWithGoogle(context);
                                                                      if (user ==
                                                                          null) {
                                                                        return;
                                                                      }
                                                                      if ((currentUserEmail !=
                                                                                  '') &&
                                                                          FFAppConstants
                                                                              .emails
                                                                              .contains(currentUserEmail)) {
                                                                        // navigateFromCreateUser
                                                                        logFirebaseEvent(
                                                                            'buttonSingUpGoogle_navigateFromCreateUse');

                                                                        context.pushNamedAuth(
                                                                            'homePage',
                                                                            context.mounted);

                                                                        return;
                                                                      } else {
                                                                        logFirebaseEvent(
                                                                            'buttonSingUpGoogle_reset_form_fields');
                                                                        setState(
                                                                            () {
                                                                          _model.switchSingInUpValue =
                                                                              false;
                                                                        });
                                                                        logFirebaseEvent(
                                                                            'buttonSingUpGoogle_reset_form_fields');
                                                                        setState(
                                                                            () {
                                                                          _model
                                                                              .emailFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .emailCreateFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordCreateFieldTextController
                                                                              ?.clear();
                                                                          _model
                                                                              .passwordCreateConfirmFieldTextController
                                                                              ?.clear();
                                                                        });
                                                                        logFirebaseEvent(
                                                                            'buttonSingUpGoogle_bottom_sheet');
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Padding(
                                                                              padding: MediaQuery.viewInsetsOf(context),
                                                                              child: const ModalCustomWidget(
                                                                                title: FFAppConstants.WARNTITLE,
                                                                                message: FFAppConstants.WARNMESSAGE,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            safeSetState(() {}));

                                                                        logFirebaseEvent(
                                                                            'buttonSingUpGoogle_auth');
                                                                        await authManager
                                                                            .deleteUser(context);
                                                                        return;
                                                                      }
                                                                    },
                                                                    text: FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'taill4c8' /*  */,
                                                                    ),
                                                                    icon:
                                                                        const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .google,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                                    options:
                                                                        FFButtonOptions(
                                                                      width:
                                                                          230.0,
                                                                      height:
                                                                          44.0,
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      color: const Color(
                                                                          0xFFC81D77),
                                                                      textStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLarge
                                                                          .override(
                                                                            fontFamily:
                                                                                FlutterFlowTheme.of(context).labelLargeFamily,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            useGoogleFonts:
                                                                                GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelLargeFamily),
                                                                          ),
                                                                      elevation:
                                                                          0.0,
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40.0),
                                                                      hoverColor:
                                                                          const Color(
                                                                              0xAA1BA4DD),
                                                                      hoverBorderSide:
                                                                          BorderSide(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondary,
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
