import '../../core/services/firestore_service.dart';
import '../models/place_model.dart';

class PlacesRepository {
  final FirestoreService _firestoreService;

  PlacesRepository(this._firestoreService);

  Stream<List<PlaceModel>> getPlaces({String? category}) {
    return _firestoreService.collectionStream(
      path: 'places',
      builder: (data, id) => PlaceModel.fromMap(data, id),
      queryBuilder: (query) {
        if (category != null && category != 'All') {
          return query.where('category', isEqualTo: category);
        }
        return query;
      },
    );
  }

  Future<PlaceModel> getPlaceById(String placeId) async {
    return await _firestoreService.getDocument(
      path: 'places/$placeId',
      builder: (data, id) => PlaceModel.fromMap(data, id),
    );
  }
}
