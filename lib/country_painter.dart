import 'package:flutter/material.dart';
import 'dart:math';

class CountryPainter extends CustomPainter {
  final Map geometry; // Deve conter {"type": "Polygon" | "MultiPolygon", "coordinates": [...]}
  final Color color;

  CountryPainter(this.geometry, {this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (geometry.isEmpty || !geometry.containsKey('coordinates')) return;

    final coordinates = geometry['coordinates'];
    final type = geometry['type'];

    List<List<double>> allPoints = [];

    if (type == 'Polygon') {
      for (var ring in coordinates) {
        for (var point in ring) {
          if (point is List && point.length >= 2) {
            allPoints.add([
  (point[0] as num).toDouble(),
  (point[1] as num).toDouble(),
]);

          }
        }
      }
    } else if (type == 'MultiPolygon') {
      for (var polygon in coordinates) {
        for (var ring in polygon) {
          for (var point in ring) {
            if (point is List && point.length >= 2) {
              allPoints.add([
             (point[0] as num).toDouble(),
             (point[1] as num).toDouble(),
              ]);
            }
          }
        }
      }
    }

    if (allPoints.isEmpty) return;

    double minX = allPoints.first[0];
    double maxX = allPoints.first[0];
    double minY = allPoints.first[1];
    double maxY = allPoints.first[1];

    for (var pt in allPoints) {
      if (pt[0] < minX) minX = pt[0];
      if (pt[0] > maxX) maxX = pt[0];
      if (pt[1] < minY) minY = pt[1];
      if (pt[1] > maxY) maxY = pt[1];
    }

    final geoWidth = maxX - minX;
    final geoHeight = maxY - minY;
    final scale = 0.9 * min(size.width / geoWidth, size.height / geoHeight);
    final offsetX = (size.width - geoWidth * scale) / 2;
    final offsetY = (size.height - geoHeight * scale) / 2;

    Offset geoToPoint(List<double> coord) {
      double x = (coord[0] - minX) * scale + offsetX;
      double y = (maxY - coord[1]) * scale + offsetY;
      return Offset(x, y);
    }

    void drawPolygon(List ring) {
      for (int i = 0; i < ring.length; i++) {
        final raw = ring[i];
        final point = geoToPoint([
        (raw[0] as num).toDouble(),
        (raw[1] as num).toDouble(),
          ]);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
    }

    if (type == 'Polygon') {
      for (var ring in coordinates) {
        drawPolygon(ring);
      }
    } else if (type == 'MultiPolygon') {
      for (var polygon in coordinates) {
        for (var ring in polygon) {
          drawPolygon(ring);
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
