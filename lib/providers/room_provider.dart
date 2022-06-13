
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final roomProvider = Provider.autoDispose((ref) => RoomProvider());
final roomStream = StreamProvider.autoDispose((ref) => RoomProvider().roomStream());


class RoomProvider{

  Future<types.Room> createRoom(types.User user) async{
     final response = await FirebaseChatCore.instance.createRoom(user);
     return response;
  }

  Stream<List<types.Room>> roomStream() {
  return  FirebaseChatCore.instance.rooms();
  }


}