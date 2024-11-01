import 'package:film_log/fmt/aperture.dart';
import 'package:film_log/fmt/shutterspeed.dart';
import 'package:film_log/fmt/timestamp.dart';
import 'package:film_log/model/equals.dart';
import 'package:film_log/model/gear.dart';
import 'package:film_log/model/json.dart';
import 'package:film_log/model/thumbnail.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/v4.dart';

import 'filter.dart';
import 'lens.dart';
import 'location.dart';

class Photo implements ToJson, Equals<Photo> {
  final String id;
  final DateTime timestamp;
  final int frameNumber;

  /// [shutter] is the shutter speed in seconds
  final double? shutter;
  final double? aperture;
  final List<Filter> filters;
  final Lens? lens;
  final Location? location;
  final String? notes;
  final Thumbnail? thumbnail;

  Photo({
    required this.id,
    required this.timestamp,
    required this.frameNumber,
    required this.shutter,
    required this.aperture,
    required this.filters,
    required this.lens,
    required this.location,
    required this.notes,
    required this.thumbnail,
  });

  @override
  bool equals(Photo other) =>
      id == other.id &&
      timestamp.isAtSameMomentAs(other.timestamp) &&
      frameNumber == other.frameNumber &&
      shutter == other.shutter &&
      aperture == other.aperture &&
      Equals.all(filters, other.filters) &&
      Equals.orNull(lens, other.lens) &&
      Equals.orNull(location, other.location) &&
      notes == other.notes &&
      Equals.orNull(thumbnail, other.thumbnail);

  String listItemSubtitle(BuildContext context,
          {List<Photo> photos = const []}) =>
      [
        formatTimestamp(
          context,
          timestamp,
          values: photos.map((item) => item.timestamp).toList(growable: false),
        ),
        if (shutter != null) formatShutterSpeed(shutter!),
        if (aperture != null) formatAperture(aperture!),
      ].join(' ');

  Photo update({
    String? id,
    DateTime? timestamp,
    int? frameNumber,
    double? shutter,
    double? aperture,
    List<Filter>? filters,
    Lens? lens,
    Location? location,
    String? notes,
    Thumbnail? thumbnail,
  }) =>
      Photo(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        frameNumber: frameNumber ?? this.frameNumber,
        shutter: shutter ?? this.shutter,
        aperture: aperture ?? this.aperture,
        filters: filters ?? this.filters,
        lens: lens ?? this.lens,
        location: location ?? this.location,
        notes: notes ?? this.notes,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  Photo ensureId() =>
      id.isNotEmpty ? this : update(id: const UuidV4().generate());

  Photo updateLocation(Location? value) => Photo(
        id: id,
        timestamp: timestamp,
        frameNumber: frameNumber,
        shutter: shutter,
        aperture: aperture,
        filters: filters,
        lens: lens,
        location: value,
        notes: notes,
        thumbnail: thumbnail,
      );

  Photo updateThumbnail(Thumbnail? thumbnail) => Photo(
        id: id,
        timestamp: timestamp,
        frameNumber: frameNumber,
        shutter: shutter,
        aperture: aperture,
        filters: filters,
        lens: lens,
        location: location,
        notes: notes,
        thumbnail: thumbnail,
      );

  factory Photo.createNew(
    int frameNumber, {
    double? shutter,
    double? aperture,
    List<Filter>? filters,
    Lens? lens,
    Location? location,
  }) =>
      Photo(
        id: const UuidV4().generate(),
        timestamp: DateTime.timestamp().toUtc(),
        frameNumber: frameNumber,
        shutter: shutter,
        aperture: aperture,
        filters: filters ?? [],
        lens: lens,
        location: location,
        notes: null,
        thumbnail: null,
      );

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    required List<Filter> filters,
    required List<Lens> lenses,
  }) =>
      Photo(
        id: json['id'],
        timestamp: DateTime.parse(json['timestamp']),
        frameNumber: json['frameNumber'],
        shutter: json['shutter'],
        aperture: json['aperture'],
        filters: Gear.fromIdList(json['filters'], filters),
        lens: Gear.byId(json['lens'], lenses),
        location: FromJson.orNull(json['location'], Location.fromJson),
        notes: json['notes'],
        thumbnail: FromJson.orNull(json['thumbnail'], Thumbnail.fromJson),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'frameNumber': frameNumber,
        if (shutter != null) 'shutter': shutter,
        if (aperture != null) 'aperture': aperture,
        if (filters.isNotEmpty)
          'filters': filters.map((f) => f.id).toList(growable: false),
        if (lens != null) 'lens': lens!.id,
        if (location != null) 'location': location!.toJson(),
        if (notes != null) 'notes': notes,
        if (thumbnail != null) 'thumbnail': thumbnail!.toJson(),
      };

  Map<String, dynamic> toJsonExport() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'frameNumber': frameNumber,
        if (shutter != null) 'shutter': shutter,
        if (aperture != null) 'aperture': aperture,
        if (filters.isNotEmpty)
          'filters': filters.map((f) => f.toJson()).toList(growable: false),
        if (lens != null) 'lens': lens!.toJson(),
        if (location != null) 'location': location!.toJson(),
        if (notes != null) 'notes': notes,
        if (thumbnail != null) 'thumbnail': thumbnail!.toJson(),
      };
}
