import 'dart:convert';

import 'package:assignment/module/blogModule.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataHandler extends GetxController{
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isNetworkConnected = false.obs;
  RxBool tempBool = false.obs;
  RxList likedPosts = [].obs;
  Future fetchLikedPosts()async{
  SharedPreferences pref = await SharedPreferences.getInstance();
 likedPosts.value =  pref.getStringList('likedPosts')??[];
  }
  Future addLikedPost(String postID)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    likedPosts.value =  pref.getStringList('likedPosts')??[];
    likedPosts.value.add(postID);
    await pref.setStringList('likedPosts', List<String>.from(likedPosts.value));
    tempBool.value = !tempBool.value;
  }
  Future removeLikedPost(String postID)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    likedPosts.value =  pref.getStringList('likedPosts')??[];
    likedPosts.value.remove(postID);
    await pref.setStringList('likedPosts', List<String>.from(likedPosts.value));
    tempBool.value = !tempBool.value;
  }
  Future fetchBlogs() async {
    isNetworkConnected.value = true;
    isLoading.value = true;
    isError.value = false;
    final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    final String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';//6
    final Connectivity connectivity = Connectivity();
    ConnectivityResult result = await connectivity.checkConnectivity();
    if(result == ConnectivityResult.none){
      isNetworkConnected.value = false;
      return;
    }
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        // Request successful, handle the response data here
        print('Response data: ${response.body}');
        return await jsonDecode(response.body)['blogs'].map<Blog>((data){
          return Blog(id: data['id'], imageURL: data['image_url'], title: data['title']);
        }).toList();
      } else {
        // Request failed
        print('Request failed with status code: ${response.statusCode}');
        print('Response data: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error: $e');
    }
    isError.value = true;
    return null;
  }
}