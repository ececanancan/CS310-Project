import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart';
import 'package:cs_projesi/pages/userProfilePage.dart';
import 'package:cs_projesi/models/event.dart';
import 'eventPage.dart';

class RequestNotificationPage extends StatelessWidget {
  const RequestNotificationPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchIncomingJoinRequests() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final eventsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('your_activities')
        .get();

    List<Map<String, dynamic>> requestData = [];

    for (final eventDoc in eventsSnapshot.docs) {
      final eventId = eventDoc.id;
      final eventTitle = eventDoc.data()['descriptionMini'] ?? 'your activity';

      final requestsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('requests')
          .get();

      for (final req in requestsSnapshot.docs) {
        final requesterId = req.id;
        final status = req.data()['status'];

        final userDoc = await FirebaseFirestore.instance.collection('users').doc(requesterId).get();
        final userData = userDoc.data() ?? {};

        requestData.add({
          'type': 'incoming',
          'eventId': eventId,
          'eventTitle': eventTitle,
          'requesterId': requesterId,
          'requesterName': userData['name'] ?? 'Unknown',
          'requesterPhoto': userData['profilePhotoUrl'] ?? '',
          'status': status,
        });
      }
    }

    return requestData;
  }

  Future<List<Map<String, dynamic>>> _fetchMyNotifications() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();

    List<Map<String, dynamic>> notifs = snapshot.docs.map((doc) {
      return {
        'type': 'notification',
        'id': doc.id,
        'message': doc['message'] ?? '',
        'read': doc['read'] ?? false,
        'eventId': doc.data().containsKey('eventId') ? doc['eventId'] : null,
        'eventOwnerId': doc.data().containsKey('eventOwnerId') ? doc['eventOwnerId'] : null,
      };
    }).toList();

    for (final doc in snapshot.docs) {
      doc.reference.update({'read': true});
    }

    return notifs;
  }

  Future<void> _updateRequestStatus(String eventId, String requesterId, String status, String descriptionMini) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final ownerId = currentUser?.uid ?? '';

    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .collection('requests')
        .doc(requesterId)
        .update({'status': status});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(requesterId)
        .collection('notifications')
        .add({
      'message': 'Your request to join "$descriptionMini" was $status.',
      'eventId': eventId,
      'eventOwnerId': ownerId,
      'read': false,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true); // notify HomePage
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Requests'), centerTitle: true),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: Future.wait([
            _fetchIncomingJoinRequests(),
            _fetchMyNotifications(),
          ]).then((results) => [...results[0], ...results[1]]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data ?? [];
            if (data.isEmpty) {
              return const Center(child: Text('No Requests.'));
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                if (item['type'] == 'notification') {
                  return ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(item['message'] ?? ''),
                    onTap: item['eventId'] != null && item['eventOwnerId'] != null
                        ? () async {
                      final doc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(item['eventOwnerId'])
                          .collection('your_activities')
                          .doc(item['eventId'])
                          .get();

                      if (doc.exists) {
                        final data = doc.data()!;
                        final coord = data['coordinates'];
                        final coordinates = coord is GeoPoint
                            ? LatLng(coord.latitude, coord.longitude)
                            : LatLng(0, 0);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventPage(
                              event: Event(
                                id: doc.id,
                                createdBy: data['createdBy'],
                                location: data['location'] ?? '',
                                coordinates: coordinates,
                                date: (data['date'] as Timestamp).toDate(),
                                descriptionMini: data['descriptionMini'] ?? '',
                                eventPhotoPath: data['eventPhotoPath'] ?? '',
                                descriptionLarge: data['descriptionLarge'] ?? '',
                                where: data['where'] ?? '',
                                bring: data['bring'] ?? '',
                                goal: data['goal'] ?? '',
                                when: data['when'] ?? '',
                                createdAt: (data['createdAt'] as Timestamp).toDate(),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                        : null,
                    trailing: item['read'] == false
                        ? Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                        : null,
                  );
                }

                final photoPath = item['requesterPhoto'] ?? '';
                final imageProvider = photoPath.startsWith('http')
                    ? NetworkImage(photoPath)
                    : photoPath.isNotEmpty
                    ? AssetImage(photoPath) as ImageProvider
                    : const AssetImage('assets/default_avatar.png');

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserProfilePage(uid: item['requesterId']),
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    ),
                    title: Text('${item['requesterName']} wants to join "${item['eventTitle']}"'),
                    subtitle: Text(item['status'] == null ? 'Pending' : item['status']),
                    trailing: item['status'] == null
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _updateRequestStatus(
                            item['eventId'],
                            item['requesterId'],
                            'accepted',
                            item['eventTitle'],
                          ).then((_) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RequestNotificationPage()))),
                          child: const Text('Accept', style: TextStyle(color: Colors.green)),
                        ),
                        TextButton(
                          onPressed: () => _updateRequestStatus(
                            item['eventId'],
                            item['requesterId'],
                            'declined',
                            item['eventTitle'],
                          ).then((_) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RequestNotificationPage()))),
                          child: const Text('Decline', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    )
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
