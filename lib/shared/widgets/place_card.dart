import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_constants.dart';
import 'c_text.dart';

class PlaceCard extends StatelessWidget {
  final String title;
  final String address;
  final double rating;
  final String imagePath; 
  final bool isOpen;

  const PlaceCard({
    super.key,
    required this.title,
    required this.address,
    required this.rating,
    required this.imagePath,
    this.isOpen = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(Icons.image_outlined, color: AppColors.grey400),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CText(
                          text: title,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 16),
                            SizedBox(width: 4.w),
                            CText(
                              text: rating.toString(),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.primary),
                        SizedBox(width: 4.w),
                        CText(
                          text: address,
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildTag("Noise: 2/5", Colors.green),
              _buildTag("Crowd: 1/5", Colors.blue),
              _buildTag("Light: 2/5", AppColors.kpurple),
            ],
          ),
          // SizedBox(height: 8.h),
          // Row(
          //   children: [
          //     _buildStatusItem(Icons.check_circle, "Staff Friend", Colors.green),
          //     SizedBox(width: 12.w),
          //     _buildStatusItem(Icons.check_circle, "Quiet", Colors.blue),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: CText(
        text: text,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        SizedBox(width: 4.w),
        CText(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ],
    );
  }
}
