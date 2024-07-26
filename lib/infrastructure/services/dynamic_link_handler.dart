// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:myfit/application/settings/settings_notifier.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';


/// Provides methods to manage dynamic links.
final class DynamicLinkHandler  {
  DynamicLinkHandler._();

  static final instance = DynamicLinkHandler._();

  final _appLinks = AppLinks();

  /// Initializes the [DynamicLinkHandler].
  Future<void> initialize(BuildContext context, SettingsNotifier notifier) async {
    // * Listens to the dynamic links and manage navigation.
    _appLinks.uriLinkStream.listen((event) {
      _handleLinkData(event, context, notifier);
    },).onError((error) {
      AppHelpers.showErrorSnack(context, 'Dynamic Link Handler Error: $error');
    });
    //_checkInitialLink(context,notifier);
  }

  Future<void> checkInitialLink(BuildContext context, SettingsNotifier notifier) async {
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLinkData(initialLink, context,notifier);
    }
  }

  // почему то срабатывает только когда приложение in background
  // когда приложение закрыто не срабатывает, поэтому для этого использовно auto_route deepLinkBuilder see in app_widget.dart line 33
  
  void _handleLinkData(Uri data, BuildContext context, SettingsNotifier notifier) {
    log('Link Data: $data', name: 'Dynamic Link Handler');
    try {
      if (data.path.contains("/inv")) {
        //List<AutoRoutePage<dynamic>> stack =  context.router.stack;
        //final bool shouldNavigate = context.router.stack.last.name != SubscribtionSettingsRoute.name;
        notifier
          ..setIsFromReferalDeepLink(true)
          ..setReferalDeepLinkValue(data.path);
        context.router.replaceAll(const [Main2Route(), SubscribtionSettingsRoute()]);
      }else{
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
      }
    } catch (e) {
      AppHelpers.showErrorSnack(context, 'Dynamic Link Handler Error: $e');
    }
  }

}