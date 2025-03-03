import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:socailworkapp/model/social_work.dart';
import 'package:socailworkapp/provider/social_work_provider.dart';
import 'add_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocialWorkProvider()),
      ],
      child: MaterialApp(
        title: 'Social Work App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Social Work App'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Icon(Icons.volunteer_activism, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<SocialWorkProvider>(
        builder: (context, provider, child) {
          return provider.socialWorks.isEmpty
              ? const Center(
                  child: Text(
                    'ยังไม่มีงานสังคม',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: provider.socialWorks.length,
                  itemBuilder: (context, index) {
                    SocialWork data = provider.socialWorks[index];
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(data.date);

                    return Dismissible(
                      key: Key(data.title),
                      direction: DismissDirection.endToStart, // Restrict swipe direction
                      onDismissed: (direction) {
                        provider.removeSocialWork(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${data.title} ถูกลบ')),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'ลบ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(
                            data.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'ชั่วโมง : ${data.hours.toInt()} ชั่วโมง\nหมวดหมู่ : ${data.category}\nวันที่ : $formattedDate',
                            style: const TextStyle(fontSize: 16),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            child: FittedBox(
                              child: Text(
                                data.hours.toInt().toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          // trailing: IconButton(
                          //   icon: const Icon(Icons.edit, color: Colors.deepPurple),
                          //   onPressed: () {
                          //     // Add your edit functionality here
                          //   },
                          // )
                          
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddPage();
          }));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}