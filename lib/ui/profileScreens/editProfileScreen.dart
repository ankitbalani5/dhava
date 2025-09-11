import 'package:coherent_endurance/widgets/backButton.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackButtonWidget()),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "DONE",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/300",
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // First Name & Last Name
            Row(
              children: [
                Expanded(child: _buildTextField("First name", "Rajeev")),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField("Last name", "Yadav")),
              ],
            ),
            const SizedBox(height: 15),

            // City & State
            Row(
              children: [
                Expanded(child: _buildTextField("City", "Jaipur")),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField("State", "Rajasthan")),
              ],
            ),
            const SizedBox(height: 15),

            // Primary Sport Dropdown
            _buildDropdown("Primary Sport", "Running", ["Running", "Cycling", "Swimming"]),
            const SizedBox(height: 15),

            // Bio
            _buildTextField("Bio", ""),
            const SizedBox(height: 20),

            // Athlete Information
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ATHLETE INFORMATION",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Google Fit Option
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: const [
                  Icon(Icons.favorite, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Automatically update your profile by connecting to Google Fit",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Birthday
            _buildDropdown("Birthday", "23/08/2000", ["01/01/2000", "23/08/2000", "10/12/2001"]),
            const SizedBox(height: 15),

            // Gender
            _buildDropdown("Gender", "Men", ["Men", "Women", "Other"]),
            const SizedBox(height: 15),

            // Weight
            _buildTextField("Weight (kg)", ""),
            const SizedBox(height: 20),

            // Performance Potential Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "PERFORMANCE POTENTIAL",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Max Heart Rate
            _buildTextField("Max Heart Rate (bpm)", "185"),
            const SizedBox(height: 15),

            // Running Race Distance Dropdown
            _buildDropdown("Running Race Distance", "5K", ["5K", "10K", "Half Marathon"]),
            const SizedBox(height: 15),

            // Running Race Time Dropdown
            _buildDropdown("Running Race Time", "30 mins", ["30 mins", "45 mins", "1 hour"]),
            const SizedBox(height: 15),

            // Functional Threshold Power
            _buildTextField("Functional Threshold Power (watts)", ""),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        hintText: hint,
        // filled: true,
        // fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          // borderSide: BorderSide.none,
          borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // borderSide: BorderSide.none,
            borderSide: BorderSide(color: Colors.grey.shade200)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // borderSide: BorderSide.none,
            borderSide: BorderSide(color: Colors.grey.shade200)
        ),
      ),
    );
  }

  // Widget _buildDropdown(String label, String value, List<String> items){
  //     return Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 15),
  //       decoration: BoxDecoration(
  //         // color: Colors.grey[100],
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: Colors.grey.shade200
  //         ),
  //       ),
  //       child: DropdownSearch(),
  //     );
  // }

  Widget _buildDropdown(String label, String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          // labelText: label,
          label: Text(label),
          labelStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (newValue) {},
      ),
    );
  }
}
