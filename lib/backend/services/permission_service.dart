import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/services/health_step_service.dart';

/// Centralized permission service following App Store / Play Store best practices.
/// Shows rationale dialogs only where needed; Android-only permissions are skipped on iOS.
class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();
  factory PermissionService() => instance;

  bool get _isAndroid => !kIsWeb && Platform.isAndroid;

  // ──────────────────────────────────────────────
  // Public API — startup permissions
  // ──────────────────────────────────────────────

  /// Request notification permission (Android 13+ / iOS).
  Future<void> requestNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.status;
    if (status.isGranted) return;

    if (status.isPermanentlyDenied) {
      await _showPermanentlyDeniedDialog(
        context,
        icon: Icons.notifications_active_rounded,
        permissionName: 'Notifications',
        reason:
            'Without notifications, you won\'t receive meal reminders. Enable them in Settings to stay on track.',
      );
      return;
    }

    final allowed = await _showRationaleDialog(
      context,
      icon: Icons.notifications_active_rounded,
      title: 'Stay on Track with Reminders',
      description:
          'EatWise sends meal reminders at your chosen times so you never miss a nutrition goal. No spam — only the alerts you set.',
    );
    if (allowed) await Permission.notification.request();
  }

  /// Request physical-activity + body-sensor permissions (Android only).
  /// On iOS, requests Apple Health step read access.
  Future<void> requestFitnessPermission(BuildContext context) async {
    if (kIsWeb) return;

    if (Platform.isIOS) {
      await requestAppleHealthPermission(context);
      return;
    }

    if (!_isAndroid) return;

    final actStatus = await Permission.activityRecognition.status;
    final sensorStatus = await Permission.sensors.status;
    if (actStatus.isGranted && sensorStatus.isGranted) return;

    if (actStatus.isPermanentlyDenied || sensorStatus.isPermanentlyDenied) {
      await _showPermanentlyDeniedDialog(
        context,
        icon: Icons.directions_walk_rounded,
        permissionName: 'Physical Activity & Sensors',
        reason:
            'Step counting and fitness tracking are disabled. Enable them in Settings to see your daily activity.',
      );
      return;
    }

    final allowed = await _showRationaleDialog(
      context,
      icon: Icons.directions_walk_rounded,
      title: 'Track Your Daily Activity',
      description:
          'EatWise uses your device\'s motion sensor to count steps and calculate calories burned — all processed on-device, never shared.',
    );
    if (allowed) {
      await Permission.activityRecognition.request();
      await Permission.sensors.request();
    }
  }

  /// Request Apple Health step read access (iOS only).
  /// Shows the in-app rationale dialog at most once; afterwards only the
  /// system Health permission sheet is used when needed.
  Future<void> requestAppleHealthPermission(BuildContext context) async {
    if (kIsWeb || !Platform.isIOS) return;

    final prefs = await SharedPreferences.getInstance();
    const key = 'health_rationale_shown_v1';
    final rationaleShown = prefs.getBool(key) ?? false;

    if (!rationaleShown) {
      if (!context.mounted) return;
      final allowed = await _showRationaleDialog(
        context,
        icon: Icons.directions_walk_rounded,
        title: 'Connect Apple Health',
        description:
            'EatWise reads your step count from Apple Health so your daily activity matches the Health app. Your data stays on your device.',
      );
      await prefs.setBool(key, true);
      if (!allowed) return;
    }

    await HealthStepService.instance.ensureAuthorized(requestIfNeeded: true);
  }

  /// Silent HealthKit auth — no UI. Used after login when rationale was shown.
  Future<void> ensureAppleHealthAuthorizedSilently() async {
    if (kIsWeb || !Platform.isIOS) return;
    await HealthStepService.instance.ensureAuthorized(requestIfNeeded: true);
  }

  // ──────────────────────────────────────────────
  // Public API — contextual permissions
  // ──────────────────────────────────────────────

  /// Request camera permission. Returns `true` if granted.
  Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      await _showPermanentlyDeniedDialog(
        context,
        icon: Icons.camera_alt_rounded,
        permissionName: 'Camera',
        reason:
            'Camera access is blocked. Enable it in Settings to scan food and log meals by photo.',
      );
      return false;
    }

    // iOS shows its own system dialog; skip the custom pre-prompt there.
    if (_isAndroid) {
      final allowed = await _showRationaleDialog(
        context,
        icon: Icons.camera_alt_rounded,
        title: 'Snap Your Meal',
        description:
            'EatWise uses the camera to photograph your food and instantly estimate calories and macros using AI.',
      );
      if (!allowed) return false;
    }

    final result = await Permission.camera.request();
    if (result.isPermanentlyDenied && context.mounted) {
      await _showPermanentlyDeniedDialog(
        context,
        icon: Icons.camera_alt_rounded,
        permissionName: 'Camera',
        reason:
            'Camera access is blocked. Enable it in Settings to scan food and log meals by photo.',
      );
    }
    return result.isGranted;
  }

  /// Request photo library permission. Returns `true` if granted.
  Future<bool> requestPhotoPermission(BuildContext context) async {
    final permission =
        _isAndroid ? Permission.storage : Permission.photos;
    final status = await permission.status;
    if (status.isGranted || status.isLimited) return true;

    if (status.isPermanentlyDenied) {
      await _showPermanentlyDeniedDialog(
        context,
        icon: Icons.photo_library_rounded,
        permissionName: 'Photo Library',
        reason:
            'Photo access is blocked. Enable it in Settings to pick images from your gallery.',
      );
      return false;
    }

    if (_isAndroid) {
      final allowed = await _showRationaleDialog(
        context,
        icon: Icons.photo_library_rounded,
        title: 'Pick from Your Gallery',
        description:
            'EatWise needs access to your photo library so you can select existing food photos to log meals quickly.',
      );
      if (!allowed) return false;
    }

    final result = await permission.request();
    if (result.isPermanentlyDenied && context.mounted) {
      await _showPermanentlyDeniedDialog(
        context,
        icon: Icons.photo_library_rounded,
        permissionName: 'Photo Library',
        reason:
            'Photo access is blocked. Enable it in Settings to pick images from your gallery.',
      );
    }
    return result.isGranted || result.isLimited;
  }

  // ──────────────────────────────────────────────
  // Private helpers
  // ──────────────────────────────────────────────

  /// Shows a pre-permission rationale dialog. Returns `true` if the user
  /// tapped "Allow", `false` if they tapped "Not Now".
  Future<bool> _showRationaleDialog(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final primary = FlutterFlowTheme.of(ctx).primary;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: primary, size: 36),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: FlutterFlowTheme.of(ctx).primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: FlutterFlowTheme.of(ctx).secondaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: Text('Allow',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(
                    'Not Now',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: FlutterFlowTheme.of(ctx).secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  /// Shows a "permission permanently denied" dialog that links to App Settings.
  Future<void> _showPermanentlyDeniedDialog(
    BuildContext context, {
    required IconData icon,
    required String permissionName,
    required String reason,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        final primary = FlutterFlowTheme.of(ctx).primary;
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.block_rounded,
                      color: Colors.redAccent, size: 36),
                ),
                const SizedBox(height: 20),
                Text(
                  '$permissionName Disabled',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: FlutterFlowTheme.of(ctx).primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  reason,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: FlutterFlowTheme.of(ctx).secondaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      openAppSettings();
                    },
                    child: Text('Open Settings',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: FlutterFlowTheme.of(ctx).secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
