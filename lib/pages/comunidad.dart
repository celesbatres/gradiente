// lib/pages/comunidad_page.dart
import 'package:flutter/material.dart';

class ComunidadPage extends StatelessWidget {
  const ComunidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.group_work),
              title: Text('Community Post 1'),
              subtitle: Text('Discussion about habits...'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.event),
              title: Text('Upcoming Event'),
              subtitle: Text('Join our weekly meetup!'),
            ),
          ),
        ],
      ),
    );
  }
}
