import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kamiyabtameer/Client/client_bottom_nav.dart';

class AddFeedbackScreen extends StatefulWidget {
  @override
  _AddFeedbackScreenState createState() => _AddFeedbackScreenState();
}

class _AddFeedbackScreenState extends State<AddFeedbackScreen> {
  List<bool> isStarSelectedList = [false, false, false, false, false];
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Feedback',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            Text(
              'Feedback Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2544),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: feedbackController,
              decoration: InputDecoration(
                hintText: 'Add Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description), // Added icon for feedback description
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Feedback Review',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2544),
              ),
            ),
            SizedBox(height: 10),
            _buildStarRating(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save feedback to Firestore
                saveFeedback();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1F2544),
              ),
              child: Text('Post Feedback'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClientBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.search,
              color: Color(0xFF1F2544),
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            isStarSelectedList[index] ? Icons.star : Icons.star_border,
            color: isStarSelectedList[index] ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              for (int i = 0; i < isStarSelectedList.length; i++) {
                if (i <= index) {
                  isStarSelectedList[i] = true;
                } else {
                  isStarSelectedList[i] = false;
                }
              }
            });
          },
        );
      }),
    );
  }

  void saveFeedback() {
    String feedbackDescription = feedbackController.text;
    int rating = calculateRating();

    FirebaseFirestore.instance.collection('Clientfeedback').add({
      'description': feedbackDescription,
      'rating': rating,
    }).then((value) {
      // Feedback saved successfully
      print('Feedback saved successfully');
      // Clear the text field
      feedbackController.clear();
      // Reset star ratings
      setState(() {
        isStarSelectedList = [false, false, false, false, false];
      });
    }).catchError((error) {
      // Handle errors
      print("Failed to add feedback: $error");
    });
  }

  int calculateRating() {
    int rating = 0;
    for (int i = 0; i < isStarSelectedList.length; i++) {
      if (isStarSelectedList[i]) {
        rating++;
      }
    }
    return rating;
  }
}

void main() {
  runApp(MaterialApp(
    home: AddFeedbackScreen(),
  ));
}