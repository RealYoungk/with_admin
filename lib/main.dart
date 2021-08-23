import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:with_admin/player.dart';

void main() => runApp(App());

// Local Server
const String server = '211.204.237.78:8080';

// Deploy Server
// const String server = '3.35.55.202:8080';

// 153153 => 김민석

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
  // String homeStatus = '경기등록';
  String homeStatus = '비밀번호 입력해주세요';
  String passwordStatus = '';

  void setHomeStatus(String str) {
    homeStatus = str;
    setState(() {});
  }

  void setPasswordStatus(String str) {
    passwordStatus = str;
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
        setHomeStatus: setHomeStatus,
        password: passwordStatus,
        setPasswordStatus: setPasswordStatus,
        formKey: GlobalKey(),
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
    required this.password,
    required this.setPasswordStatus,
  }) : super(key: key);

  final String homeStatus;
  final Function setHomeStatus;
  final String password;
  final Function setPasswordStatus;
  final GlobalKey<FormState> formKey;

  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  // String? homeTeamName;
  // String? awayTeamName;
  // String? homeScore;
  // String? awayScore;
  List<Player> homeGoalHistory = [];
  List<Player> homeAssistHistory = [];
  List<Player> awayGoalHistory = [];
  List<Player> awayAssistHistory = [];

  // String? leagueName;
  DateTime currentDate = DateTime.now();
  bool isDateTimeSet = false;
  bool isResult = true;

  TextEditingController homeTeamName = TextEditingController();
  TextEditingController awayTeamName = TextEditingController();
  TextEditingController homeScore = TextEditingController();
  TextEditingController awayScore = TextEditingController();
  TextEditingController leagueName = TextEditingController();
  TextEditingController homeGoalName = TextEditingController();
  TextEditingController homeGoalTime = TextEditingController();
  TextEditingController homeAssistName = TextEditingController();
  TextEditingController homeAssistTime = TextEditingController();
  TextEditingController awayGoalName = TextEditingController();
  TextEditingController awayGoalTime = TextEditingController();
  TextEditingController awayAssistName = TextEditingController();
  TextEditingController awayAssistTime = TextEditingController();
  TextEditingController stadium = TextEditingController();
  TextEditingController matchTime = TextEditingController();

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

  Future loadData() async {
    // http://211.204.237.78:8080/api/getLeagueName
    // http://211.204.237.78:8080/api/getClubName
    var url = Uri.http('$server', '/api/getLeagueName',
        {'q': '{http}', 'Content-Type': 'application/json;charset=UTF-8'});
    var url2 = Uri.http('$server', '/api/getClubName',
        {'q': '{http}', 'Content-Type': 'application/json;charset=UTF-8'});
    var response;
    var response2;
    try {
      response = await http.get(url);
      response2 = await http.get(url2);
      if (response.statusCode == 200 && response2.statusCode == 200) {
        List leagueNames =
            convert.jsonDecode(convert.utf8.decode(response.bodyBytes));
        List teamNames =
            convert.jsonDecode(convert.utf8.decode(response2.bodyBytes));
        _kLeagueNames = leagueNames.map((e) => e.toString()).toList();
        _kTeamNames = teamNames.map((e) => e.toString()).toList();
        print('Load Success ${_kLeagueNames.length}, ${_kTeamNames.length}');
      }
    } catch (e) {
      print(
          'Request failed with status: ${response.statusCode}, ${response2.statusCode} .');
    }
  }

  // TODO: postData 구현
  Future<int> postData({
    required String? homeTeamName,
    required String? awayTeamName,
    int? homeScore,
    int? awayScore,
    List<Player>? homeGoalHistory,
    List<Player>? homeAssistHistory,
    List<Player>? awayGoalHistory,
    List<Player>? awayAssistHistory,
    required String? leagueName,
    String? stadium,
    String? matchTime,
    String? password,
    required int? currentDate,
  }) async {
    var url = Uri.http('$server', '/api/setClubRecord');
    var body = convert.jsonEncode({
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'homeGoalHistory': homeGoalHistory == null
          ? null
          : homeGoalHistory.map((e) => e.toJson()).toList(),
      'homeAssistHistory': homeAssistHistory == null
          ? null
          : homeAssistHistory.map((e) => e.toJson()).toList(),
      'awayGoalHistory': awayGoalHistory == null
          ? null
          : awayGoalHistory.map((e) => e.toJson()).toList(),
      'awayAssistHistory': awayAssistHistory == null
          ? null
          : awayAssistHistory.map((e) => e.toJson()).toList(),
      'leagueName': leagueName,
      'currentDate': currentDate,
      'stadium': stadium,
      'matchTime': matchTime,
      'createdId': password,
      'updatedId': password
    });
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json;charset=UTF-8"},
      body: body,
    );
    print(url);
    print(body);

    print(response.statusCode);
    if (response.statusCode == 200) {
      return 1;
    } else
      return 0;
  }

  void initData() {
    isDateTimeSet = false;
    currentDate = DateTime.now();
    homeTeamName.clear();
    awayTeamName.clear();
    homeScore.clear();
    awayScore.clear();
    leagueName.clear();
    stadium.clear();
    matchTime.clear();
    homeGoalHistory.clear();
    homeAssistHistory.clear();
    awayGoalHistory.clear();
    awayAssistHistory.clear();
    setState(() {});
  }

  List<String> _kTeamNames = <String>[];

  List<String> _kLeagueNames = <String>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.homeStatus == '경기등록') {
      return FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) => !snapshot.hasError
            ? Form(
                key: widget.formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    return _kTeamNames.where((String option) {
                                      return option
                                          .contains(textEditingValue.text);
                                    });
                                  },
                                  onSelected: (String selection) {
                                    print('You select $selection');
                                    homeTeamName.text = selection;
                                    print(
                                        'homeTeamName is ${homeTeamName.text}');
                                  },
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onSubmit) {
                                    homeTeamName = controller;
                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                    );
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    return _kTeamNames.where((String option) {
                                      return option
                                          .contains(textEditingValue.text);
                                    });
                                  },
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onFieldSubmit) {
                                    awayTeamName = controller;
                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                    );
                                  },
                                  onSelected: (String selection) {
                                    print('You select $selection');
                                    awayTeamName.text = selection;
                                    print(
                                        'awayTeamName is ${awayTeamName.text}');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Checkbox(
                          value: isResult,
                          onChanged: (value) {
                            isResult = !isResult;
                            homeScore.text = '';
                            awayScore.text = '';
                            setState(() {});
                          }),
                      isResult
                          ? SizedBox(
                              height: 400,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('홈 점수',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  controller: homeScore,
                                                  onChanged: (value) {
                                                    homeScore.text = value;
                                                  },
                                                ),
                                              ),
                                              Text(
                                                '골 넣은사람',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: 250,
                                                child: Row(
                                                  children: [
                                                    Text('이름 : '),
                                                    SizedBox(
                                                        width: 70,
                                                        child: TextFormField(
                                                          controller:
                                                              homeGoalName,
                                                        )),
                                                    Text('시간 : '),
                                                    SizedBox(
                                                        width: 30,
                                                        child: TextFormField(
                                                          controller:
                                                              homeGoalTime,
                                                        )),
                                                    Text('분'),
                                                    IconButton(
                                                        onPressed: () {
                                                          if (homeGoalName.text
                                                                  .isNotEmpty &&
                                                              homeGoalTime.text
                                                                  .isNotEmpty) {
                                                            Player p = Player(
                                                                name:
                                                                    homeGoalName
                                                                        .text,
                                                                time:
                                                                    homeGoalTime
                                                                        .text);
                                                            homeGoalHistory
                                                                .add(p);
                                                            homeGoalName
                                                                .clear();
                                                            homeGoalTime
                                                                .clear();
                                                            setState(() {});
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              homeGoalHistory.isEmpty
                                                  ? Text(
                                                      '골 넣은사람 등록해주세요.',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .lightGreen),
                                                    )
                                                  : Row(
                                                      children: homeGoalHistory
                                                          .map((e) => InkWell(
                                                                onTap: () {
                                                                  homeGoalHistory
                                                                      .remove(
                                                                          e);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Text(
                                                                    '${e.name}, ${e.time}`',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    )),
                                                              ))
                                                          .toList(),
                                                    ),
                                              Text(
                                                '어시스트 한사람',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: 250,
                                                child: Row(
                                                  children: [
                                                    Text('이름 : '),
                                                    SizedBox(
                                                        width: 70,
                                                        child: TextFormField(
                                                          controller:
                                                              homeAssistName,
                                                        )),
                                                    Text('시간 : '),
                                                    SizedBox(
                                                        width: 30,
                                                        child: TextFormField(
                                                          controller:
                                                              homeAssistTime,
                                                        )),
                                                    Text('분'),
                                                    IconButton(
                                                        onPressed: () {
                                                          if (homeAssistName
                                                                  .text
                                                                  .isNotEmpty &&
                                                              homeAssistTime
                                                                  .text
                                                                  .isNotEmpty) {
                                                            Player p = Player(
                                                                name:
                                                                    homeAssistName
                                                                        .text,
                                                                time:
                                                                    homeAssistTime
                                                                        .text);
                                                            homeAssistHistory
                                                                .add(p);
                                                            homeAssistName
                                                                .clear();
                                                            homeAssistTime
                                                                .clear();
                                                            setState(() {});
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              homeAssistHistory.isEmpty
                                                  ? Text(
                                                      '어시스트 한 사람 등록해주세요.',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .lightGreen),
                                                    )
                                                  : Row(
                                                      children:
                                                          homeAssistHistory
                                                              .map(
                                                                  (e) =>
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          homeAssistHistory
                                                                              .remove(e);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: Text(
                                                                            '${e.name}, ${e.time}`',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                            )),
                                                                      ))
                                                              .toList(),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('어웨이 점수',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  controller: awayScore,
                                                  onChanged: (value) {
                                                    awayScore.text = value;
                                                  },
                                                ),
                                              ),
                                              Text(
                                                '골 넣은사람',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: 250,
                                                child: Row(
                                                  children: [
                                                    Text('이름 : '),
                                                    SizedBox(
                                                        width: 70,
                                                        child: TextFormField(
                                                          controller:
                                                              awayGoalName,
                                                        )),
                                                    Text('시간 : '),
                                                    SizedBox(
                                                        width: 30,
                                                        child: TextFormField(
                                                          controller:
                                                              awayGoalTime,
                                                        )),
                                                    Text('분'),
                                                    IconButton(
                                                        onPressed: () {
                                                          if (awayGoalName.text
                                                                  .isNotEmpty &&
                                                              awayGoalTime.text
                                                                  .isNotEmpty) {
                                                            Player p = Player(
                                                                name:
                                                                    awayGoalName
                                                                        .text,
                                                                time:
                                                                    awayGoalTime
                                                                        .text);
                                                            awayGoalHistory
                                                                .add(p);
                                                            awayGoalName
                                                                .clear();
                                                            awayGoalTime
                                                                .clear();
                                                            setState(() {});
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              awayGoalHistory.isEmpty
                                                  ? Text(
                                                      '골 넣은 사람 등록해주세요.',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .lightGreen),
                                                    )
                                                  : Row(
                                                      children: awayGoalHistory
                                                          .map((e) => InkWell(
                                                                onTap: () {
                                                                  awayGoalHistory
                                                                      .remove(
                                                                          e);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Text(
                                                                    '${e.name}, ${e.time}`',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                    )),
                                                              ))
                                                          .toList(),
                                                    ),
                                              Text(
                                                '어시스트 한사람',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                                width: 250,
                                                child: Row(
                                                  children: [
                                                    Text('이름 : '),
                                                    SizedBox(
                                                        width: 70,
                                                        child: TextFormField(
                                                          controller:
                                                              awayAssistName,
                                                        )),
                                                    Text('시간 : '),
                                                    SizedBox(
                                                        width: 30,
                                                        child: TextFormField(
                                                          controller:
                                                              awayAssistTime,
                                                        )),
                                                    Text('분'),
                                                    IconButton(
                                                        onPressed: () {
                                                          if (awayAssistName
                                                                  .text
                                                                  .isNotEmpty &&
                                                              awayAssistTime
                                                                  .text
                                                                  .isNotEmpty) {
                                                            Player p = Player(
                                                                name:
                                                                    awayAssistName
                                                                        .text,
                                                                time:
                                                                    awayAssistTime
                                                                        .text);
                                                            awayAssistHistory
                                                                .add(p);
                                                            awayAssistName
                                                                .clear();
                                                            awayAssistTime
                                                                .clear();
                                                            setState(() {});
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              awayAssistHistory.isEmpty
                                                  ? Text(
                                                      '골 넣은 사람 등록해주세요.',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .lightGreen),
                                                    )
                                                  : Row(
                                                      children:
                                                          awayAssistHistory
                                                              .map(
                                                                  (e) =>
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          awayAssistHistory
                                                                              .remove(e);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: Text(
                                                                            '${e.name}, ${e.time}`',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                            )),
                                                                      ))
                                                              .toList(),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 100,
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('리그명',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 300,
                                  child: Autocomplete<String>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<String>.empty();
                                      }
                                      return _kLeagueNames
                                          .where((String option) {
                                        return option
                                            .contains(textEditingValue.text);
                                      });
                                    },
                                    onSelected: (String selection) {
                                      print('You select $selection');
                                      leagueName.text = selection;
                                      print('leagueName is ${leagueName.text}');
                                    },
                                    fieldViewBuilder: (context, controller,
                                        focusNode, onFieldSubmitted) {
                                      leagueName = controller;
                                      return TextFormField(
                                          controller: controller,
                                          focusNode: focusNode);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('경기장',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(controller: stadium),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('경기 시간',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(controller: matchTime),
                                ),
                              ],
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
                              onPressed: () async {
                                if (isResult) {
                                  if (homeTeamName.text == "" ||
                                      awayTeamName.text == "" ||
                                      homeScore.text == "" ||
                                      awayScore.text == "" ||
                                      leagueName.text == "" ||
                                      !isDateTimeSet) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('빈칸을 채워주세요!!!!!'),
                                      duration: Duration(seconds: 3),
                                    ));
                                  } else {
                                    switch (await postData(
                                      homeTeamName: homeTeamName.text,
                                      awayTeamName: awayTeamName.text,
                                      homeScore: int.parse(homeScore.text),
                                      awayScore: int.parse(awayScore.text),
                                      homeGoalHistory: homeGoalHistory,
                                      homeAssistHistory: homeAssistHistory,
                                      awayGoalHistory: awayGoalHistory,
                                      awayAssistHistory: awayAssistHistory,
                                      leagueName: leagueName.text,
                                      stadium: stadium.text,
                                      matchTime: matchTime.text,
                                      currentDate:
                                          currentDate.millisecondsSinceEpoch,
                                      password: widget.password,
                                    )) {
                                      case 1:
                                        print('submit completion');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('전송 완료'),
                                          duration: Duration(seconds: 3),
                                        ));
                                        initData();
                                        return;
                                      case 0:
                                        print('submit failure');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('전송 실패. 다시시도해주세요.'),
                                          duration: Duration(seconds: 3),
                                        ));
                                        return;
                                    }
                                  }
                                } else {
                                  if (homeTeamName.text == '' ||
                                      awayTeamName.text == '' ||
                                      leagueName.text == '' ||
                                      !isDateTimeSet) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('빈칸을 채워주세요!!!!!'),
                                      duration: Duration(seconds: 3),
                                    ));
                                  } else {
                                    switch (await postData(
                                        homeTeamName: homeTeamName.text,
                                        awayTeamName: awayTeamName.text,
                                        leagueName: leagueName.text,
                                        stadium: stadium.text,
                                        matchTime: matchTime.text,
                                        currentDate:
                                            currentDate.millisecondsSinceEpoch,
                                        password: widget.password)) {
                                      case 1:
                                        print('submit completion');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('전송 완료'),
                                          duration: Duration(seconds: 3),
                                        ));
                                        initData();
                                        return;
                                      case 0:
                                        print('submit failure');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('전송 실패. 다시시도해주세요.'),
                                          duration: Duration(seconds: 3),
                                        ));
                                        return;
                                    }
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
              )
            : Center(
                child: Text(
                  '서버 연결이 좋지 못합니다. 관리자에게 문의주세요',
                  style: TextStyle(fontSize: 20),
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
                if (value == '153153') {
                  widget.setHomeStatus('경기등록');
                  widget.setPasswordStatus(value);
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
