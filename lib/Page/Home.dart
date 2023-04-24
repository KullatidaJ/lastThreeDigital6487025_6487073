import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:national_view/Page/NationalParkDetail.dart';
import 'package:national_view/Page/SignIn.dart';
import 'package:national_view/Page/Welcome.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> nationalparks = [];

  @override
  void initState() {
    super.initState();
    loadnationalparks();
    print('start');
  }

  Future<List<Map<String, String>>> fetchnationalparks() async {
    //ส่ง HTTP request ไปยัง API ด้วย method GET, ส่ง uri ที่ต้องการมาในรุปแบบ .parse()
    final response = await http.get(Uri.parse(
        'http://10.62.112.211/api/national-parks/')); // เปลี่น เลข ip address

    // ตรวจสอบสถานะ response 200=ฯษ
    if (response.statusCode == 200) {
      //ถ้า สถานะ respoonse เป็น 200
      final List<dynamic> data = json.decode(response.body);
      //จะแปลง JSON ที่ได้จาก API มาในรูปแบบของ List<Map<String,String>
      //โดยใช้ json.decode()+map()+returnค่า เป็น Map<String, String> เพื่อเก็บข้อมูล แล้ว return เป็น list ออกไป
      final nationalparks = data
          .map<Map<String, String>>((dynamic park) => {
                'name': park['name'],
                'description': park['description'],
                'image': park['image'],
                'weather': park['weather'],
                'map': park['map'],
                'plant': park['plant'],
                'animal': park['animal'],
                'tourist': park['tourist'],
                'activity': park['activity'],
                'signal': park['signal'],
                'interdict': park['interdict'],
                'resident': park['resident'],
                'institute': park['institute'],
                'contact': park['contact'],
                'link': park['link'],
              })
          .toList();
      return nationalparks;
    } else {
      //ถ้า response ไม่ใช้สถานะ OK จะ throw Exception พร้อมบอกว่า 'Failed to load national parks'
      throw Exception('Failed to load national parks');
    }
  }

  Future<void> loadnationalparks() async {
    try {
      // ใช้ function fetchnationalparks()
      //เพื่อดึงข้อมูลจาก API ถ้าดึงได้เก็บไว้ในตัวแปร parks ในรูปแบบ List<Map<String,String>
      final parks = await fetchnationalparks();
      // อัพเดตค่า nationalparks เป็น parks ที่ดึงข้อมูลมาเมื่อครู่
      setState(() {
        nationalparks = parks;
      });

      print(nationalparks);

      //ถ้าดึงไม่ได้ จะ catch exception  + บอกว่า error
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (nationalparks.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('Home',
          style: TextStyle(color: Colors.grey[900]),),
        ),
        automaticallyImplyLeading: false, //เป็นการลบปุ่ม back ออก 
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert, 
                color: Colors.grey[900],
              ),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    child: Text('Logout'),
                    value: 'logout',
                  ),
                ];
              },
              //ยัง Logout ไม่ได้
              onSelected: (value) {
                // Handle menu item selection here
                if (value == 'logout') {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomePage()),
                    (route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
      
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Image.network(
                'https://cdn.discordapp.com/attachments/506416477310812161/1097210605041111040/564000010482201.png',
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Text('Error Loading Image');
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'National Park List',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nationalparks.length,
              itemBuilder: (BuildContext context, int index) {
                String name = nationalparks[index]['name']!;
                String image = nationalparks[index]['image']!;
                String desc = nationalparks[index]['description']!;
                String weather = nationalparks[index]['weather']!;
                String map = nationalparks[index]['map']!;
                String plant = nationalparks[index]['plant']!;
                String animal = nationalparks[index]['animal']!;
                String tourist = nationalparks[index]['tourist']!;
                String activity = nationalparks[index]['activity']!;
                String signal = nationalparks[index]['signal']!;
                String interdict = nationalparks[index]['interdict']!;
                String resident = nationalparks[index]['resident']!;
                String institute = nationalparks[index]['institute']!;
                String contact = nationalparks[index]['contact']!;
                String link = nationalparks[index]['link']!;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NationalParkDetails(
                          name: name,
                          description: desc,
                          image: image,
                          weather: weather,
                          map: map,
                          plant: plant,
                          animal: animal,
                          tourist: tourist,
                          activity: activity,
                          signal: signal,
                          interdict: interdict,
                          resident: resident,
                          institute: institute,
                          contact: contact,
                          link: link,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 200,
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Text('Error Loading Image');
                              },
                            )),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(desc),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
