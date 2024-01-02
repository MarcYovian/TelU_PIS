import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:parking_v3/src/features/my_profile/data/my_profile_service.dart';
import 'package:parking_v3/src/features/my_profile/domain/MyProfile.dart';
import 'package:parking_v3/src/features/my_profile/presentation/widget/my_field.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final MyProfileService _profileService = MyProfileService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDF7F9),
        bottomOpacity: 1.0,
        foregroundColor: Colors.white10,
        title: const Center(
          child: Text("My Profile"),
        ),
        leading: InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff0A1D81),
            ),
          ),
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () {},
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.edit,
                color: Color(0xff0A1D81),
              ),
            ),
          ),
          const Gap(10),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: StreamBuilder(
            stream: _profileService.getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error : ${snapshot.error}"),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              MyProfile profile = MyProfile.fromMap(
                snapshot.data!.data() as Map<String, dynamic>,
              );

              return Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            profile.image,
                            height: 120,
                            width: 120,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.black,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(70),

                  // name field
                  MyField(
                    title: "Name",
                    value: profile.name,
                  ),
                  const Gap(20),

                  // email field
                  MyField(
                    title: "Email",
                    value: profile.email,
                  ),
                  const Gap(20),

                  // email field
                  MyField(
                    title: "Address",
                    value: profile.address,
                  ),
                  const Gap(20),

                  // email field
                  MyField(
                    title: "Number",
                    value: profile.number,
                  ),
                  const Gap(20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
