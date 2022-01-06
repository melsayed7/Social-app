import 'package:flutter/material.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: const Icon(IconBroken.Arrow___Left_2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              onTap: (){},
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder() ,
                hintText: 'Type here for Searching ...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
