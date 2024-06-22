import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';


/// Provides methods to manage dynamic links.
final class DynamicLinkHandler  {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();

  /// Initializes the [DynamicLinkHandler].
  Future<void> initialize(BuildContext context) async {
    // * Listens to the dynamic links and manages navigation.
    _appLinks.uriLinkStream.listen((event) {
      _handleLinkData(event, context);
    },).onError((error) {
      log('$error', name: 'Dynamic Link Handler');
    });
    _checkInitialLink(context);
  }

  Future<void> _checkInitialLink(BuildContext context) async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLinkData(initialLink, context);
    }
  }

  // почему то срабатывает только когда приложение in background
  // когда приложение закрыто не срабатывает, поэтому для этого использовно auto_route deepLinkBuilder see in app_widget.dart line 33
  
  void _handleLinkData(Uri data, BuildContext context) {
    log('Link Data: $data', name: 'Dynamic Link Handler');
    try {
      switch (data.path) {
        case '/qrcode/page':
          context.router.replaceAll(const [Main2Route(), QrCodeRoute()]);
          break;
        case '/notification/page':
          context.router.replaceAll(const [Main2Route(), NotificationRoute()]);
          break;
        default:
          context.router.replaceAll(const [Main2Route()]);
      }
    } catch (e) {
      AppHelpers.showErrorSnack(context, 'Dynamic Link Handler Error: $e');
    }
    
  }

}