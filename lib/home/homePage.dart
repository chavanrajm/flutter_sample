import 'package:assignment/controllers/dataHandler.dart';
import 'package:assignment/story_page/storyPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../module/blogModule.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataHandler _dataHandler = DataHandler();
  List<Blog> blogs = [];
  void fetchBlogs()async{
    blogs = await _dataHandler.fetchBlogs()??[];
    print(blogs.length);
    await _dataHandler.fetchLikedPosts();
    _dataHandler.isLoading.value = false;
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchBlogs();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
        backgroundColor: Colors.teal,
      ),
      body: Obx((){
        _dataHandler.tempBool.value;
        return  _dataHandler.isNetworkConnected.value?_dataHandler.isLoading.value?Center(
          child: CircularProgressIndicator(),
        ):_dataHandler.isError.value?Center(child: ElevatedButton(child: Text('Error'),onPressed: (){
          fetchBlogs();
        },),):ListView.builder(
          itemBuilder: (context, i){
            print(i);
            return GestureDetector(
              onTap: (){
                Get.to(()=>ExtendedStory(blogs[i]));
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          width: 100.w,
                          child: AspectRatio(
                            aspectRatio: 16/9,
                            child: CachedNetworkImage(
                              imageUrl: blogs[i].imageURL,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, s, progress){
                                return Container(
                                  width: 100.w,
                                  child: Center(child: CircularProgressIndicator(),),
                                );
                              },
                              errorWidget: (context, s, object){
                                return Container(
                                  width: 100.w,
                                  child: Center(child: Text('Error'),),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, top: 10),
                          child: GestureDetector(
                              onTap: ()async{
                                if (_dataHandler.likedPosts.value.contains(blogs[i].id)){
                                  await _dataHandler.removeLikedPost(blogs[i].id);
                                }else{
                                  await _dataHandler.addLikedPost(blogs[i].id);
                                }
                              },
                              child: _dataHandler.likedPosts.value.contains(blogs[i].id)?Icon(Icons.favorite, size: 35,color: Colors.red,):Icon(Icons.favorite_border, size: 35,color: Colors.red,)),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Text(blogs[i].title, maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(
                          fontSize: 30
                      ),),
                    )
                  ],
                ),
              ),
            );
          },
        ):Center(child: ElevatedButton(child: Text('Check Your Network'),onPressed: (){
          fetchBlogs();
        },),);
      }
      ),
    );
  }
}
