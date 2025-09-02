import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum CommunicationType {
  announcement,
  teamUpdate,
  message,
  notification,
  event,
  news,
  policy,
  emergency,
  reminder,
  report
}

enum CommunicationPriority {
  low,
  normal,
  high,
  urgent
}

enum CommunicationStatus {
  draft,
  published,
  archived,
  deleted
}

class Communication {
  final String id;
  final String title;
  final String content;
  final CommunicationType type;
  final CommunicationPriority priority;
  final CommunicationStatus status;
  final String authorId;
  final String authorName;
  final String teamId;
  final List<String> recipients; // User IDs or 'all' for team-wide
  final List<String> tags;
  final Map<String, dynamic> metadata; // Additional data like event details, links, etc.
  final DateTime createdAt;
  final DateTime? publishedAt;
  final DateTime? expiresAt;
  final DateTime updatedAt;
  final bool requiresAcknowledgement;
  final List<String> acknowledgedBy; // User IDs who have acknowledged
  final List<String> attachments; // File URLs or references
  final int viewCount;
  final List<String> viewedBy; // User IDs who have viewed

  Communication({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.priority = CommunicationPriority.normal,
    this.status = CommunicationStatus.draft,
    required this.authorId,
    required this.authorName,
    required this.teamId,
    this.recipients = const ['all'],
    this.tags = const [],
    this.metadata = const {},
    required this.createdAt,
    this.publishedAt,
    this.expiresAt,
    required this.updatedAt,
    this.requiresAcknowledgement = false,
    this.acknowledgedBy = const [],
    this.attachments = const [],
    this.viewCount = 0,
    this.viewedBy = const [],
  });

  factory Communication.fromJson(Map<String, dynamic> json) {
    return Communication(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: CommunicationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => CommunicationType.announcement,
      ),
      priority: CommunicationPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => CommunicationPriority.normal,
      ),
      status: CommunicationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => CommunicationStatus.draft,
      ),
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      teamId: json['teamId'] ?? '',
      recipients: List<String>.from(json['recipients'] ?? ['all']),
      tags: List<String>.from(json['tags'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      publishedAt: json['publishedAt'] != null 
          ? (json['publishedAt'] as Timestamp).toDate() 
          : null,
      expiresAt: json['expiresAt'] != null 
          ? (json['expiresAt'] as Timestamp).toDate() 
          : null,
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      requiresAcknowledgement: json['requiresAcknowledgement'] ?? false,
      acknowledgedBy: List<String>.from(json['acknowledgedBy'] ?? []),
      attachments: List<String>.from(json['attachments'] ?? []),
      viewCount: json['viewCount'] ?? 0,
      viewedBy: List<String>.from(json['viewedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'authorId': authorId,
      'authorName': authorName,
      'teamId': teamId,
      'recipients': recipients,
      'tags': tags,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'publishedAt': publishedAt != null ? Timestamp.fromDate(publishedAt!) : null,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'requiresAcknowledgement': requiresAcknowledgement,
      'acknowledgedBy': acknowledgedBy,
      'attachments': attachments,
      'viewCount': viewCount,
      'viewedBy': viewedBy,
    };
  }

  Communication copyWith({
    String? id,
    String? title,
    String? content,
    CommunicationType? type,
    CommunicationPriority? priority,
    CommunicationStatus? status,
    String? authorId,
    String? authorName,
    String? teamId,
    List<String>? recipients,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? publishedAt,
    DateTime? expiresAt,
    DateTime? updatedAt,
    bool? requiresAcknowledgement,
    List<String>? acknowledgedBy,
    List<String>? attachments,
    int? viewCount,
    List<String>? viewedBy,
  }) {
    return Communication(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      teamId: teamId ?? this.teamId,
      recipients: recipients ?? this.recipients,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      publishedAt: publishedAt ?? this.publishedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      updatedAt: updatedAt ?? this.updatedAt,
      requiresAcknowledgement: requiresAcknowledgement ?? this.requiresAcknowledgement,
      acknowledgedBy: acknowledgedBy ?? this.acknowledgedBy,
      attachments: attachments ?? this.attachments,
      viewCount: viewCount ?? this.viewCount,
      viewedBy: viewedBy ?? this.viewedBy,
    );
  }

  // Helper methods
  bool get isPublished => status == CommunicationStatus.published;
  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isUrgent => priority == CommunicationPriority.urgent;
  bool get isHighPriority => priority == CommunicationPriority.high || priority == CommunicationPriority.urgent;
  bool get requiresResponse => requiresAcknowledgement && acknowledgedBy.isEmpty;
  
  String get displayType {
    switch (type) {
      case CommunicationType.announcement:
        return 'Announcement';
      case CommunicationType.teamUpdate:
        return 'Team Update';
      case CommunicationType.message:
        return 'Message';
      case CommunicationType.notification:
        return 'Notification';
      case CommunicationType.event:
        return 'Event';
      case CommunicationType.news:
        return 'News';
      case CommunicationType.policy:
        return 'Policy';
      case CommunicationType.emergency:
        return 'Emergency';
      case CommunicationType.reminder:
        return 'Reminder';
      case CommunicationType.report:
        return 'Report';
    }
  }

  IconData get displayIcon {
    switch (type) {
      case CommunicationType.announcement:
        return Icons.announcement;
      case CommunicationType.teamUpdate:
        return Icons.update;
      case CommunicationType.message:
        return Icons.message;
      case CommunicationType.notification:
        return Icons.notifications;
      case CommunicationType.event:
        return Icons.event;
      case CommunicationType.news:
        return Icons.newspaper;
      case CommunicationType.policy:
        return Icons.policy;
      case CommunicationType.emergency:
        return Icons.warning;
      case CommunicationType.reminder:
        return Icons.schedule;
      case CommunicationType.report:
        return Icons.assessment;
    }
  }
}

// Message-specific model for direct communications
class Message extends Communication {
  final String? replyToId;
  final List<String> ccRecipients;
  final bool isRead;
  final DateTime? readAt;

  Message({
    required super.id,
    required super.title,
    required super.content,
    required super.authorId,
    required super.authorName,
    required super.teamId,
    required super.recipients,
    this.replyToId,
    this.ccRecipients = const [],
    this.isRead = false,
    this.readAt,
    super.priority,
    super.status,
    super.tags,
    super.metadata,
    required super.createdAt,
    super.publishedAt,
    super.expiresAt,
    required super.updatedAt,
    super.requiresAcknowledgement,
    super.acknowledgedBy,
    super.attachments,
    super.viewCount,
    super.viewedBy,
  }) : super(type: CommunicationType.message);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      teamId: json['teamId'] ?? '',
      recipients: List<String>.from(json['recipients'] ?? []),
      replyToId: json['replyToId'],
      ccRecipients: List<String>.from(json['ccRecipients'] ?? []),
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'] != null 
          ? (json['readAt'] as Timestamp).toDate() 
          : null,
      priority: CommunicationPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => CommunicationPriority.normal,
      ),
      status: CommunicationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => CommunicationStatus.published,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      publishedAt: json['publishedAt'] != null 
          ? (json['publishedAt'] as Timestamp).toDate() 
          : null,
      expiresAt: json['expiresAt'] != null 
          ? (json['expiresAt'] as Timestamp).toDate() 
          : null,
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      requiresAcknowledgement: json['requiresAcknowledgement'] ?? false,
      acknowledgedBy: List<String>.from(json['acknowledgedBy'] ?? []),
      attachments: List<String>.from(json['attachments'] ?? []),
      viewCount: json['viewCount'] ?? 0,
      viewedBy: List<String>.from(json['viewedBy'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    baseJson.addAll({
      'replyToId': replyToId,
      'ccRecipients': ccRecipients,
      'isRead': isRead,
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
    });
    return baseJson;
  }
}
