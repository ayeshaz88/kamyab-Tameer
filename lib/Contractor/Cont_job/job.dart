import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Contractor/contractor_botton_nav.dart';
import 'add_job.dart';
import 'delete_job.dart';
import 'update_job.dart';
import 'view_job.dart';

class JobScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20), // Change top margin size here
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SmallButton(label: 'All',),
              _SmallButton(label: 'On going',),
              _SmallButton(label: 'Completed',),
            ],
          ),
          SizedBox(height: 20), // Adjust height between rows here
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LargeButton(label: 'Add Job', color: Color(0xFF6E85B7), icon: Icons.add, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddJobScreen()));
              }),
              _LargeButton(label: 'Delete Job', color: Color(0xFFF47C7C), icon: Icons.delete, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteJobScreen()));
              }),
            ],
          ),
          SizedBox(height: 20), // Adjust height between rows here
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LargeButton(label: 'Update Job', color: Color(0xFFBBAB8C), icon: Icons.edit, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateJobScreen()));
              }),
              _LargeButton(label: 'View Job', color: Color(0xFF9ED5C5), icon: Icons.visibility, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewJobScreen()));
              }),
            ],
          ),
        ],
      ),
      bottomNavigationBar: ContractorBottomNavigationBar(),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String label;

  const _SmallButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all<double>(0),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

class _LargeButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _LargeButton({required this.label, required this.color, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
        fixedSize: MaterialStateProperty.all<Size>(Size(170, 100)), // Change height and width of these buttons here
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(icon, size: 36, color: Colors.white), // Change icon size here
            ),
          ),
          Center(
            child: Text(label, style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: JobScreen(),
  ));
}
