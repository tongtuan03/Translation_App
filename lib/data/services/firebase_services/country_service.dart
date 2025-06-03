import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/language_model.dart';

class CountryService {
  final CollectionReference _countryRef =
  FirebaseFirestore.instance.collection('languages');

  Future<List<Language>> fetchAllCountries() async {
    QuerySnapshot snapshot = await _countryRef.get();
    return snapshot.docs.map((doc) {
      return Language.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> uploadCountriesToFirestore(List<Language> countries) async {
    final countryCollection = FirebaseFirestore.instance.collection('languages');

    for (final country in countries) {
      await countryCollection.doc(country.languageId).set(country.toMap());
    }
  }
  Future<void> deleteAllCountries() async {
    final collection = FirebaseFirestore.instance.collection('languages');

    final snapshot = await collection.get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }

  }
}
