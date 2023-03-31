import 'package:flutter/material.dart';
import 'package:passport_digital_itc/models/student_model.dart';
import 'package:passport_digital_itc/providers/admin_provider.dart';
import 'package:passport_digital_itc/providers/student_provider.dart';
import 'package:passport_digital_itc/screens/admin/add_user_screen.dart';
import 'package:passport_digital_itc/screens/widgets/custom_textformfield.dart';
import 'package:provider/provider.dart';

class UsersAdminScreen extends StatefulWidget {
  const UsersAdminScreen({super.key});

  @override
  State<UsersAdminScreen> createState() => _UsersAdminScreenState();
}

class _UsersAdminScreenState extends State<UsersAdminScreen> {
  String search = '';
  List<Student>? students;
  dynamic stream;
  TextEditingController? _searchController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _searchController = TextEditingController();
    initialization();
    // studentItems = Provider.of<List<Student>?>(context, listen: false);
    super.initState();
  }

  initialization() async {
    students = Provider.of<List<Student>?>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administracion de usuarios'),
      ),
      resizeToAvoidBottomInset: false,
      body: _body(),
    );
  }

  Widget _body() {
    students = Provider.of<List<Student>?>(context);
    final stream = context.watch<AdminProvider>().getUsers();
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor introducir un texto..';
                      }
                      return null;
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_search_rounded),
                      suffix: Icon(Icons.search_rounded),
                      labelText: 'Busqueda',
                      filled: true,
                      fillColor: Colors.grey[50],
                      counterStyle: TextStyle(color: Colors.green[300]),
                      floatingLabelStyle: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSecondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary),
                        // borderRadius: widget.borderRadius
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.secondary),
                        // borderRadius: widget.borderRadius
                      ),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.red)),
                      errorStyle: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
                child: StreamBuilder(
                    stream: stream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError) {
                            Center(
                              child: Column(
                                children: const [
                                  Icon(Icons.sentiment_dissatisfied),
                                  Text('Sucedio algo inesperado....')
                                ],
                              ),
                            );
                          }
                          List<Student> filter;
                          filter = search.isNotEmpty
                              ? snapshot.data!
                                  .where((element) => element
                                      .toJson()
                                      .toString()
                                      .toLowerCase()
                                      .contains('$search'))
                                  .toList()
                              : snapshot.data!.toList();

                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: filter.length,
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                  width: double.infinity,
                                  height: 100,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          child: ListTile(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed('/addUser',
                                                    arguments: addUserScreen(
                                                      user: filter[index],
                                                    )),
                                            title:
                                                Text('${filter[index].name}'),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('${filter[index].email}'),
                                                Text('${filter[index].role}'),
                                                Text('${filter[index].career}'),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ));
                            },
                          );
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
