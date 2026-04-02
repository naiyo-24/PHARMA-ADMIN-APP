
import 'dart:typed_data';

enum AttendanceSubjectType { mr, asm }

class AttendanceSubject {
	const AttendanceSubject({
		required this.id,
		required this.name,
		required this.type,
	});

	final String id;
	final String name;
	final AttendanceSubjectType type;

	String get label => type == AttendanceSubjectType.mr ? 'MR' : 'ASM';

	@override
	bool operator ==(Object other) {
		return identical(this, other) ||
				(other is AttendanceSubject && other.id == id && other.type == type);
	}

	@override
	int get hashCode => Object.hash(id, type);
}

class AttendanceGeoPoint {
	const AttendanceGeoPoint({required this.latitude, required this.longitude});

	final double latitude;
	final double longitude;
}

class AttendanceCheckpoint {
	const AttendanceCheckpoint({
		required this.at,
		required this.location,
		this.selfieBytes,
	});

	final DateTime at;
	final AttendanceGeoPoint location;
	final Uint8List? selfieBytes;
}

class AttendanceRecord {
	const AttendanceRecord({
		required this.id,
		required this.subjectType,
		required this.subjectId,
		required this.subjectName,
		required this.day,
		required this.checkIn,
		required this.checkOut,
	});

	final String id;
	final AttendanceSubjectType subjectType;
	final String subjectId;
	final String subjectName;

	/// Day stored as date-only (midnight local).
	final DateTime day;
	final AttendanceCheckpoint? checkIn;
	final AttendanceCheckpoint? checkOut;

	bool get hasCompleteDay => checkIn != null && checkOut != null;

	AttendanceRecord copyWith({
		String? id,
		AttendanceSubjectType? subjectType,
		String? subjectId,
		String? subjectName,
		DateTime? day,
		AttendanceCheckpoint? checkIn,
		AttendanceCheckpoint? checkOut,
	}) {
		return AttendanceRecord(
			id: id ?? this.id,
			subjectType: subjectType ?? this.subjectType,
			subjectId: subjectId ?? this.subjectId,
			subjectName: subjectName ?? this.subjectName,
			day: day ?? this.day,
			checkIn: checkIn ?? this.checkIn,
			checkOut: checkOut ?? this.checkOut,
		);
	}
}

DateTime attendanceDayOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

