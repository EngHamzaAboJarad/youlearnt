import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_learnt/data/remote/api_requests.dart';
import '../../utils/error_handler/error_handler.dart';

class ChatGetxController extends GetxController {
  static ChatGetxController get to => Get.find();

  /// if user inside chat screen => true , outSide => false
  bool inSideChat = false;
  bool loading = false;

  Future<String?>? uploadImage({required XFile image}) async {
    try {
      var res = await Get.find<ApiRequests>().uploadChatPhoto(image: image.path);
      return res.data['object'];
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    return null;
  }
}
