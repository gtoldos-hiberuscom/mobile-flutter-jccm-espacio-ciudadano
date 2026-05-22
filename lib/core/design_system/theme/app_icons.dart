import 'package:flutter/material.dart';

/// Icon tokens — maps every Figma DS icon (node `9:1056`) to its
/// corresponding [IconData] from the Material icon font.
///
/// All icons are 24 dp (outlined style) unless noted.
/// No [BuildContext] dependency — safe in any layer.
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
  static const IconData delete = Icons.delete_outline;
  static const IconData share = Icons.share;
  static const IconData search = Icons.search;
  static const IconData settings = Icons.settings;
  static const IconData link = Icons.link;
  static const IconData openInNew = Icons.open_in_new;
  static const IconData attachment = Icons.attachment;
  static const IconData upload = Icons.upload;
  static const IconData download = Icons.download;
  static const IconData downloadDone = Icons.download_done;
  static const IconData autorenew = Icons.autorenew;
  static const IconData callMade = Icons.call_made;
  static const IconData backspace = Icons.backspace_outlined;
  static const IconData visibility = Icons.visibility_outlined;

  // ── Communication ─────────────────────────────────────────────────────────
  static const IconData mail = Icons.mail_outlined;
  static const IconData drafts = Icons.drafts_outlined;
  static const IconData alternateEmail = Icons.alternate_email;
  static const IconData call = Icons.call;
  static const IconData notifications = Icons.notifications_outlined;
  static const IconData notificationsActive = Icons.notifications_active_outlined;
  static const IconData notificationsOff = Icons.notifications_off;

  // ── Files & documents ─────────────────────────────────────────────────────
  static const IconData docs = Icons.description_outlined;
  static const IconData draft = Icons.drafts_outlined;
  static const IconData license = Icons.article_outlined;

  // ── Status & feedback ─────────────────────────────────────────────────────
  static const IconData info = Icons.info_outline;
  static const IconData help = Icons.help_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData checkCircle = Icons.check_circle_outline;
  static const IconData cancel = Icons.cancel_outlined;
  static const IconData verified = Icons.verified_outlined;
  static const IconData hourglass = Icons.hourglass_empty;
  static const IconData graph = Icons.bar_chart;

  // ── Identity & people ─────────────────────────────────────────────────────
  static const IconData person = Icons.person_outlined;
  static const IconData fingerprint = Icons.fingerprint;
  static const IconData login = Icons.login;
  static const IconData logout = Icons.logout;

  // ── Places & organisations ────────────────────────────────────────────────
  static const IconData accountBalance = Icons.account_balance_outlined;
  static const IconData corporateFare = Icons.corporate_fare;
  static const IconData globeLocationPin = Icons.travel_explore;

  // ── Misc ──────────────────────────────────────────────────────────────────
  static const IconData apps = Icons.apps;
  static const IconData calendarToday = Icons.calendar_today_outlined;
  static const IconData schedule = Icons.schedule_outlined;
  static const IconData lock = Icons.lock_outlined;
}
