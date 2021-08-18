import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'with_admin',
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String homeStatus = '비밀번호 입력해주세요';

  void setHomeStatus(String str) {
    homeStatus = str;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위드 관리자 페이지'),
      ),
      drawer: CustomDrawer(setHomeStatus: setHomeStatus),
      body: HomeForm(
        homeStatus: homeStatus,
        formKey: GlobalKey(),
        setHomeStatus: setHomeStatus,
      ),
    );
  }
}

class HomeForm extends StatefulWidget {
  HomeForm({
    Key? key,
    required this.homeStatus,
    required this.formKey,
    required this.setHomeStatus,
  }) : super(key: key);

  final String homeStatus;
  final GlobalKey<FormState> formKey;
  final Function setHomeStatus;

  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  late String homeTeamName = '';
  late String awayTeamName = '';
  late String homeScore = '';
  late String awayScore = '';
  late String leagueName = '';
  DateTime currentDate = DateTime.now();
  bool isDateTimeSet = false;
  bool isResult = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));
    if (pickedDate != null) {
      setState(() {
        currentDate = pickedDate;
        isDateTimeSet = true;
      });
    }
  }

  static const List<String> _kTeamNames = <String>[
    '똥칼라파워fc1',
    '똥칼라파워FC2',
    '똥칼라파워FC3',
    '똥칼라파워FC4',
    '똥칼라파워FC5',
    '똥칼라파워FC6',
    '똥칼라파워FC7',
    '똥칼라파워FC8',
    '똥칼라파워FC9',
    '똥칼라파워FC10',
  ];

  static const List<String> _kLeagueName = <String>['청룡기', '황룡기', '서울시장배기'];

  @override
  Widget build(BuildContext context) {
    if (widget.homeStatus == '경기등록') {
      return Form(
        key: widget.formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('홈 팀명',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return _kTeamNames.where((String option) {
                              return option.contains(textEditingValue.text);
                            });
                          },
                          onSelected: (String selection) {
                            print('You select $selection');
                            homeTeamName = selection;
                            print('homeTeamName is $homeTeamName');
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('어웨이 팀명',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return const Iterable<String>.empty();
                            }
                            return _kTeamNames.where((String option) {
                              return option.contains(textEditingValue.text);
                            });
                          },
                          onSelected: (String selection) {
                            print('You select $selection');
                            awayTeamName = selection;
                            print('awayTeamName is $awayTeamName');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Checkbox(
                      value: isResult,
                      onChanged: (value) {
                        isResult = !isResult;
                        homeScore = '';
                        awayScore = '';
                        setState(() {});
                      }),
                  isResult
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 100,
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('홈 점수',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        homeScore = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('어웨이 점수',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        awayScore = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 200,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('리그명',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 300,
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return _kLeagueName.where((String option) {
                            return option.contains(textEditingValue.text);
                          });
                        },
                        onSelected: (String selection) {
                          print('You select $selection');
                          leagueName = selection;
                          print('leagueName is $leagueName');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(currentDate.toString().split(' ')[0],
                      style: TextStyle(fontSize: 20)),
                  TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text('날짜 선택')),
                ],
              ),
              SizedBox(
                  height: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        if (isResult) {
                          if (homeTeamName.isEmpty ||
                              awayTeamName.isEmpty ||
                              homeScore.isEmpty ||
                              awayScore.isEmpty ||
                              leagueName.isEmpty ||
                              !isDateTimeSet) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('빈칸을 채워주세요!!!!!'),
                              duration: Duration(seconds: 1),
                            ));
                          } else {
                            print('submitted');
                          }
                        } else {
                          if (homeTeamName.isEmpty ||
                              awayTeamName.isEmpty ||
                              leagueName.isEmpty ||
                              !isDateTimeSet) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('빈칸을 채워주세요!!!!!'),
                              duration: Duration(seconds: 1),
                            ));
                          } else {
                            print('submitted');
                          }
                        }
                      },
                      child: Text(
                        '제출하기',
                        style: TextStyle(fontSize: 30),
                      ))),
              // DatePickerDialog(initialDate: initialDate, firstDate: firstDate, lastDate: lastDate)
            ],
          ),
        ),
      );
    } else
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.homeStatus),
            TextFormField(
              textAlign: TextAlign.center,
              obscureText: true,
              onFieldSubmitted: (value) {
                print(value);
                if(value == '123123'){
                  widget.setHomeStatus('경기등록');
                }
              },
            ),
          ],
        ),
      );
  }
}

class CustomDrawer extends StatelessWidget {
  final Function setHomeStatus;

  CustomDrawer({required this.setHomeStatus});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(child: Image.asset('with_logo.png')),
          InkWell(
            child: ListTile(
              title: Text('경기등록'),
            ),
            onTap: () {
              // setHomeStatus('경기등록');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
