import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/rooms.dart';

part 'rooms_dao.g.dart';

/// The rooms DAO.
@DriftAccessor(tables: [Rooms])
class RoomsDao extends DatabaseAccessor<Database> with _$RoomsDaoMixin {
  /// Create an instance.
  RoomsDao(super.db);

  /// Create a new row.
  Future<Room> createRoom({
    required final World world,
    required final String name,
    required final String description,
    required final int width,
    required final int length,
  }) =>
      db.managers.rooms.createReturning(
        (final o) => o(
          worldId: world.id,
          name: name,
          description: description,
          width: width,
          length: length,
        ),
      );

  /// Update [room].
  Future<Room> editRoom({
    required final Room room,
    final String? name,
    final String? description,
  }) async {
    final copy = room.copyWith(
      name: name ?? room.name,
      description: description ?? room.description,
    );
    await db.managers.rooms.replace(copy);
    return copy;
  }

  /// Delete [room].
  Future<int> deleteRoom(final Room room) =>
      db.managers.rooms.filter((final o) => o.id(room.id)).delete();

  /// Get a single row by [id].
  Future<Room> getRoom(final int id) =>
      db.managers.rooms.filter((final o) => o.id(id)).getSingle();

  /// Get all the rooms in [world].
  Future<List<Room>> getRooms(final World world) {
    final query = select(rooms)
      ..where((final table) => table.worldId.equals(world.id))
      ..orderBy([(final table) => OrderingTerm.asc(table.name)]);
    return query.get();
  }
}
