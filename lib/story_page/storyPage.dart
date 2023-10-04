import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../module/blogModule.dart';

class ExtendedStory extends StatelessWidget {
  Blog blog;
 ExtendedStory(this.blog);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 100.w,
              child: CachedNetworkImage(
                imageUrl: blog.imageURL,
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
            Text(blog.title,style: TextStyle(fontSize: 30))
          ],
        ),
      ),
    );
  }
}
