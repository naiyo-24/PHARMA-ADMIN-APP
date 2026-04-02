
import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';

import '../../models/team_management.dart';
import '../../notifiers/team_management_notifier.dart';
import '../../routes/app_router.dart';
import '../../utils/attachment_playback.dart';
import '../../utils/video_controller_factory.dart';

class TeamChatRoomScreen extends ConsumerStatefulWidget {
	const TeamChatRoomScreen({super.key, required this.teamId});

	final String teamId;

	@override
	ConsumerState<TeamChatRoomScreen> createState() =>
			_TeamChatRoomScreenState();
}

class _TeamChatRoomScreenState extends ConsumerState<TeamChatRoomScreen> {
	final _messageCtrl = TextEditingController();

	final AudioRecorder _recorder = AudioRecorder();
	StreamSubscription<Uint8List>? _recordSub;
	final List<int> _recordedBytes = <int>[];
	final Stopwatch _stopwatch = Stopwatch();
	Timer? _timer;

	bool _isRecording = false;
	int _recordDurationMs = 0;

	@override
	void dispose() {
		_timer?.cancel();
		_stopwatch.stop();
		_recordSub?.cancel();
		_recorder.dispose();
		_messageCtrl.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final teamsAsync = ref.watch(teamManagementNotifierProvider);
		final team = teamsAsync.maybeWhen(
			data: (items) => items.where((t) => t.id == widget.teamId).firstOrNull,
			orElse: () => null,
		);

		final membersCount = team?.memberCount ?? 0;

		return Scaffold(
			appBar: AppBar(
				elevation: 0,
				scrolledUnderElevation: 0,
				backgroundColor: Theme.of(context).colorScheme.surface,
				surfaceTintColor: Colors.transparent,
				leading: IconButton(
					tooltip: 'Back',
					onPressed: () => context.pop(),
					icon: const Icon(Icons.arrow_back_rounded),
				),
				title: InkWell(
					onTap: (team == null)
							? null
							: () => context.goNamed(
										AppRoutes.teamDetails,
										pathParameters: {'teamId': widget.teamId},
									),
					borderRadius: BorderRadius.circular(12),
					child: Padding(
						padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							mainAxisSize: MainAxisSize.min,
							children: [
								Text(
									team?.name ?? 'Team chat',
									maxLines: 1,
									overflow: TextOverflow.ellipsis,
									style: Theme.of(context).textTheme.titleMedium?.copyWith(
												fontWeight: FontWeight.w900,
												letterSpacing: -0.2,
											),
								),
								const SizedBox(height: 2),
								Text(
									'$membersCount members',
									style: Theme.of(context).textTheme.bodySmall?.copyWith(
												color: Theme.of(context)
														.colorScheme
														.onSurface
														.withAlpha(160),
												fontWeight: FontWeight.w800,
											),
								),
							],
						),
					),
				),
			),
			body: SafeArea(
				child: teamsAsync.when(
					data: (_) {
						if (team == null) {
							return const Center(child: Text('Team not found.'));
						}

						final messages = [...team.messages]
							..sort((a, b) => a.sentAt.compareTo(b.sentAt));

						return Column(
							children: [
								Expanded(
									child: ListView.builder(
										padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
										itemCount: messages.length,
										itemBuilder: (context, index) {
											final m = messages[index];
											final isAdmin = m.senderType == TeamMessageSenderType.admin;
											return Padding(
												padding: const EdgeInsets.symmetric(vertical: 6),
												child: _MessageBubble(
													message: m,
													isAdmin: isAdmin,
													onPlayAttachment: (attachment) => _playAttachment(
														messageId: m.id,
														attachment: attachment,
													),
												),
											);
										},
									),
								),
								_ComposerBar(
									controller: _messageCtrl,
									isRecording: _isRecording,
									recordDurationMs: _recordDurationMs,
									onAttachImage: _attachImage,
									onAttachVideo: _attachVideo,
									onAttachFile: _attachFile,
									onToggleRecord: _toggleRecord,
									onSend: _sendText,
								),
							],
						);
					},
					loading: () => const Center(child: CircularProgressIndicator()),
					error: (e, _) => const Center(child: Text('Failed to load team chat.')),
				),
			),
		);
	}

	Future<void> _sendText() async {
		final text = _messageCtrl.text.trim();
		if (text.isEmpty) return;
		_messageCtrl.clear();
		await ref
				.read(teamManagementNotifierProvider.notifier)
				.sendAdminTextMessage(teamId: widget.teamId, text: text);
	}

	Future<void> _attachImage() async {
		final source = await _pickSourceSheet('Image');
		if (source == null) return;
		final picker = ImagePicker();
		final file = await picker.pickImage(source: source, imageQuality: 88);
		if (file == null) return;
		final bytes = await file.readAsBytes();
		final attachment = TeamMessageAttachment(
			type: TeamMessageAttachmentType.image,
			bytes: bytes,
			fileName: file.name.isEmpty
					? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg'
					: file.name,
			mimeType: 'image/*',
		);
		await ref
				.read(teamManagementNotifierProvider.notifier)
				.sendAdminAttachmentMessage(teamId: widget.teamId, attachment: attachment);
	}

	Future<void> _attachVideo() async {
		final source = await _pickSourceSheet('Video');
		if (source == null) return;
		final picker = ImagePicker();
		final file = await picker.pickVideo(source: source);
		if (file == null) return;
		final bytes = await file.readAsBytes();
		final attachment = TeamMessageAttachment(
			type: TeamMessageAttachmentType.video,
			bytes: bytes,
			fileName: file.name.isEmpty
					? 'video_${DateTime.now().millisecondsSinceEpoch}.mp4'
					: file.name,
			mimeType: 'video/*',
		);
		await ref
				.read(teamManagementNotifierProvider.notifier)
				.sendAdminAttachmentMessage(teamId: widget.teamId, attachment: attachment);
	}

	Future<void> _attachFile() async {
		final result = await FilePicker.platform.pickFiles(withData: true);
		if (result == null) return;
		final file = result.files.firstOrNull;
		if (file == null) return;
		final bytes = file.bytes;
		if (bytes == null) {
			if (!mounted) return;
			ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(content: Text('Unable to read selected file.')),
			);
			return;
		}

		final attachment = TeamMessageAttachment(
			type: TeamMessageAttachmentType.file,
			bytes: bytes,
			fileName: file.name,
			mimeType: file.extension,
		);
		await ref
				.read(teamManagementNotifierProvider.notifier)
				.sendAdminAttachmentMessage(teamId: widget.teamId, attachment: attachment);
	}

	Future<ImageSource?> _pickSourceSheet(String label) async {
		return showModalBottomSheet<ImageSource>(
			context: context,
			showDragHandle: true,
			builder: (context) {
				final theme = Theme.of(context);
				return SafeArea(
					child: Padding(
						padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								ListTile(
									leading: Icon(
										Icons.camera_alt_rounded,
										color: theme.colorScheme.primary,
									),
									title: Text('Camera $label'),
									onTap: () => Navigator.of(context).pop(ImageSource.camera),
								),
								ListTile(
									leading: Icon(
										Icons.photo_library_rounded,
										color: theme.colorScheme.primary,
									),
									title: Text('Gallery $label'),
									onTap: () => Navigator.of(context).pop(ImageSource.gallery),
								),
							],
						),
					),
				);
			},
		);
	}

	Future<void> _toggleRecord() async {
		if (_isRecording) {
			await _stopRecordingAndSend();
			return;
		}

		final hasPermission = await _recorder.hasPermission();
		if (!hasPermission) {
			if (!mounted) return;
			ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(content: Text('Microphone permission is required.')),
			);
			return;
		}

		_recordedBytes.clear();
		_recordDurationMs = 0;
		_stopwatch
			..reset()
			..start();
		_timer?.cancel();
		_timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
			if (!mounted) return;
			setState(() => _recordDurationMs = _stopwatch.elapsedMilliseconds);
		});

		final stream = await _recorder.startStream(
			const RecordConfig(
				encoder: AudioEncoder.pcm16bits,
				numChannels: 1,
				sampleRate: 16000,
			),
		);
		_recordSub?.cancel();
		_recordSub = stream.listen((chunk) {
			_recordedBytes.addAll(chunk);
		});

		if (!mounted) return;
		setState(() => _isRecording = true);
	}

	Future<void> _stopRecordingAndSend() async {
		_timer?.cancel();
		_stopwatch.stop();
		await _recordSub?.cancel();
		await _recorder.stop();

		final pcmBytes = Uint8List.fromList(_recordedBytes);
		final durationMs = _recordDurationMs;

		if (!mounted) return;
		setState(() {
			_isRecording = false;
			_recordDurationMs = 0;
		});

		if (pcmBytes.isEmpty) return;
		final bytes = _encodeWavPcm16(
			pcmBytes: pcmBytes,
			sampleRate: 16000,
			numChannels: 1,
		);
		final attachment = TeamMessageAttachment(
			type: TeamMessageAttachmentType.voice,
			bytes: bytes,
			fileName: 'voice_${DateTime.now().millisecondsSinceEpoch}.wav',
			mimeType: 'audio/wav',
			durationMs: durationMs,
		);
		await ref
				.read(teamManagementNotifierProvider.notifier)
				.sendAdminAttachmentMessage(teamId: widget.teamId, attachment: attachment);
	}

	Future<void> _playAttachment({
		required String messageId,
		required TeamMessageAttachment attachment,
	}) async {
		if (attachment.bytes.isEmpty) return;
		if (attachment.type == TeamMessageAttachmentType.image) return;
		if (attachment.type == TeamMessageAttachmentType.file) return;

		final mimeType = switch (attachment.type) {
			TeamMessageAttachmentType.video => attachment.mimeType ?? 'video/*',
			TeamMessageAttachmentType.voice => attachment.mimeType ?? 'audio/*',
			_ => attachment.mimeType,
		};

		final handle = await createAttachmentPlaybackHandle(
			bytes: attachment.bytes,
			fileName: '${messageId}_${attachment.fileName}',
			mimeType: mimeType,
		);
		if (!mounted) {
			await handle.dispose();
			return;
		}

		try {
			switch (attachment.type) {
				case TeamMessageAttachmentType.video:
					await showModalBottomSheet<void>(
						context: context,
						showDragHandle: true,
						isScrollControlled: true,
						builder: (context) => _VideoPlayerSheet(uri: handle.uri),
					);
					break;
				case TeamMessageAttachmentType.voice:
					await showModalBottomSheet<void>(
						context: context,
						showDragHandle: true,
						builder: (context) => _AudioPlayerSheet(uri: handle.uri),
					);
					break;
				case TeamMessageAttachmentType.image:
				case TeamMessageAttachmentType.file:
					break;
			}
		} finally {
			await handle.dispose();
		}
	}
}

Uint8List _encodeWavPcm16({
	required Uint8List pcmBytes,
	required int sampleRate,
	required int numChannels,
}) {
	const bitsPerSample = 16;
	final byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
	final blockAlign = numChannels * (bitsPerSample ~/ 8);
	final dataLength = pcmBytes.length;
	final fileLength = 44 + dataLength;

	final header = ByteData(44);
	int o = 0;

	void writeString(String s) {
		for (final unit in s.codeUnits) {
			header.setUint8(o++, unit);
		}
	}

	writeString('RIFF');
	header.setUint32(o, fileLength - 8, Endian.little);
	o += 4;
	writeString('WAVE');
	writeString('fmt ');
	header.setUint32(o, 16, Endian.little);
	o += 4;
	header.setUint16(o, 1, Endian.little);
	o += 2;
	header.setUint16(o, numChannels, Endian.little);
	o += 2;
	header.setUint32(o, sampleRate, Endian.little);
	o += 4;
	header.setUint32(o, byteRate, Endian.little);
	o += 4;
	header.setUint16(o, blockAlign, Endian.little);
	o += 2;
	header.setUint16(o, bitsPerSample, Endian.little);
	o += 2;
	writeString('data');
	header.setUint32(o, dataLength, Endian.little);

	final out = Uint8List(fileLength);
	out.setRange(0, 44, header.buffer.asUint8List());
	out.setRange(44, fileLength, pcmBytes);
	return out;
}

class _ComposerBar extends StatelessWidget {
	const _ComposerBar({
		required this.controller,
		required this.isRecording,
		required this.recordDurationMs,
		required this.onAttachImage,
		required this.onAttachVideo,
		required this.onAttachFile,
		required this.onToggleRecord,
		required this.onSend,
	});

	final TextEditingController controller;
	final bool isRecording;
	final int recordDurationMs;
	final VoidCallback onAttachImage;
	final VoidCallback onAttachVideo;
	final VoidCallback onAttachFile;
	final VoidCallback onToggleRecord;
	final VoidCallback onSend;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);
		final surface = theme.colorScheme.surface;

		String? recordingLabel;
		if (isRecording) {
			final seconds = (recordDurationMs / 1000).floor();
			recordingLabel = 'Recording… 0:${seconds.toString().padLeft(2, '0')}';
		}

		return Container(
			padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
			decoration: BoxDecoration(
				color: surface,
				border: Border(top: BorderSide(color: outline)),
			),
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					if (recordingLabel != null)
						Padding(
							padding: const EdgeInsets.only(bottom: 8),
							child: Row(
								children: [
									Icon(Icons.mic_rounded, color: theme.colorScheme.error),
									const SizedBox(width: 8),
									Text(
										recordingLabel,
										style: theme.textTheme.bodySmall?.copyWith(
											color: theme.colorScheme.onSurface.withAlpha(180),
											fontWeight: FontWeight.w800,
										),
									),
								],
							),
						),
					Row(
						children: [
							IconButton(
								tooltip: 'Attach image',
								onPressed: onAttachImage,
								icon: const Icon(Icons.image_rounded),
							),
							IconButton(
								tooltip: 'Attach video',
								onPressed: onAttachVideo,
								icon: const Icon(Icons.videocam_rounded),
							),
							IconButton(
								tooltip: 'Attach file',
								onPressed: onAttachFile,
								icon: const Icon(Icons.attach_file_rounded),
							),
							IconButton(
								tooltip: isRecording ? 'Stop recording' : 'Record voice',
								onPressed: onToggleRecord,
								icon: Icon(
									isRecording ? Icons.stop_circle_rounded : Icons.mic_rounded,
									color: isRecording
											? theme.colorScheme.error
											: theme.colorScheme.onSurface,
								),
							),
							const SizedBox(width: 6),
							Expanded(
								child: TextField(
									controller: controller,
									decoration: const InputDecoration(
										hintText: 'Type a message…',
									),
								),
							),
							const SizedBox(width: 10),
							FilledButton(
								onPressed: onSend,
								child: const Text('Send'),
							),
						],
					),
				],
			),
		);
	}
}

class _MessageBubble extends StatelessWidget {
	const _MessageBubble({
		required this.message,
		required this.isAdmin,
		required this.onPlayAttachment,
	});

	final TeamChatMessage message;
	final bool isAdmin;
	final ValueChanged<TeamMessageAttachment> onPlayAttachment;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final bg = isAdmin
				? theme.colorScheme.primary.withAlpha(24)
				: theme.colorScheme.surfaceContainerHighest;
		final border = isAdmin
				? theme.colorScheme.primary.withAlpha(90)
				: theme.colorScheme.outline.withAlpha(90);

		return Align(
			alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
			child: ConstrainedBox(
				constraints: const BoxConstraints(maxWidth: 520),
				child: DecoratedBox(
					decoration: BoxDecoration(
						color: bg,
						borderRadius: BorderRadius.circular(18),
						border: Border.all(color: border),
					),
					child: Padding(
						padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
						child: Column(
							crossAxisAlignment:
									isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
							children: [
								if (!isAdmin)
									Padding(
										padding: const EdgeInsets.only(bottom: 6),
										child: Text(
											message.senderName,
											style: theme.textTheme.labelLarge?.copyWith(
												fontWeight: FontWeight.w900,
												color: theme.colorScheme.onSurface.withAlpha(180),
											),
										),
									),
								if (message.text != null && message.text!.trim().isNotEmpty)
									Text(
										message.text!,
										style: theme.textTheme.bodyMedium?.copyWith(
											fontWeight: FontWeight.w700,
											height: 1.35,
										),
									),
								if (message.attachment != null) ...[
									if (message.text != null && message.text!.trim().isNotEmpty)
										const SizedBox(height: 10),
									_AttachmentView(
										attachment: message.attachment!,
										onPlay: (message.attachment!.type ==
													TeamMessageAttachmentType.video ||
													message.attachment!.type ==
															TeamMessageAttachmentType.voice)
											? () => onPlayAttachment(message.attachment!)
											: null,
									),
								],
							],
						),
					),
				),
			),
		);
	}
}

class _AttachmentView extends StatelessWidget {
	const _AttachmentView({required this.attachment, required this.onPlay});

	final TeamMessageAttachment attachment;
	final VoidCallback? onPlay;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		switch (attachment.type) {
			case TeamMessageAttachmentType.image:
				return ClipRRect(
					borderRadius: BorderRadius.circular(14),
					child: Image.memory(
						attachment.bytes,
						width: 260,
						height: 160,
						fit: BoxFit.cover,
					),
				);
			case TeamMessageAttachmentType.video:
				return InkWell(
					onTap: onPlay,
					borderRadius: BorderRadius.circular(14),
					child: _FileLikeAttachment(
						icon: Icons.videocam_rounded,
						label: attachment.fileName,
						outline: outline,
						trailing: Icon(
							Icons.play_circle_fill_rounded,
							color: theme.colorScheme.primary,
						),
					),
				);
			case TeamMessageAttachmentType.file:
				return _FileLikeAttachment(
					icon: Icons.insert_drive_file_rounded,
					label: attachment.fileName,
					outline: outline,
				);
			case TeamMessageAttachmentType.voice:
				final duration = attachment.durationMs ?? 0;
				final seconds = (duration / 1000).round();
				return InkWell(
					onTap: onPlay,
					borderRadius: BorderRadius.circular(14),
					child: _FileLikeAttachment(
						icon: Icons.mic_rounded,
						label: seconds > 0
								? 'Voice message • 0:${seconds.toString().padLeft(2, '0')}'
								: 'Voice message',
						outline: outline,
						trailing: Icon(
							Icons.play_circle_fill_rounded,
							color: theme.colorScheme.primary,
						),
					),
				);
		}
	}
}

class _FileLikeAttachment extends StatelessWidget {
	const _FileLikeAttachment({
		required this.icon,
		required this.label,
		required this.outline,
		this.trailing,
	});

	final IconData icon;
	final String label;
	final Color outline;
	final Widget? trailing;

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(14),
				border: Border.all(color: outline),
				color: theme.colorScheme.surface,
			),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Icon(icon, color: theme.colorScheme.primary),
					const SizedBox(width: 10),
					Flexible(
						child: Text(
							label,
							maxLines: 1,
							overflow: TextOverflow.ellipsis,
							style: theme.textTheme.bodySmall?.copyWith(
								fontWeight: FontWeight.w900,
							),
						),
					),
					if (trailing != null) ...[
						const SizedBox(width: 10),
						trailing!,
					],
				],
			),
		);
	}
}

class _AudioPlayerSheet extends StatefulWidget {
	const _AudioPlayerSheet({required this.uri});

	final Uri uri;

	@override
	State<_AudioPlayerSheet> createState() => _AudioPlayerSheetState();
}

class _AudioPlayerSheetState extends State<_AudioPlayerSheet> {
	final AudioPlayer _player = AudioPlayer();
	bool _loading = true;

	@override
	void initState() {
		super.initState();
		unawaited(_init());
	}

	Future<void> _init() async {
		try {
			await _player.setAudioSource(AudioSource.uri(widget.uri));
		} finally {
			if (!mounted) return;
			setState(() => _loading = false);
		}
	}

	@override
	void dispose() {
		_player.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return SafeArea(
			child: Padding(
				padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
				child: Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							'Voice message',
							style: theme.textTheme.titleMedium?.copyWith(
								fontWeight: FontWeight.w900,
							),
						),
						const SizedBox(height: 12),
						if (_loading)
							const Padding(
								padding: EdgeInsets.symmetric(vertical: 12),
								child: Center(child: CircularProgressIndicator()),
							)
						else
							Row(
								children: [
									StreamBuilder<PlayerState>(
										stream: _player.playerStateStream,
										builder: (context, snap) {
											final playing = snap.data?.playing ?? false;
											final processing = snap.data?.processingState;
											final ended = processing == ProcessingState.completed;
											return IconButton.filled(
												onPressed: () async {
												if (ended) {
													await _player.seek(Duration.zero);
													await _player.play();
													return;
												}
												if (playing) {
													await _player.pause();
												} else {
													await _player.play();
												}
											},
											icon: Icon(
												playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
											),
										);
									},
									),
									const SizedBox(width: 12),
									Expanded(
										child: StreamBuilder<Duration>(
											stream: _player.positionStream,
											builder: (context, snap) {
												final pos = snap.data ?? Duration.zero;
												String two(int n) => n.toString().padLeft(2, '0');
												final mm = two(pos.inMinutes.remainder(60));
												final ss = two(pos.inSeconds.remainder(60));
												return Text(
												'$mm:$ss',
												style: theme.textTheme.bodySmall?.copyWith(
													fontWeight: FontWeight.w900,
													color:
														theme.colorScheme.onSurface.withAlpha(170),
												),
											);
										},
									),
								),
								],
							),
					],
				),
			),
		);
	}
}

class _VideoPlayerSheet extends StatefulWidget {
	const _VideoPlayerSheet({required this.uri});

	final Uri uri;

	@override
	State<_VideoPlayerSheet> createState() => _VideoPlayerSheetState();
}

class _VideoPlayerSheetState extends State<_VideoPlayerSheet> {
	late final VideoPlayerController _controller;
	bool _loading = true;

	@override
	void initState() {
		super.initState();
		_controller = createVideoController(widget.uri);
		unawaited(_init());
	}

	Future<void> _init() async {
		try {
			await _controller.initialize();
		} finally {
			if (!mounted) return;
			setState(() => _loading = false);
		}
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final outline = theme.colorScheme.outline.withAlpha(102);

		return SafeArea(
			child: Padding(
				padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
				child: Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							'Video',
							style: theme.textTheme.titleMedium?.copyWith(
								fontWeight: FontWeight.w900,
							),
						),
						const SizedBox(height: 12),
						DecoratedBox(
							decoration: BoxDecoration(
								borderRadius: BorderRadius.circular(16),
								border: Border.all(color: outline),
								color: theme.colorScheme.surface,
							),
							child: ClipRRect(
								borderRadius: BorderRadius.circular(16),
								child: AspectRatio(
									aspectRatio:
										_loading ? (16 / 9) : _controller.value.aspectRatio,
									child: Stack(
										alignment: Alignment.center,
										children: [
											if (_loading)
												const Center(child: CircularProgressIndicator())
											else
												VideoPlayer(_controller),
											if (!_loading)
												ValueListenableBuilder<VideoPlayerValue>(
													valueListenable: _controller,
													builder: (context, value, _) {
														final isPlaying = value.isPlaying;
														return IconButton.filled(
														onPressed: () async {
															if (isPlaying) {
																await _controller.pause();
															} else {
																await _controller.play();
															}
															if (!mounted) return;
															setState(() {});
														},
														icon: Icon(
															isPlaying
																? Icons.pause_rounded
																: Icons.play_arrow_rounded,
														),
													);
													},
												)
										],
									),
								),
							),
						),
					],
				),
			),
		);
	}
}

extension FirstOrNullX<T> on Iterable<T> {
	T? get firstOrNull => isEmpty ? null : first;
}

