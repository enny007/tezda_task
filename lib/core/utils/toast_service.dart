import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastService {
  void showSuccessToast({
    required String title,
    required String message,
    AlignmentGeometry? alignment = Alignment.topCenter,
    Duration time = const Duration(seconds: 4),
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(message),
      alignment: alignment,
      autoCloseDuration: time,
      applyBlurEffect: false,
      showProgressBar: false,
      padding: EdgeInsets.only(
        bottom: 10.h,
        top: 10.h,
        left: 10.w,
        right: 10.w,
      ),
    );
  }

  void showErrorToast({
    required String title,
    required String message,
    AlignmentGeometry? alignment = Alignment.topCenter,
    Duration time = const Duration(seconds: 4),
  }) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(message),
      alignment: alignment,
      autoCloseDuration: time,
      applyBlurEffect: false,
      showProgressBar: false,
      padding: EdgeInsets.only(
        bottom: 10.h,
        top: 10.h,
        left: 10.w,
        right: 10.w,
      ),
    );
  }

  void showInfoToast({
    required String title,
    required String message,
    AlignmentGeometry? alignment = Alignment.topCenter,
    Duration time = const Duration(seconds: 4),
  }) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(message),
      alignment: alignment,
      autoCloseDuration: time,
      applyBlurEffect: false,
      showProgressBar: false,
      padding: EdgeInsets.only(
        bottom: 10.h,
        top: 10.h,
        left: 10.w,
        right: 10.w,
      ),
    );
  }

  void showWarningToast({
    required String title,
    required String message,
    AlignmentGeometry? alignment = Alignment.topCenter,
    Duration time = const Duration(seconds: 4),
  }) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(message),
      alignment: alignment,
      autoCloseDuration: time,
      applyBlurEffect: false,
      showProgressBar: false,
      padding: EdgeInsets.only(
        bottom: 10.h,
        top: 10.h,
        left: 10.w,
        right: 10.w,
      ),
    );
  }

  void showToast({
    required String title,
    required String message,
    required ToastificationType type,
    AlignmentGeometry? alignment = Alignment.topCenter,
    Duration time = const Duration(seconds: 4),
  }) {
    toastification.show(
      type: type,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(message),
      alignment: alignment,
      autoCloseDuration: time,
      applyBlurEffect: false,
      showProgressBar: false,
      padding: EdgeInsets.only(
        bottom: 10.h,
        top: 10.h,
        left: 10.w,
        right: 10.w,
      ),
    );
  }
}


final toastServiceProvider = Provider<ToastService>((ref) {
  return ToastService();
});
