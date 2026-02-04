import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'manager_book_model.dart';
export 'manager_book_model.dart';

/// Create a beautiful splash screen for a book library Flutter app
/// "MyBookshelf".
///
/// Center a elegant book icon or open book illustration with app name
/// "MyBookshelf" in modern serif font below. Soft gradient background (light
/// beige to white, or dark navy for night). Show loading indicator
/// (CircularProgressIndicator with book color accent). After 3 seconds auto
/// navigate to login or home. Add fade transition. Use Material 3 theme.
/// Build a modern login screen + register tab for Flutter app. Use tabs or
/// segmented button to switch Login/Register. Fields: email, password, name
/// (for register). Nice book-themed background subtle. Google/Apple sign-in
/// buttons. "Forgot password?" link. Primary button "Login" / "Sign Up" with
/// rounded style. Support dark mode. Use Form widget with validation hints.
class ManagerBookWidget extends StatefulWidget {
  const ManagerBookWidget({super.key});

  static String routeName = 'ManagerBook';
  static String routePath = '/managerBook';

  @override
  State<ManagerBookWidget> createState() => _ManagerBookWidgetState();
}

class _ManagerBookWidgetState extends State<ManagerBookWidget>
    with TickerProviderStateMixin {
  late ManagerBookModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManagerBookModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF8F6F0), Colors.white, Color(0xFFF5F3EE)],
                  stops: [0, 0.6, 1],
                  begin: AlignmentDirectional(1, 1),
                  end: AlignmentDirectional(-1, -1),
                ),
              ),
            ),
            Opacity(
              opacity: 0.05,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network(
                      'https://images.unsplash.com/photo-1765547683062-6a93ecffc887?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHJhbmRvbXx8fHx8fHx8fDE3NzAwMjMzMTh8&ixlib=rb-4.1.0&q=80&w=1080',
                    ).image,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 32),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Color(0x33000000),
                            offset: Offset(0, 10),
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF8B4513),
                            Color(0xFFA0522D),
                            Color(0xFF654321),
                          ],
                          stops: [0, 0.5, 1],
                          begin: AlignmentDirectional(1, -1),
                          end: AlignmentDirectional(-1, 1),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Icon(
                          Icons.menu_book,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 48),
                    child: Text(
                      'MyBookshelf',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).displayMedium
                          .override(
                            font: GoogleFonts.playfairDisplay(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(
                                context,
                              ).displayMedium.fontStyle,
                            ),
                            color: Color(0xFF8B4513),
                            fontSize: 42,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).displayMedium.fontStyle,
                          ),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(0x4D8B4513),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: CircularPercentIndicator(
                        percent: 0.75,
                        radius: 20,
                        lineWidth: 40,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: Color(0xFF8B4513),
                        backgroundColor: Color(0x33FFFFFF),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Text(
                      'Loading your library...',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          fontStyle: FlutterFlowTheme.of(
                            context,
                          ).bodyMedium.fontStyle,
                        ),
                        color: Color(0xFF666666),
                        fontSize: 16,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                        fontStyle: FlutterFlowTheme.of(
                          context,
                        ).bodyMedium.fontStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 1),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      FlutterFlowTheme.of(context).primaryBackground,
                      FlutterFlowTheme.of(context).primaryBackground,
                    ],
                    stops: [0, 0.3, 1],
                    begin: AlignmentDirectional(0, -1),
                    end: AlignmentDirectional(0, 1),
                  ),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment(0, 0),
                        child: FlutterFlowButtonTabBar(
                          useToggleButtonStyle: false,
                          labelStyle: FlutterFlowTheme.of(context).titleMedium
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FlutterFlowTheme.of(
                                    context,
                                  ).titleMedium.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(
                                    context,
                                  ).titleMedium.fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(
                                  context,
                                ).titleMedium.fontWeight,
                                fontStyle: FlutterFlowTheme.of(
                                  context,
                                ).titleMedium.fontStyle,
                              ),
                          unselectedLabelStyle: TextStyle(),
                          labelColor: Colors.white,
                          unselectedLabelColor: Color(0xFF8B4513),
                          backgroundColor: Color(0xFF8B4513),
                          unselectedBackgroundColor: Colors.transparent,
                          borderColor: Color(0xFF8B4513),
                          unselectedBorderColor: Color(0xFF8B4513),
                          borderWidth: 2,
                          borderRadius: 12,
                          elevation: 0,
                          buttonMargin: EdgeInsetsDirectional.fromSTEB(
                            24,
                            0,
                            24,
                            0,
                          ),
                          padding: EdgeInsetsDirectional.fromSTEB(
                            24,
                            0,
                            24,
                            24,
                          ),
                          tabs: [
                            Tab(text: 'Login'),
                            Tab(text: 'Register'),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [() async {}, () async {}][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(
                                  context,
                                ).primaryBackground,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  24,
                                  32,
                                  24,
                                  24,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          0,
                                          8,
                                        ),
                                        child: Text(
                                          'Welcome Back',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .headlineMedium
                                              .override(
                                                font:
                                                    GoogleFonts.playfairDisplay(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .headlineMedium
                                                              .fontStyle,
                                                    ),
                                                color: Color(0xFF8B4513),
                                                fontSize: 28,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).headlineMedium.fontStyle,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          0,
                                          32,
                                        ),
                                        child: Text(
                                          'Sign in to access your personal library',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                ),
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontStyle,
                                              ),
                                        ),
                                      ),
                                      Form(
                                        key: _model.formKey2,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _model.textController1,
                                              focusNode:
                                                  _model.textFieldFocusNode1,
                                              autofocus: false,
                                              autofillHints: [
                                                AutofillHints.email,
                                              ],
                                              textInputAction:
                                                  TextInputAction.next,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Email',
                                                labelStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFF8B4513),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                hintText:
                                                    'Enter your email address',
                                                hintStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).alternate,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFF8B4513,
                                                        ),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).error,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).error,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                filled: true,
                                                fillColor: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                contentPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                prefixIcon: Icon(
                                                  Icons.email_outlined,
                                                  color: Color(0xFF8B4513),
                                                  size: 20,
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              cursorColor: Color(0xFF8B4513),
                                              validator: _model
                                                  .textController1Validator
                                                  .asValidator(context),
                                            ),
                                            TextFormField(
                                              controller:
                                                  _model.textController2,
                                              focusNode:
                                                  _model.textFieldFocusNode2,
                                              autofocus: false,
                                              autofillHints: [
                                                AutofillHints.password,
                                              ],
                                              textInputAction:
                                                  TextInputAction.done,
                                              obscureText:
                                                  !_model.passwordVisibility1,
                                              decoration: InputDecoration(
                                                labelText: 'Password',
                                                labelStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFF8B4513),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                hintText: 'Enter your password',
                                                hintStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).alternate,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFF8B4513,
                                                        ),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).error,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).error,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                filled: true,
                                                fillColor: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                contentPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                prefixIcon: Icon(
                                                  Icons.lock_outlined,
                                                  color: Color(0xFF8B4513),
                                                  size: 20,
                                                ),
                                                suffixIcon: InkWell(
                                                  onTap: () async {
                                                    safeSetState(
                                                      () => _model.passwordVisibility1 =
                                                          !_model
                                                              .passwordVisibility1,
                                                    );
                                                  },
                                                  focusNode: FocusNode(
                                                    skipTraversal: true,
                                                  ),
                                                  child: Icon(
                                                    _model.passwordVisibility1
                                                        ? Icons
                                                              .visibility_outlined
                                                        : Icons
                                                              .visibility_off_outlined,
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).secondaryText,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                              cursorColor: Color(0xFF8B4513),
                                              validator: _model
                                                  .textController2Validator
                                                  .asValidator(context),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Forgot Password?',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodySmall.override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                        color: Color(
                                                          0xFF8B4513,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodySmall
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ].divide(SizedBox(height: 16)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          24,
                                          0,
                                          0,
                                        ),
                                        child: FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: 'Login',
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 52,
                                            padding: EdgeInsets.all(8),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                            color: Color(0xFF8B4513),
                                            textStyle:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).titleMedium.override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).titleMedium.fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).titleMedium.fontStyle,
                                                ),
                                            elevation: 2,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          24,
                                          0,
                                          16,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 1,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).alternate,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '  or continue with  ',
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).bodySmall.fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodySmall.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodySmall.fontStyle,
                                                  ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 1,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).alternate,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: FFButtonWidget(
                                              onPressed: () {
                                                print('Button pressed ...');
                                              },
                                              text: 'Google',
                                              icon: Icon(
                                                Icons.google,
                                                size: 20,
                                              ),
                                              options: FFButtonOptions(
                                                height: 48,
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                iconPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                iconColor: Color(0xFFDB4437),
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                textStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                elevation: 0,
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).alternate,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FFButtonWidget(
                                              onPressed: () {
                                                print('Button pressed ...');
                                              },
                                              text: 'Apple',
                                              icon: Icon(Icons.apple, size: 20),
                                              options: FFButtonOptions(
                                                height: 48,
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                iconPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                iconColor: FlutterFlowTheme.of(
                                                  context,
                                                ).primaryText,
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                textStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                elevation: 0,
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).alternate,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 16)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(
                                  context,
                                ).primaryBackground,
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  24,
                                  32,
                                  24,
                                  24,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          0,
                                          8,
                                        ),
                                        child: Text(
                                          'Join MyBookshelf',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .headlineMedium
                                              .override(
                                                font:
                                                    GoogleFonts.playfairDisplay(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .headlineMedium
                                                              .fontStyle,
                                                    ),
                                                color: Color(0xFF8B4513),
                                                fontSize: 28,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).headlineMedium.fontStyle,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          0,
                                          32,
                                        ),
                                        child: Text(
                                          'Create your account to start building your digital library',
                                          textAlign: TextAlign.center,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                ),
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontStyle,
                                              ),
                                        ),
                                      ),
                                      Form(
                                        key: _model.formKey1,
                                        autovalidateMode:
                                            AutovalidateMode.disabled,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            TextFormField(
                                              controller:
                                                  _model.textController3,
                                              focusNode:
                                                  _model.textFieldFocusNode3,
                                              autofocus: false,
                                              autofillHints: [
                                                AutofillHints.name,
                                              ],
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              textInputAction:
                                                  TextInputAction.next,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Full Name',
                                                labelStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFF8B4513),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                hintText:
                                                    'Enter your full name',
                                                hintStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).alternate,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFF8B4513,
                                                        ),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).error,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).error,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                filled: true,
                                                fillColor: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                contentPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                prefixIcon: Icon(
                                                  Icons.person_outlined,
                                                  color: Color(0xFF8B4513),
                                                  size: 20,
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                              keyboardType: TextInputType.name,
                                              cursorColor: Color(0xFF8B4513),
                                              validator: _model
                                                  .textController3Validator
                                                  .asValidator(context),
                                              inputFormatters: [
                                                if (!isAndroid && !isiOS)
                                                  TextInputFormatter.withFunction(
                                                    (oldValue, newValue) {
                                                      return TextEditingValue(
                                                        selection:
                                                            newValue.selection,
                                                        text: newValue.text
                                                            .toCapitalization(
                                                              TextCapitalization
                                                                  .words,
                                                            ),
                                                      );
                                                    },
                                                  ),
                                              ],
                                            ),
                                            TextFormField(
                                              controller:
                                                  _model.textController4,
                                              focusNode:
                                                  _model.textFieldFocusNode4,
                                              autofocus: false,
                                              autofillHints: [
                                                AutofillHints.email,
                                              ],
                                              textInputAction:
                                                  TextInputAction.next,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                labelText: 'Email',
                                                labelStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFF8B4513),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                hintText:
                                                    'Enter your email address',
                                                hintStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).alternate,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFF8B4513,
                                                        ),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).error,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).error,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                filled: true,
                                                fillColor: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                contentPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                prefixIcon: Icon(
                                                  Icons.email_outlined,
                                                  color: Color(0xFF8B4513),
                                                  size: 20,
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              cursorColor: Color(0xFF8B4513),
                                              validator: _model
                                                  .textController4Validator
                                                  .asValidator(context),
                                            ),
                                            TextFormField(
                                              controller:
                                                  _model.textController5,
                                              focusNode:
                                                  _model.textFieldFocusNode5,
                                              autofocus: false,
                                              autofillHints: [
                                                AutofillHints.newPassword,
                                              ],
                                              textInputAction:
                                                  TextInputAction.done,
                                              obscureText:
                                                  !_model.passwordVisibility2,
                                              decoration: InputDecoration(
                                                labelText: 'Password',
                                                labelStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).labelMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .labelMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFF8B4513),
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                hintText:
                                                    'Create a strong password',
                                                hintStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).secondaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).alternate,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(
                                                          0xFF8B4513,
                                                        ),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).error,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).error,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                filled: true,
                                                fillColor: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                contentPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                prefixIcon: Icon(
                                                  Icons.lock_outlined,
                                                  color: Color(0xFF8B4513),
                                                  size: 20,
                                                ),
                                                suffixIcon: InkWell(
                                                  onTap: () async {
                                                    safeSetState(
                                                      () => _model.passwordVisibility2 =
                                                          !_model
                                                              .passwordVisibility2,
                                                    );
                                                  },
                                                  focusNode: FocusNode(
                                                    skipTraversal: true,
                                                  ),
                                                  child: Icon(
                                                    _model.passwordVisibility2
                                                        ? Icons
                                                              .visibility_outlined
                                                        : Icons
                                                              .visibility_off_outlined,
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).secondaryText,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 16,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                              cursorColor: Color(0xFF8B4513),
                                              validator: _model
                                                  .textController5Validator
                                                  .asValidator(context),
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              child: Theme(
                                                data: ThemeData(
                                                  checkboxTheme:
                                                      CheckboxThemeData(
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                  unselectedWidgetColor:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).alternate,
                                                ),
                                                child: CheckboxListTile(
                                                  value:
                                                      _model.checkboxListTileValue ??=
                                                          false,
                                                  onChanged: (newValue) async {
                                                    safeSetState(
                                                      () =>
                                                          _model.checkboxListTileValue =
                                                              newValue!,
                                                    );
                                                  },
                                                  title: Text(
                                                    'I agree to the Terms of Service and Privacy Policy',
                                                    style:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodySmall.override(
                                                          font: GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodySmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).secondaryText,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodySmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  activeColor: Color(
                                                    0xFF8B4513,
                                                  ),
                                                  checkColor: Colors.white,
                                                  dense: true,
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .trailing,
                                                  contentPadding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        8,
                                                        0,
                                                        8,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 16)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          24,
                                          0,
                                          0,
                                        ),
                                        child: FFButtonWidget(
                                          onPressed: () {
                                            print('Button pressed ...');
                                          },
                                          text: 'Sign Up',
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 52,
                                            padding: EdgeInsets.all(8),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                            color: Color(0xFF8B4513),
                                            textStyle:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).titleMedium.override(
                                                  font: GoogleFonts.interTight(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).titleMedium.fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).titleMedium.fontStyle,
                                                ),
                                            elevation: 2,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          24,
                                          0,
                                          16,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 1,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).alternate,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '  or continue with  ',
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodySmall.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).bodySmall.fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodySmall.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodySmall.fontStyle,
                                                  ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 1,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).alternate,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: FFButtonWidget(
                                              onPressed: () {
                                                print('Button pressed ...');
                                              },
                                              text: 'Google',
                                              icon: Icon(
                                                Icons.google,
                                                size: 20,
                                              ),
                                              options: FFButtonOptions(
                                                height: 48,
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                iconPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                iconColor: Color(0xFFDB4437),
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryBackground,
                                                textStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                elevation: 0,
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).alternate,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          FFButtonWidget(
                                            onPressed: () {
                                              print('Button pressed ...');
                                            },
                                            text: 'Apple',
                                            icon: Icon(Icons.apple, size: 20),
                                            options: FFButtonOptions(
                                              height: 48,
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    16,
                                                    0,
                                                    16,
                                                    0,
                                                  ),
                                              iconPadding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              iconColor: FlutterFlowTheme.of(
                                                context,
                                              ).primaryText,
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).secondaryBackground,
                                              textStyle:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                              elevation: 0,
                                              borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).alternate,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 16)),
                                      ),
                                    ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
