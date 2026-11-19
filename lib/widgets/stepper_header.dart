import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StepperHeader extends StatelessWidget {
  final int currentStep; // 1: Add Plan, 2: Add Member, 3: View Dashboard

  const StepperHeader({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepCircle(1, currentStep >= 1),
              _buildStepLine(currentStep >= 2),
              _buildStepCircle(2, currentStep >= 2),
              _buildStepLine(currentStep >= 3),
              _buildStepCircle(3, currentStep >= 3),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel('Add Plan', currentStep == 1),
              _buildStepLabel('Add Member', currentStep == 2),
              _buildStepLabel('View Dashboard', currentStep == 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, bool isActive) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primaryTeal : Colors.transparent,
        border: Border.all(
          color: isActive ? AppColors.primaryTeal : AppColors.border,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textMuted,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isActive ? AppColors.primaryTeal : AppColors.borderLight,
      ),
    );
  }

  Widget _buildStepLabel(String label, bool isCurrent) {
    return SizedBox(
      width: 95,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
          color: isCurrent ? AppColors.primaryTeal : AppColors.textSecondary,
        ),
      ),
    );
  }
}
