import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {


  const JobCard({
    super.key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.datePosted,
  });

    final String jobTitle;
    final String companyName;
    final String location;
    final String salary;
    final String datePosted;

    @override
    Widget build(BuildContext context) {
      return SizedBox(
        child: Card(
          // clipBehavior is necessary because, without it, the InkWell's animation
          // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
          // This comes with a small performance cost, and you should not set [clipBehavior]
          // unless you need it.
          clipBehavior: Clip.hardEdge,
        shadowColor: Colors.teal,
        elevation: 50,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              
            },
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(15),
              width: 150,
              height: 200,
              color: Colors.tealAccent,
              child: Text('$jobTitle\n$companyName\n$location\n$salary\n$datePosted'),
          ),
        ),),
        ),
      );
    }
}