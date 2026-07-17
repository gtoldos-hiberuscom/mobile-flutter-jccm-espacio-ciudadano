import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';

/// Icon tokens — maps every Figma DS icon (node `9:1056`) to its
/// corresponding Material Symbol `IconData`.
///
/// All icons are **Material Symbols Outlined** at 24 dp as specified in Figma:
/// "Material Symbol, se deja una sola capa de vector y se renombra a Icon".
///
/// Use [AppIcon] to render any of these, or use `Icon(AppIcons.xxx)` directly.
abstract final class AppIcons {
  // ── Navigation & direction ────────────────────────────────────────────────
  static const IconData add = Icons.add;
  static const IconData remove = Icons.remove;
  static const IconData close = Icons.close;
  static const IconData check = Icons.check;
  static const IconData more = Icons.more_horiz;
  static const IconData dehaze = Icons.dehaze;
  static const IconData arrowBack = Icons.arrow_back;
  static const IconData arrowForward = Icons.arrow_forward;
  static const IconData arrowUpward = Icons.arrow_upward;
  static const IconData arrowDownward = Icons.arrow_downward;
  static const IconData chevronLeft = Icons.chevron_left;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData keyboardArrowUp = Icons.keyboard_arrow_up;
  static const IconData keyboardArrowDown = Icons.keyboard_arrow_down;

  // ── Actions ───────────────────────────────────────────────────────────────
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outlined;
  static const IconData share = Icons.share_outlined;
  static const IconData search = Icons.search;
  static const IconData settings = Icons.settings_outlined;
  static const IconData link = Icons.link;
  static const IconData openInNew = Icons.open_in_new;
  static const IconData attachment = Icons.attach_file;
  static const IconData upload = Icons.upload;
  static const IconData download = Icons.download;
  static const IconData downloadDone = Icons.download_done;
  static const IconData autorenew = Icons.autorenew;
  static const IconData callMade = Icons.call_made;
  static const IconData backspace = Icons.backspace_outlined;
  static const IconData visibility = Icons.visibility_outlined;

  // ── Communication ─────────────────────────────────────────────────────────
  static const IconData mail = Icons.mail_outlined;
  static const IconData chat = Icons.chat_bubble_outline;
  static const IconData drafts = Icons.drafts_outlined;
  static const IconData alternateEmail = Icons.alternate_email;
  static const IconData call = Icons.call_outlined;
  static const IconData notifications = Icons.notifications_outlined;
  static const IconData notificationsActive = Icons.notifications_active_outlined;
  static const IconData notificationsOff = Icons.notifications_off_outlined;

  // ── Files & documents ─────────────────────────────────────────────────────
  static const IconData docs = Icons.description_outlined;
  static const IconData draft = Icons.insert_drive_file_outlined;
  static const IconData license = Icons.badge_outlined;

  // ── Status & feedback ─────────────────────────────────────────────────────
  static const IconData info = Icons.info_outlined;
  static const IconData help = Icons.help_outlined;
  static const IconData warning = Icons.warning_amber;
  static const IconData checkCircle = Icons.check_circle_outlined;
  static const IconData cancel = Icons.cancel_outlined;
  static const IconData verified = Icons.verified_outlined;
  static const IconData hourglass = Icons.hourglass_empty;
  static const IconData graph = Icons.trending_up;

  // ── Identity & people ─────────────────────────────────────────────────────
  static const IconData person = Icons.person_outlined;
  static const IconData fingerprint = Icons.fingerprint;
  static const IconData login = Icons.login;
  static const IconData logout = Icons.logout;
  static const IconData diversity = Icons.diversity_3_outlined;

  // ── Places & organisations ────────────────────────────────────────────────
  static const IconData accountBalance = Icons.account_balance_outlined;
  static const IconData corporateFare = Icons.corporate_fare_outlined;
  static const IconData globeLocationPin = Icons.public;

  // ── Misc ──────────────────────────────────────────────────────────────────
  static const IconData apps = Icons.apps;
  static const IconData calendarToday = Icons.calendar_today_outlined;
  static const IconData schedule = Icons.schedule;
  static const IconData lock = Icons.lock_outlined;
  static const IconData favorite = Icons.favorite_border;
  static const IconData work = Icons.work_outline;
  static const IconData school = Icons.school_outlined;
  static const IconData cottage = Icons.cottage_outlined;
  static const IconData directionsCar = Icons.directions_car_outlined;
}

/// SVG asset tokens for the icon set stored in `assets/icons`.
abstract final class AppIconAssets {
  static const String accountBalance = 'assets/icons/account_balance.svg';
  static const String ajustes = 'assets/icons/ajustes.svg';
  static const String apps = 'assets/icons/apps.svg';
  static const String calendarToday = 'assets/icons/calendar_today.svg';
  static const String chat = 'assets/icons/chat.svg';
  static const String check = 'assets/icons/check.svg';
  static const String chevronRight = 'assets/icons/chevron_right.svg';
  static const String docs = 'assets/icons/docs.svg';
  static const String fingerprint = 'assets/icons/fingerprint.svg';
  static const String help = 'assets/icons/help.svg';
  static const String idCard = 'assets/icons/id_card.svg';
  static const String license = 'assets/icons/license.svg';
  static const String notifications = 'assets/icons/notifications.svg';
  static const String person = 'assets/icons/person.svg';
  static const String question = 'assets/icons/question.svg';
  static const String schedule = 'assets/icons/schedule.svg';
  static const String verified = 'assets/icons/verified.svg';
}

// ─────────────────────────────────────────────────────────────────────────────
// AppIcon widget
// ─────────────────────────────────────────────────────────────────────────────

/// Renders a design-system icon from [AppIcons].
///
/// Thin wrapper around [Icon] that defaults to [AppDimensions.iconMedium] size.
///
/// ```dart
/// AppIcon(AppIcons.notifications, color: AppColors.textWhite)
/// AppIcon(AppIcons.accountBalance, size: 32)
/// ```
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppDimensions.iconMedium,
    this.color,
    this.semanticsLabel,
  });

  /// The icon to display — use a constant from [AppIcons].
  final IconData icon;

  /// Rendered size (width = height). Defaults to [AppDimensions.iconMedium] (24).
  final double size;

  /// Optional tint colour.
  final Color? color;

  /// Optional accessibility label.
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
      semanticLabel: semanticsLabel,
    );
  }
}

/// Renders one of the design-system SVG icons from `assets/icons`.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.assetPath, {
    super.key,
    this.size = AppDimensions.iconMedium,
    this.color,
    this.semanticsLabel,
  });

  final String assetPath;
  final double size;
  final Color? color;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      semanticsLabel: semanticsLabel,
    );
  }
}
