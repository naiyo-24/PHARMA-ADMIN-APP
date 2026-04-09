import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cards/doctor/doctor_chamber_card.dart';
import '../../cards/doctor/doctor_contact_card.dart';
import '../../cards/doctor/doctor_education_card.dart';
import '../../cards/doctor/doctor_experience_card.dart';
import '../../cards/doctor/doctor_header_card.dart';
import '../../models/doctor.dart';
import '../../notifiers/doctor_notifier.dart';
import '../../routes/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class DoctorDetailScreen extends ConsumerWidget {
  const DoctorDetailScreen({super.key, required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final padding = AppLayout.pagePadding(context);
    final listAsync = ref.watch(doctorNotifierProvider);

    return Scaffold(
      appBar: const AppAppBar(
        showLogo: false,
        title: 'Doctor',
        subtitle: 'Details',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: listAsync.when(
                data: (items) {
                  Doctor? doctor;
                  try {
                    doctor = items.firstWhere((d) => d.id == doctorId);
                  } catch (_) {
                    doctor = null;
                  }

                  if (doctor == null) {
                    return const _ErrorCard(message: 'Doctor not found.');
                  }

                  final d = doctor;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DoctorHeaderCard(
                        photoPath: d.photoPath,
                        photoBytes: d.photoBytes,
                        doctorName: d.name,
                        addedByLabel:
                            'Added by ${d.addedByType.label}: ${d.addedByName}',
                        onEdit: () => context.goNamed(
                          AppRoutes.editDoctor,
                          pathParameters: {'doctorId': d.id},
                        ),
                        onDelete: () async {
                          await ref
                              .read(doctorNotifierProvider.notifier)
                              .delete(d.id);
                          if (!context.mounted) return;
                          context.goNamed(AppRoutes.doctorManagement);
                        },
                      ),
                      const SizedBox(height: 12),
                      DoctorEducationCard(
                        description: d.description,
                        degrees: d.degrees,
                      ),
                      const SizedBox(height: 12),
                      DoctorExperienceCard(
                        degrees: d.degrees,
                        experience: d.experience,
                      ),
                      const SizedBox(height: 12),
                      DoctorChamberCard(chambers: d.chambers),
                      const SizedBox(height: 12),
                      DoctorContactCard(
                        phoneNumber: d.phoneNumber,
                        email: d.email,
                        address: d.address,
                      ),
                      const SizedBox(height: 92),
                    ],
                  );
                },
                loading: () => _LoadingCard(theme: theme),
                error: (e, _) =>
                    const _ErrorCard(message: 'Failed to load doctor details.'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final outline = theme.colorScheme.outline.withAlpha(204);
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: const Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Loading details...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outline.withAlpha(204);
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
