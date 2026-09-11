import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';

/// Tablet modals use the horizontal space of a centered 390 dp phone.
const double appModalPhoneWidth = 390;

bool isTabletModal(final BuildContext context) => isTabletLayout(context);

BoxConstraints? appModalSheetConstraints(final BuildContext context) => isTabletModal(context) ? const BoxConstraints(maxWidth: appModalPhoneWidth) : null;

BoxConstraints? appModalDialogConstraints(final BuildContext context) => isTabletModal(context) ? const BoxConstraints(maxWidth: appModalPhoneWidth - 32) : null;
