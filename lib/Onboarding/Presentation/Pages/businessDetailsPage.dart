import 'package:flutter/material.dart';
import 'package:raithan_serviceapp/Utils/app_dimensions.dart';
import 'package:raithan_serviceapp/Utils/app_style.dart';
import 'package:raithan_serviceapp/Widgets/dobInputField.dart';
import 'package:raithan_serviceapp/Widgets/dropDownTextFeild.dart';
import 'package:raithan_serviceapp/Widgets/imageInputFeild.dart';
import 'package:raithan_serviceapp/Widgets/textField.dart';
import 'package:raithan_serviceapp/constants/enums/business_category.dart';

enum Gender { male, female, other }

class Businessdetailspage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController;
  final TextEditingController genderController;
  final TextEditingController
      imageController; // If image URI or path is stored as string

   Businessdetailspage({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.dobController,
    required this.imageController,
    required this.genderController,
  });



  @override
  State<Businessdetailspage> createState() => _PersonalDetailsPageState();


}

class _PersonalDetailsPageState extends State<Businessdetailspage> {

  Map<String, bool> workingDays = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (selectedTime != null) {
      // Format the time to a string (e.g., "9:00 AM")
      String formattedTime = selectedTime.format(context);
      controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.width*0.03),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Business Details",
              style: robotoBold.copyWith(
                color: black,
                fontSize: 20,
              ),
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.firstNameController,
              type: TextInputType.name,
              label: "Business Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Business name';
                }
                return null;
              },
            ),
            sizedBox(),
            DropdownTextField(
              controller: widget.genderController,
              label: "Select an Business Category",
              options: BusinessCategory.values.map((e) {
                return e.name;
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an Business Category';
                }
                return null;
              },
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.lastNameController,
              type: TextInputType.number,
              label: "Pincode",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write your pincode';
                }
                return null;
              },
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.lastNameController,
              type: TextInputType.text,
              label: "Block Number",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write your block Number';
                }
                return null;
              },
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.lastNameController,
              type: TextInputType.text,
              label: "Street",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write your street';
                }
                return null;
              },
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.lastNameController,
              type: TextInputType.text,
              label: "Area",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write your area';
                }
                return null;
              },
            ),
            sizedBox(),
            CustomTextfield(
              controller: widget.lastNameController,
              type: TextInputType.text,
              label: "Landmark",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write your Landmark';
                }
                return null;
              },
            ),
            sizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Container(
              width: AppDimensions.width*0.43,
              child: CustomTextfield(
                controller: widget.lastNameController,
                type: TextInputType.text,
                label: "City",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your city';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 3,),
            Container(
              width: AppDimensions.width*0.43,
              child: CustomTextfield(
                controller: widget.lastNameController,
                type: TextInputType.text,
                label: "State",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please write your state';
                  }
                  return null;
                },
              ),
            )]
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Title for the working days
                  const Text(
                    'Select Working Days',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Container to wrap the checkboxes with title
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      children: [
                        // Loop through the working days to create checkboxes
                        ...workingDays.keys.map((day) {
                          return CheckboxListTile(
                            title: Text(day),
                            value: workingDays[day],
                            onChanged: (bool? value) {
                              setState(() {
                                workingDays[day] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            sizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: AppDimensions.width*0.43,
                  child: TextFormField(
                    controller: widget.firstNameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      suffixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    onTap: () {
                      _selectTime(context, widget.firstNameController);
                    },
                  ),
                ),
                SizedBox(width: 5,),
                Container(
                  width: AppDimensions.width*0.43,
                  child: TextFormField(
                    controller: widget.firstNameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      suffixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    onTap: () {
                      _selectTime(context, widget.firstNameController);
                    },
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget sizedBox() {
    return const SizedBox(
      height: 15,
    );
  }
}
