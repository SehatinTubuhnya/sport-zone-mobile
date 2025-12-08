import 'package:flutter/material.dart';
import 'package:sport_zone/news/screens/newslist_form.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();

}

class _AddNewsState extends State<AddNews>{
  int add = 0;
  @override 
  Widget build(BuildContext context) {
    if (add == 0) {
      return ElevatedButton(
        onPressed: ()  {
          setState(() {
            add = 1;
          });
        }, 
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(), // Makes the button circular
            padding: const EdgeInsets.all(10), // Adjust padding as needed
            backgroundColor: Colors.black, // Button background color
            foregroundColor: Colors.white, // Icon/text color
          ),
        child: const Icon(Icons.add_circle), // The icon insid
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 6, bottom:6, left:12, right:6),
          child: Row(
            children: [
              Text(
                "Add news",
                style: TextStyle(color: Colors.white)
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    add = 0;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsFormPage()
                      )
                    );
                  });
                }, 
                child: Icon(Icons.add)
              )
            ],
          )
        )
      );
    }     
  }
}