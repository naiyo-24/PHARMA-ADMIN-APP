
enum DcrCreatedByType { mr, asm }

extension DcrCreatedByTypeX on DcrCreatedByType {
	String get label {
		switch (this) {
			case DcrCreatedByType.mr:
				return 'MR';
			case DcrCreatedByType.asm:
				return 'ASM';
		}
	}
}

enum DcrStatus { draft, submitted, approved, rejected }

extension DcrStatusX on DcrStatus {
	String get label {
		switch (this) {
			case DcrStatus.draft:
				return 'Draft';
			case DcrStatus.submitted:
				return 'Submitted';
			case DcrStatus.approved:
				return 'Approved';
			case DcrStatus.rejected:
				return 'Rejected';
		}
	}
}

class Dcr {
	const Dcr({
		required this.id,
		required this.createdByType,
		required this.createdById,
		required this.createdByName,
		required this.doctorName,
		required this.date,
		required this.status,
		required this.notes,
		required this.visualAdsPresented,
	});

	final String id;

	final DcrCreatedByType createdByType;
	final String createdById;
	final String createdByName;

	final String doctorName;

	final DateTime date;
	final DcrStatus status;

	final String notes;
	final List<String> visualAdsPresented;

	Dcr copyWith({
		String? id,
		DcrCreatedByType? createdByType,
		String? createdById,
		String? createdByName,
		String? doctorName,
		DateTime? date,
		DcrStatus? status,
		String? notes,
		List<String>? visualAdsPresented,
	}) {
		return Dcr(
			id: id ?? this.id,
			createdByType: createdByType ?? this.createdByType,
			createdById: createdById ?? this.createdById,
			createdByName: createdByName ?? this.createdByName,
			doctorName: doctorName ?? this.doctorName,
			date: date ?? this.date,
			status: status ?? this.status,
			notes: notes ?? this.notes,
			visualAdsPresented: visualAdsPresented ?? this.visualAdsPresented,
		);
	}
}
