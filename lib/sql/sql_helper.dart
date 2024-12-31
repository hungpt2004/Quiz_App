import 'package:flutter/cupertino.dart';
import 'package:flutter_quiz_app/components/exception/cart_exception.dart';
import 'package:flutter_quiz_app/model/completed_quiz.dart';
import 'package:flutter_quiz_app/model/discount.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/cart.dart';
import '../model/cart_items.dart';
import '../model/favorite.dart';
import '../model/pin.dart';
import '../model/question.dart';
import '../model/quiz.dart';
import '../model/rank.dart';
import '../model/subject.dart';
import '../model/user.dart';
import '../model/type.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  //Singleton Constructor
  DBHelper._init();

  //U S E R -- T A B L E
  final tableUser = '''
    CREATE TABLE USER (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       rank_id INTEGER NOT NULL,
       name TEXT,
       username TEXT,
       password TEXT,
       email TEXT,
       phone TEXT,
       dob TEXT,
       url TEXT,
       total_score INTEGER,
       FOREIGN KEY (rank_id) REFERENCES RANK(id)
    );
  ''';

  //C O M P L E T E D -- T A B L E
  final tableCompletedQuiz = '''
    CREATE TABLE COMPLETED_QUIZ (
      user_id INTEGER,
      quiz_id INTEGER,
      score INTEGER,
      completed_at TEXT,
      paid_at TEXT,
      status TEXT CHECK (status IN ('lock', 'unlock','did')) DEFAULT 'lock',
      progress INTEGER,
      number_correct INTEGER,
      PRIMARY KEY (user_id, quiz_id),
      FOREIGN KEY (user_id) REFERENCES USER (id),
      FOREIGN KEY (quiz_id) REFERENCES QUIZ (id)
    );
  ''';

  //R A N K -- T A B L E
  final tableRank = '''
    CREATE TABLE RANK (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      min_score INTEGER
    );
  ''';

  //D I S C O U N T -- T A B L E
  final tableDiscount = '''
    CREATE TABLE DISCOUNT (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      rank_id INTEGER,
      name TEXT,
      value INTEGER,
      FOREIGN KEY (rank_id) REFERENCES RANK(id)
    );
  ''';

  //Q U I Z -- T A B L E
  final tableQuiz = '''
    CREATE TABLE QUIZ (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      title TEXT,
      is_paid INTEGER NOT NULL CHECK (is_paid IN (0, 1)),
      price INTEGER,
      user_id INTEGER,
      subject_id INTEGER,
      type_id INTEGER,
      created_at TEXT,
      url TEXT,
      isFavorite INTEGER NOT NULL CHECK (is_paid IN (0, 1)),
      FOREIGN KEY (user_id) REFERENCES USER(id),
      FOREIGN KEY (subject_id) REFERENCES SUBJECT(id),
      FOREIGN KEY (type_id) REFERENCES TYPE(id)
    );
  ''';

  //Q U E S T I O N -- T A B L E
  final tableQuestion = '''
    CREATE TABLE QUESTION (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      image_url TEXT,
      content TEXT NOT NULL,
      answer1 TEXT NOT NULL,
      answer2 TEXT NOT NULL,
      answer3 TEXT NOT NULL,
      answer4 TEXT NOT NULL,
      correct_answer INTEGER NOT NULL,
      quiz_id INTEGER NOT NULL,
      FOREIGN KEY (quiz_id) REFERENCES QUIZ (id)
    );
  ''';

  //T Y P E -- T A B L E
  final tableType = '''
    CREATE TABLE TYPE (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    );
  ''';

  //S U B J E C T -- T A B L E
  final tableSubject = '''
    CREATE TABLE SUBJECT (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
    );
  ''';

  //F E E D B A C K -- T A B L E
  final tableFeedback = '''
    CREATE TABLE FEEDBACK (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT,
      created_at TEXT,
      user_id INTEGER,
      quiz_id INTEGER,
      FOREIGN KEY (user_id) REFERENCES USER (id),
      FOREIGN KEY (quiz_id) REFERENCES QUIZ (id)
    );
  ''';

  //P I N
  final tablePin = '''
      CREATE TABLE PIN (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pin TEXT,
        created_at TEXT,
        expired_at TEXT,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES USER (id)
      );
  ''';

  //F A V O R I T E
  final tableFavorite = '''
      CREATE TABLE FAVORITE ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quiz_id INTEGER,
        user_id INTEGER,
        created_at TEXT,
        status TEXT CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
        FOREIGN KEY (user_id) REFERENCES USER (id),
        FOREIGN KEY (quiz_id) REFERENCES QUIZ (id)
      );
  ''';

  //C A R T
  final tableCart = '''
        CREATE TABLE CART (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES USER (id)
        );
  ''';

  //C A R T -- I T E M
  final tableCartItems = '''
        CREATE TABLE CART_ITEM (
          cart_id INTEGER,
          quiz_id INTEGER,
          quantity INTEGER,
          PRIMARY KEY (cart_id, quiz_id),
          FOREIGN KEY (cart_id) REFERENCES CART (id),
          FOREIGN KEY (quiz_id) REFERENCES QUIZ (id)
        )
  ''';

  //Create name database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('TAOMOI.db');
    return _database!;
  }

  //Get path database
  Future<Database> _initDatabase(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filePath);
    return openDatabase(path, version: 1, onCreate: _onCreateDatabase);
  }

  //On create database
  Future<void> _onCreateDatabase(Database db, int version) async {
    try {
      await db.execute(tableUser);
      await db.execute(tableRank);
      await db.execute(tableDiscount);
      await db.execute(tableQuiz);
      await db.execute(tableCompletedQuiz);
      await db.execute(tableQuestion);
      await db.execute(tableType);
      await db.execute(tableSubject);
      await db.execute(tableFeedback);
      await db.execute(tablePin);
      await db.execute(tableFavorite);
      await db.execute(tableCart);
      await db.execute(tableCartItems);

      print("DA TAO BANG");

      //INSERT
      await insertRanks(db);
      await insertUsers(db);
      await insertDiscounts(db);
      await insertSubjects(db);
      await insertTypes(db);
      await insertQuizzes(db);
      await insertQuestions(db);

      print("DA INSERT");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ----------------------------------------------------- I N S E R T ------------------------------------------------------

  // I N S E R T -- R A N K
  Future<void> insertRanks(Database db) async {
    final ranks = [
      {'name': 'Bronze', 'min_score': 0},
      {'name': 'Silver', 'min_score': 800},
      {'name': 'Gold', 'min_score': 2000},
      {'name': 'Diamond', 'min_score': 3000},
      {'name': 'Master', 'min_score': 5000},
    ];
    for (final rank in ranks) {
      await db.insert('RANK', rank);
    }
  }

  // I N S E R T -- U S E R
  Future<void> insertUsers(Database db) async {
    final users = [
      {
        'rank_id': 1,
        'name': 'John Doe',
        'username': 'johnjohntest',
        'password': '123',
        'email': 'johndoe@example.com',
        'phone': '1234567890',
        'dob': '1995-01-01',
        'url': 'https://randomuser.me/api/portraits/men/17.jpg',
        'total_score': 1200
      },
      {
        'rank_id': 2,
        'name': 'Jane Smith',
        'username': 'janequizpro',
        'password': '123',
        'email': 'janesmith@example.com',
        'phone': '0905256943',
        'dob': '1984-05-15',
        'url': 'https://randomuser.me/api/portraits/men/35.jpg',
        'total_score': 1500
      },
      {
        'rank_id': 3,
        'name': 'Pham Trong Hung',
        'username': 'hungpt',
        'password': '123',
        'email': 'hungptfpt2004@gmail.com',
        'phone': '0987654321',
        'dob': '2004-02-20',
        'url': 'https://randomuser.me/api/portraits/men/88.jpg',
        'total_score': 1500
      },
      {
        'rank_id': 4,
        'name': 'Kim Hoang Nguyen',
        'username': 'lkhnguyen',
        'password': '123',
        'email': 'haha@example.com',
        'phone': '0914259659',
        'dob': '2003-05-15',
        'url': 'https://randomuser.me/api/portraits/men/51.jpg',
        'total_score': 1500
      },
      {
        'rank_id': 5,
        'name': 'Duyen Truong Thien',
        'username': 'duyenttt',
        'password': '123',
        'email': 'janesmith@example.com',
        'phone': '0914234252',
        'dob': '2002-05-15',
        'url': 'https://randomuser.me/api/portraits/men/53.jpg',
        'total_score': 1500
      },
    ];
    for (final user in users) {
      await db.insert('USER', user);
    }
  }

  // I N S E R T -- Q U I Z
  Future<void> insertQuizzes(Database db) async {
    final quizzes = [
      // Quiz cho Java Programming
      {
        'title': 'Java Basics Quiz',
        'description': 'A quiz on basic Java programming concepts.',
        'price': 0, // Giá 0 vì là quiz miễn phí
        'user_id': 1, // Giả sử user_id = 1 tồn tại trong bảng USER
        'is_paid':0,
        'subject_id':
            1, // Giả sử subject_id = 1 là Java Programming trong bảng SUBJECT
        'type_id': 1, // Giả sử type_id = 1 là Multiple Choice
        'created_at': DateTime.now().toIso8601String(),
        'url':
            'https://simplycoding.in/wp-content/uploads/2021/06/Java-Theory-Java-Basics.jpg',
        'isFavorite': 0
      },
      {
        'title': 'Advanced Java Quiz',
        'description': 'A quiz on advanced Java programming concepts.',
        'price': 500, // Giá 500
        'is_paid':0,
        'user_id': 1, // Giả sử user_id = 1 tồn tại trong bảng USER
        'subject_id':
            1, // Giả sử subject_id = 1 là Java Programming trong bảng SUBJECT
        'type_id': 1, // Giả sử type_id = 1 là Multiple Choice
        'created_at': DateTime.now().toIso8601String(),
        'url':
            'https://techshark.co.in/wp-content/uploads/2020/06/591-5916423_advanced-java-logo-png-transparent-png.png',
        'isFavorite': 0
      },

      // Quiz cho Flutter Programming
      {
        'title': 'Flutter Basics Quiz',
        'description': 'A quiz on basic Flutter programming concepts.',
        'price': 0, // Giá 0 vì là quiz miễn phí
        'is_paid':0,
        'user_id': 2, // Giả sử user_id = 2 tồn tại trong bảng USER
        'subject_id':
            2, // Giả sử subject_id = 2 là Flutter Programming trong bảng SUBJECT
        'type_id': 1, // Giả sử type_id = 1 là Multiple Choice
        'created_at': DateTime.now().toIso8601String(),
        'url': 'https://i.ytimg.com/vi/6JSZYIyPzfw/maxresdefault.jpg',
        'isFavorite': 0
      },
      {
        'title': 'Advanced Flutter Quiz',
        'description': 'A quiz on advanced Flutter programming concepts.',
        'price': 1000, // Giá 1000
        'is_paid':0,
        'user_id': 2, // Giả sử user_id = 2 tồn tại trong bảng USER
        'subject_id':
            2, // Giả sử subject_id = 2 là Flutter Programming trong bảng SUBJECT
        'type_id': 1, // Giả sử type_id = 1 là Multiple Choice
        'created_at': DateTime.now().toIso8601String(),
        'url':
            'https://smazee.com/uploads/blog/How-to-Develop-Advanced-UI-in-Flutter.png',
        'isFavorite': 0
      },

      // Quiz cho Android Programming
      {
        'title': 'Android Basics Quiz',
        'description': 'A quiz on basic Android programming concepts.',
        'price': 0,    // Giá 0 vì là quiz miễn phí
        'is_paid':0,
        'user_id': 1,  // Giả sử user_id = 1 tồn tại trong bảng USER
        'subject_id': 3,  // Giả sử subject_id = 3 là Android Programming trong bảng SUBJECT
        'type_id': 1,  // Giả sử type_id = 1 là Multiple Choice
        'url':'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20210808001314/A-Complete-Guide-to-Learn-Android-Studio-for-Android-App-Development.png',
        'created_at': DateTime.now().toIso8601String(),
        'isFavorite': 0
      },
      {
        'title': 'Advanced Android Quiz',
        'description': 'A quiz on advanced Android programming concepts.',
        'price': 800,  // Giá 800
        'is_paid':0,
        'user_id': 1,  // Giả sử user_id = 1 tồn tại trong bảng USER
        'subject_id': 3,  // Giả sử subject_id = 3 là Android Programming trong bảng SUBJECT
        'type_id': 1,  // Giả sử type_id = 1 là Multiple Choice
        'url': 'https://th.bing.com/th/id/OIP.BQz-M74zVrcHIHJ0LOfBoQHaEK?rs=1&pid=ImgDetMain',
        'created_at': DateTime.now().toIso8601String(),
        'isFavorite': 0
      },

      // // Quiz cho IOS Programming
      {
        'title': 'iOS Basics Quiz',
        'description': 'A quiz on basic iOS programming concepts.',
        'price': 0,    // Giá 0 vì là quiz miễn phí
        'is_paid':0,
        'user_id': 2,  // Giả sử user_id = 2 tồn tại trong bảng USER
        'subject_id': 4,  // Giả sử subject_id = 4 là iOS Programming trong bảng SUBJECT
        'type_id': 1,  // Giả sử type_id = 1 là Multiple Choice
        'url': 'https://www.sourcecodester.com/sites/default/files/images/admin/complete_ios_developer_course.jpg',
        'created_at': DateTime.now().toIso8601String(),
        'isFavorite': 0
      },

      {
        'title': 'Advanced iOS Quiz',
        'description': 'A quiz on advanced iOS programming concepts.',
        'price': 1200, // Giá 1200
        'is_paid':0,
        'user_id': 2,  // Giả sử user_id = 2 tồn tại trong bảng USER
        'subject_id': 4,  // Giả sử subject_id = 4 là iOS Programming trong bảng SUBJECT
        'type_id': 1,  // Giả sử type_id = 1 là Multiple Choice
        'url':'https://th.bing.com/th/id/OIP.whnYhraGunxltS2fMGmjXgHaFj?rs=1&pid=ImgDetMain',
        'created_at': DateTime.now().toIso8601String(),
        'isFavorite': 0
      },

      {
        'title': 'JLPT N3 MojiGoi',
        'description': 'A quiz for JLPT prepare',
        'price': 0, // Giá 1500
        'is_paid':0,
        'user_id': 3, // Giả sử user_id = 1 tồn tại trong bảng USER
        'subject_id': 6, // Giả sử subject_id = 8 là IELTS trong bảng SUBJECT
        'type_id': 1,
        'created_at': DateTime.now().toIso8601String(),
        'url':
        'https://th.bing.com/th/id/OIP.1gfw2UjZPFzzfywnVAyJWwHaEK?rs=1&pid=ImgDetMain',
        'isFavorite': 0
      },
      {
        'title': 'JLPT N3 Advanced Grammar',
        'description': 'A quiz for JLPT prepare',
        'price': 2000, // Giá 1500
        'is_paid':0,
        'user_id': 3, // Giả sử user_id = 1 tồn tại trong bảng USER
        'subject_id': 6,
        'type_id': 1,
        'created_at': DateTime.now().toIso8601String(),
        'url':
        'https://th.bing.com/th/id/OIP.M74j2p_30LB285aA1zdk6AAAAA?rs=1&pid=ImgDetMain',
        'isFavorite': 0
      },

      // Quiz cho Ielts

      {
        'title': 'IELTS Listening Quiz',
        'description': 'A quiz on IELTS Listening skills.',
        'price': 0, // Giá 0 vì là quiz miễn phí
        'is_paid':0,
        'user_id': 3, // Giả sử user_id = 1 tồn tại trong bảng USER
        'subject_id': 8, // Giả sử subject_id = 8 là IELTS trong bảng SUBJECT
        'type_id': 1, // Giả sử type_id = 2 là True/False
        'created_at': DateTime.now().toIso8601String(),
        'url': 'https://smiletutor.sg/wp-content/uploads/2017/06/IELTS.png',
        'isFavorite': 0
      },
      {
        'title': 'IELTS Reading Quiz',
        'description': 'A quiz on IELTS Reading skills.',
        'price': 1500, // Giá 1500
        'is_paid':0,
        'user_id': 3, // Giả sử user_id = 1 tồn tại trong bảng USER
        'subject_id': 8, // Giả sử subject_id = 8 là IELTS trong bảng SUBJECT
        'type_id': 1,
        'created_at': DateTime.now().toIso8601String(),
        'url':
            'https://th.bing.com/th/id/R.d7d7c6badeb9be43fdd45e326f69e76b?rik=PqiifBJR%2f8I9VQ&pid=ImgRaw&r=0',
        'isFavorite': 0
      },
    ];

    for (final quiz in quizzes) {
      await db.insert('QUIZ', quiz);
    }
  }

  // I N S E R T -- Q U E S T I O N
  Future<void> insertQuestions(Database db) async {
    final questions = [
      // Câu hỏi cho Quiz "Java Basics Quiz" (subject_id = 1)
      {
        'image_url': null,
        'quiz_id': 1, // Giả sử quiz_id = 1 là "Java Basics Quiz"
        'content': 'What is the size of an int in Java?',
        'answer1': '2 bytes',
        'answer2': '4 bytes',
        'answer3': '8 bytes',
        'answer4': '16 bytes',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 1, // Giả sử quiz_id = 1 là "Java Basics Quiz"
        'content': 'What is the default value of a boolean in Java?',
        'answer1': 'true',
        'answer2': 'false',
        'answer3': 'null',
        'answer4': '0',
        'correct_answer': 2, // Câu trả lời đúng là answer2 (false)
      },
      {
        'image_url': null,
        'quiz_id': 1, // Giả sử quiz_id = 1 là "Java Basics Quiz"
        'content': 'What is a part of OOP in Java?',
        'answer1': 'Encapsulation',
        'answer2': 'Consistency',
        'answer3': 'Immutable',
        'answer4': 'None of above',
        'correct_answer': 1, // Câu trả lời đúng là answer2 (false)
      },
      {
        'image_url': null,
        'quiz_id': 1, // Giả sử quiz_id = 1 là "Java Basics Quiz"
        'content': 'How many definition of Access Modifier?',
        'answer1': '4',
        'answer2': '3',
        'answer3': '2',
        'answer4': '1',
        'correct_answer': 1, // Câu trả lời đúng là answer2 (false)
      },
      {
        'image_url': null,
        'quiz_id': 1, // Giả sử quiz_id = 1 là "Java Basics Quiz"
        'content': 'What is the different between Static & Private?',
        'answer1': 'No have Static access',
        'answer2': 'Static and Private same',
        'answer3': 'Static for all class, Private for initialize\'s class',
        'answer4': 'None of above',
        'correct_answer': 3, // Câu trả lời đúng là answer2 (false)
      },

      // Câu hỏi cho Quiz "Advanced Java Quiz" (subject_id = 1)
      {
        'image_url': null,
        'quiz_id': 2, // Giả sử quiz_id = 2 là "Advanced Java Quiz"
        'content': 'What is the purpose of the final keyword in Java?',
        'answer1': 'To define a constant',
        'answer2': 'To stop inheritance',
        'answer3': 'To mark a class as abstract',
        'answer4': 'To declare a static variable',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 2, // Giả sử quiz_id = 2 là "Advanced Java Quiz"
        'content': 'Which of the following is a feature of Java?',
        'answer1': 'Platform-independent',
        'answer2': 'Code is executed directly by the CPU',
        'answer3': 'Requires a specific operating system',
        'answer4': 'None of the above',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 2, // Giả sử quiz_id = 2 là "Advanced Java Quiz"
        'content': 'What is the difference between "=="" and "equals()" in Java?',
        'answer1': '== compares object references, equals() compares object values',
        'answer2': '== compares object values, equals() compares object references',
        'answer3': 'Both compare object values',
        'answer4': 'Both compare object references',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 2, // Giả sử quiz_id = 2 là "Advanced Java Quiz"
        'content': 'Which keyword is used to handle exceptions in Java?',
        'answer1': 'throw',
        'answer2': 'catch',
        'answer3': 'try',
        'answer4': 'final',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 2, // Giả sử quiz_id = 2 là "Advanced Java Quiz"
        'content': 'What is the purpose of the transient keyword in Java?',
        'answer1': 'To prevent serialization of a variable',
        'answer2': 'To make a variable constant',
        'answer3': 'To mark a variable as synchronized',
        'answer4': 'To make a variable final',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 2, // Giả sử quiz_id = 2 là "Advanced Java Quiz"
        'content': 'What is the output of the following code: "System.out.println(10/3);"?',
        'answer1': '3.0',
        'answer2': '3',
        'answer3': '3.33',
        'answer4': 'Compilation error',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 2, // Giả sử quiz_id = 2 là "Advanced Java Quiz"
        'content': 'Which of the following is true about Java interfaces?',
        'answer1': 'An interface can contain only abstract methods',
        'answer2': 'An interface can contain both abstract and non-abstract methods',
        'answer3': 'An interface can contain only non-abstract methods',
        'answer4': 'An interface cannot have any methods',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },


      //Flutter Basics Quiz
      {
        'image_url': null,
        'quiz_id': 3, // Giả sử quiz_id = 3 là "Flutter Basics Quiz"
        'content': 'What is the main programming language used for Flutter?',
        'answer1': 'Java',
        'answer2': 'Kotlin',
        'answer3': 'Dart',
        'answer4': 'Swift',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 3, // Giả sử quiz_id = 3 là "Flutter Basics Quiz"
        'content':
            'Which widget is used to create a scrollable view in Flutter?',
        'answer1': 'Column',
        'answer2': 'Row',
        'answer3': 'ListView',
        'answer4': 'Container',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 3, // Giả sử quiz_id = 3 là "Flutter Basics Quiz"
        'content': 'What does the "hot reload" feature do in Flutter?',
        'answer1': 'Reloads the entire application',
        'answer2': 'Only reloads the UI without losing the state',
        'answer3': 'Stops the application',
        'answer4': 'Clears all app data',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 3, // Giả sử quiz_id = 3 là "Flutter Basics Quiz"
        'content': 'Which of the following is a stateless widget in Flutter?',
        'answer1': 'StatefulWidget',
        'answer2': 'Text',
        'answer3': 'Form',
        'answer4': 'Container',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 3, // Giả sử quiz_id = 3 là "Flutter Basics Quiz"
        'content': 'What is the purpose of the Scaffold widget in Flutter?',
        'answer1': 'To create the app\'s layout structure',
        'answer2': 'To display a dialog box',
        'answer3': 'To manage app states',
        'answer4': 'To handle navigation',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 3, // Giả sử quiz_id = 3 là "Flutter Basics Quiz"
        'content': 'Which method is used to run a Flutter app?',
        'answer1': 'runApp()',
        'answer2': 'startApp()',
        'answer3': 'initializeApp()',
        'answer4': 'beginApp()',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 3, // Giả sử quiz_id = 3 là "Flutter Basics Quiz"
        'content': 'What is the default size of the main app window in Flutter?',
        'answer1': 'Fixed size',
        'answer2': 'Full screen',
        'answer3': 'Flexible based on content',
        'answer4': 'Undefined',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },

      //Flutter Advanced Quiz
      {
        'image_url': null,
        'quiz_id': 4,
        'content':
            'Which is the most difficult state management type in Flutter ?',
        'answer1': 'BloC',
        'answer2': 'Block',
        'answer3': 'Supply',
        'answer4': 'State',
        'correct_answer': 1, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 4,
        'content': 'What is the role of FutureBuilder in Flutter?',
        'answer1': 'Lazy Loading',
        'answer2': 'Async Wait',
        'answer3': 'I don\'t know',
        'answer4': 'None of above',
        'correct_answer': 2, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 4, // Advanced Flutter Quiz
        'content': 'What is the purpose of the `StreamBuilder` widget in Flutter?',
        'answer1': 'To display a stream of data over time',
        'answer2': 'To handle asynchronous operations',
        'answer3': 'To optimize UI performance',
        'answer4': 'To store data in memory',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 4, // Advanced Flutter Quiz
        'content': 'What is the advantage of using the `FlutterProvider` package?',
        'answer1': 'It simplifies the management of state across the app',
        'answer2': 'It provides a faster compilation time',
        'answer3': 'It improves the UI rendering performance',
        'answer4': 'None of the above',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 4, // Advanced Flutter Quiz
        'content': 'Which of the following is true about Flutter\'s Hot Reload feature?',
        'answer1': 'It allows you to instantly see changes in the app without restarting the app',
        'answer2': 'It restarts the entire app every time a change is made',
        'answer3': 'It only works for UI updates, not for logic updates',
        'answer4': 'It is only available for Android development',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 4, // Advanced Flutter Quiz
        'content': 'Which method is used to navigate between different screens in Flutter?',
        'answer1': 'Navigator.push()',
        'answer2': 'Screen.transition()',
        'answer3': 'Navigator.transition()',
        'answer4': 'Route.push()',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 4, // Advanced Flutter Quiz
        'content': 'What does the `async` keyword in Dart do?',
        'answer1': 'Indicates that a function is asynchronous and can be awaited',
        'answer2': 'It is used to start a new thread of execution',
        'answer3': 'It marks a function as blocking',
        'answer4': 'None of the above',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },

      //Android Basic
      {
        'image_url': null,
        'quiz_id': 5, // Android Basics Quiz
        'content': 'What is the main purpose of the `onCreate()` method in an Android Activity?',
        'answer1': 'To initialize the activity and set up the user interface',
        'answer2': 'To save data before the activity is destroyed',
        'answer3': 'To handle background tasks',
        'answer4': 'To create a new instance of the activity',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 5, // Android Basics Quiz
        'content': 'Which component is used to handle background tasks in Android?',
        'answer1': 'Activity',
        'answer2': 'Service',
        'answer3': 'BroadcastReceiver',
        'answer4': 'ContentProvider',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 5, // Android Basics Quiz
        'content': 'What does the `Intent` class do in Android?',
        'answer1': 'Handles user input',
        'answer2': 'Starts activities or services and communicates between components',
        'answer3': 'Manages device memory',
        'answer4': 'Handles UI events',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 5, // Android Basics Quiz
        'content': 'Which layout is best for creating a list of items in Android?',
        'answer1': 'RelativeLayout',
        'answer2': 'LinearLayout',
        'answer3': 'FrameLayout',
        'answer4': 'RecyclerView',
        'correct_answer': 4, // Câu trả lời đúng là answer4
      },
      {
        'image_url': null,
        'quiz_id': 5, // Android Basics Quiz
        'content': 'Which file in Android is responsible for defining app resources like strings, colors, and dimensions?',
        'answer1': 'AndroidManifest.xml',
        'answer2': 'strings.xml',
        'answer3': 'gradle.properties',
        'answer4': 'build.gradle',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },

      //Android Advanced
      {
        'image_url': null,
        'quiz_id': 6, // Advanced Android Quiz
        'content': 'What is the purpose of `LiveData` in Android?',
        'answer1': 'To represent the UI layer of an app',
        'answer2': 'To manage background tasks',
        'answer3': 'To hold data that is lifecycle-aware and can be observed',
        'answer4': 'To handle network requests',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 6, // Advanced Android Quiz
        'content': 'Which of the following is used for dependency injection in Android?',
        'answer1': 'Dagger',
        'answer2': 'Retrofit',
        'answer3': 'Glide',
        'answer4': 'SQLite',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 6, // Advanced Android Quiz
        'content': 'What is the purpose of the `ViewModel` class in Android?',
        'answer1': 'To store and manage UI-related data in a lifecycle-conscious way',
        'answer2': 'To manage background tasks',
        'answer3': 'To hold UI logic and navigation',
        'answer4': 'To handle user input in the UI layer',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 6, // Advanced Android Quiz
        'content': 'What is `Coroutines` used for in Android development?',
        'answer1': 'To handle UI interactions',
        'answer2': 'To handle background tasks and concurrency',
        'answer3': 'To manage user authentication',
        'answer4': 'To handle network requests',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 6, // Advanced Android Quiz
        'content': 'What is `Room` used for in Android?',
        'answer1': 'For managing UI components',
        'answer2': 'For storing data in SQLite database',
        'answer3': 'For handling network operations',
        'answer4': 'For creating notifications',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },

      //ios basic
      {
        'image_url': null,
        'quiz_id': 7, // iOS Basic Quiz
        'content': 'Which programming language is used for iOS development?',
        'answer1': 'Swift',
        'answer2': 'Kotlin',
        'answer3': 'Java',
        'answer4': 'C#',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 7, // iOS Basic Quiz
        'content': 'What is the default UI framework for iOS?',
        'answer1': 'UIKit',
        'answer2': 'SwiftUI',
        'answer3': 'React Native',
        'answer4': 'Flutter',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 7, // iOS Basic Quiz
        'content': 'Which of the following is used for creating layouts in iOS?',
        'answer1': 'XML',
        'answer2': 'Storyboard',
        'answer3': 'XAML',
        'answer4': 'HTML',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 7, // iOS Basic Quiz
        'content': 'Which of the following is a lifecycle method in a UIViewController?',
        'answer1': 'viewWillAppear',
        'answer2': 'onCreate',
        'answer3': 'onResume',
        'answer4': 'viewDidLoad',
        'correct_answer': 4, // Câu trả lời đúng là answer4
      },
      {
        'image_url': null,
        'quiz_id': 7, // iOS Basic Quiz
        'content': 'Which of the following is used to navigate between different screens in iOS?',
        'answer1': 'Intent',
        'answer2': 'Activity',
        'answer3': 'Navigation Controller',
        'answer4': 'ViewController',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },

      //ios advanced
      {
        'image_url': null,
        'quiz_id': 8, // iOS Advanced Quiz
        'content': 'What is the purpose of the `Combine` framework in iOS?',
        'answer1': 'To manage concurrency',
        'answer2': 'To manage user interface updates',
        'answer3': 'To handle asynchronous events using reactive programming',
        'answer4': 'To create RESTful APIs',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 8, // iOS Advanced Quiz
        'content': 'Which of the following is used for dependency injection in iOS?',
        'answer1': 'Core Data',
        'answer2': 'SwiftUI',
        'answer3': 'Swinject',
        'answer4': 'AVFoundation',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 8, // iOS Advanced Quiz
        'content': 'What is the purpose of `Grand Central Dispatch (GCD)` in iOS?',
        'answer1': 'To handle memory management',
        'answer2': 'To manage background tasks and concurrency',
        'answer3': 'To build user interfaces',
        'answer4': 'To handle data storage',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 8, // iOS Advanced Quiz
        'content': 'Which of the following is used to manage network requests in iOS?',
        'answer1': 'Core Data',
        'answer2': 'Alamofire',
        'answer3': 'ARKit',
        'answer4': 'CloudKit',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 8, // iOS Advanced Quiz
        'content': 'Which of the following is used to store data locally in iOS?',
        'answer1': 'UserDefaults',
        'answer2': 'Core Data',
        'answer3': 'SQLite',
        'answer4': 'All of the above',
        'correct_answer': 4, // Câu trả lời đúng là answer4
      },


      //JLPT N3 basic
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': 'どんな時に「ありがとう」と言いますか？',
        'answer1': '何かをお願いした時',
        'answer2': '何かをもらった時',
        'answer3': '相手に怒った時',
        'answer4': '何もない時',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「食べる」の丁寧な言い方はどれですか？',
        'answer1': '食べます',
        'answer2': '食べる',
        'answer3': '食べた',
        'answer4': '食べている',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「元気」の反対の意味は何ですか？',
        'answer1': '元気',
        'answer2': '病気',
        'answer3': '疲れ',
        'answer4': '幸せ',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「静か」の反対の意味は何ですか？',
        'answer1': 'にぎやか',
        'answer2': '静けさ',
        'answer3': '早い',
        'answer4': '強い',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「時々」の同じ意味はどれですか？',
        'answer1': 'いつも',
        'answer2': 'たまに',
        'answer3': '毎日',
        'answer4': 'しばらく',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「電車を降りる」の意味は何ですか？',
        'answer1': '電車に乗る',
        'answer2': '電車を待つ',
        'answer3': '電車を降りる',
        'answer4': '電車を運転する',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「先生」の意味は何ですか？',
        'answer1': '学生',
        'answer2': '教師',
        'answer3': '親',
        'answer4': '友達',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「今日」の読み方はどれですか？',
        'answer1': 'きょう',
        'answer2': 'こんな',
        'answer3': 'いま',
        'answer4': 'あさ',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「速い」の反対の意味は何ですか？',
        'answer1': '速い',
        'answer2': '遅い',
        'answer3': '早い',
        'answer4': '強い',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 9, // JLPT N3 Moji Goi Quiz
        'content': '「図書館」の意味は何ですか？',
        'answer1': '本を読む場所',
        'answer2': '本を売る場所',
        'answer3': '本を借りる場所',
        'answer4': '本を作る場所',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },

      //JLPT for advanced
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜はずです」の意味は何ですか？',
        'answer1': '予想する',
        'answer2': '意志を表す',
        'answer3': '理由を説明する',
        'answer4': '提案をする',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜てもいいですか？」の使い方はどれですか？',
        'answer1': '許可を求める',
        'answer2': '提案をする',
        'answer3': '断る',
        'answer4': '希望を伝える',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜がする」の意味は何ですか？',
        'answer1': '物がある',
        'answer2': '物の名前を言う',
        'answer3': '感覚を表す',
        'answer4': '物を作る',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜そうです」の意味は何ですか？',
        'answer1': '予想を表す',
        'answer2': '見た目を表す',
        'answer3': '提案を表す',
        'answer4': '過去を表す',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜たばかりです」の意味は何ですか？',
        'answer1': '何かをしている途中である',
        'answer2': '最近何かをしたばかりである',
        'answer3': '過去のことを話す',
        'answer4': '何かをする予定である',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜ようにする」の意味は何ですか？',
        'answer1': '何かをするために努力する',
        'answer2': '何かをしないように努力する',
        'answer3': '何かをする予定である',
        'answer4': '何かをしないと決める',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜たことがある」の意味は何ですか？',
        'answer1': '何かをした経験がある',
        'answer2': '何かをしたことがない',
        'answer3': '何かをした途中である',
        'answer4': '何かをしたばかりである',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜ので」の意味は何ですか？',
        'answer1': '原因や理由を表す',
        'answer2': '相手の意見を求める',
        'answer3': '時期を表す',
        'answer4': '感情を表す',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜ために」の意味は何ですか？',
        'answer1': '目的を表す',
        'answer2': '理由を表す',
        'answer3': '結果を表す',
        'answer4': '時間を表す',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 10, // JLPT N3 Ngữ Pháp Advanced Quiz
        'content': '「〜なければならない」の意味は何ですか？',
        'answer1': '義務を表す',
        'answer2': '希望を表す',
        'answer3': '提案を表す',
        'answer4': '許可を表す',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },


      // Câu hỏi cho Quiz "IELTS Listening Quiz" (subject_id = 8)
      {
        'image_url': null,
        'quiz_id': 11,
        'content':
            'In the IELTS listening test, what is the maximum number of speakers you will hear?',
        'answer1': '1',
        'answer2': '2',
        'answer3': '3',
        'answer4': '4',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 11,
        'content': 'What is the main focus of the IELTS listening test?',
        'answer1': 'Listening for general understanding',
        'answer2': 'Listening for specific information',
        'answer3': 'Listening for grammar',
        'answer4': 'Listening for pronunciation',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. What is the speaker\'s favorite hobby?',
        'answer1': 'Reading books',
        'answer2': 'Playing football',
        'answer3': 'Cooking',
        'answer4': 'Swimming',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. What time does the meeting start?',
        'answer1': '9:00 AM',
        'answer2': '9:30 AM',
        'answer3': '10:00 AM',
        'answer4': '10:30 AM',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. What did the speaker forget to bring?',
        'answer1': 'Umbrella',
        'answer2': 'Laptop',
        'answer3': 'Documents',
        'answer4': 'Phone charger',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. What is the speaker\'s opinion about the new restaurant?',
        'answer1': 'It\'s too expensive',
        'answer2': 'The food is delicious',
        'answer3': 'The service is bad',
        'answer4': 'It\'s not worth visiting',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. How does the speaker travel to work?',
        'answer1': 'By car',
        'answer2': 'By bus',
        'answer3': 'By bicycle',
        'answer4': 'By train',
        'correct_answer': 4, // Câu trả lời đúng là answer4
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. Where is the speaker going for vacation?',
        'answer1': 'Beach resort',
        'answer2': 'Mountain town',
        'answer3': 'Big city',
        'answer4': 'Countryside',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. What is the speaker worried about?',
        'answer1': 'The weather',
        'answer2': 'Their health',
        'answer3': 'The presentation',
        'answer4': 'The flight',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. What does the speaker like most about their job?',
        'answer1': 'The salary',
        'answer2': 'The colleagues',
        'answer3': 'The flexibility',
        'answer4': 'The challenges',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. What event is the speaker attending this weekend?',
        'answer1': 'A wedding',
        'answer2': 'A concert',
        'answer3': 'A conference',
        'answer4': 'A football match',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 11, // IELTS Listening Test
        'content': 'Listen to the recording and choose the correct answer. How does the speaker feel about the upcoming exam?',
        'answer1': 'Confident',
        'answer2': 'Anxious',
        'answer3': 'Excited',
        'answer4': 'Indifferent',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },


      // Câu hỏi cho Quiz "IELTS Reading Quiz" (subject_id = 8)
      {
        'image_url': null,
        'quiz_id': 12,
        'content':
            'In the IELTS reading test, what type of questions are commonly asked?',
        'answer1': 'Multiple choice questions',
        'answer2': 'True/False/Not Given questions',
        'answer3': 'Matching headings to paragraphs',
        'answer4': 'All of the above',
        'correct_answer': 4, // Câu trả lời đúng là answer4
      },
      {
        'image_url': null,
        'quiz_id': 12,
        'content':
            'What is the purpose of the "True/False/Not Given" questions in the IELTS reading test?',
        'answer1': 'To test understanding of details and facts',
        'answer2': 'To test vocabulary knowledge',
        'answer3': 'To assess your ability to understand the writer\'s opinion',
        'answer4':
            'To check your ability to identify the meaning of specific words',
        'correct_answer': 1,
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. What is the main purpose of the passage?',
        'answer1': 'To inform the reader about a scientific discovery',
        'answer2': 'To describe a historical event',
        'answer3': 'To explain a process',
        'answer4': 'To entertain the reader',
        'correct_answer': 3, // Câu trả lời đúng là answer3
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. What is the author’s opinion on climate change?',
        'answer1': 'It is not a serious issue',
        'answer2': 'It requires immediate action',
        'answer3': 'It is a natural phenomenon',
        'answer4': 'It will not affect future generations',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. What is the definition of "sustainability" according to the text?',
        'answer1': 'The ability to use resources without depleting them',
        'answer2': 'The process of reducing waste',
        'answer3': 'The creation of renewable energy',
        'answer4': 'The preservation of historical sites',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. What is the main challenge in the field of artificial intelligence?',
        'answer1': 'The cost of development',
        'answer2': 'The ethical concerns',
        'answer3': 'The lack of skilled workers',
        'answer4': 'The technological limitations',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. According to the passage, what is a potential benefit of renewable energy?',
        'answer1': 'It is more expensive than traditional energy',
        'answer2': 'It reduces environmental impact',
        'answer3': 'It is difficult to implement on a large scale',
        'answer4': 'It causes more pollution',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. What is the significance of the research mentioned in the passage?',
        'answer1': 'It proves the effectiveness of a new medicine',
        'answer2': 'It provides insight into human behavior',
        'answer3': 'It solves a major environmental problem',
        'answer4': 'It explores new technology for space exploration',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. What is one of the challenges faced by urban areas?',
        'answer1': 'Lack of employment opportunities',
        'answer2': 'Overpopulation and congestion',
        'answer3': 'High levels of pollution',
        'answer4': 'Limited access to education',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. What does the author suggest as a solution to the issue discussed in the passage?',
        'answer1': 'Investing in new technologies',
        'answer2': 'Improving public awareness',
        'answer3': 'Implementing stricter laws',
        'answer4': 'Focusing on education and training',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. What does the term "globalization" refer to in the text?',
        'answer1': 'The process of cultures becoming more similar',
        'answer2': 'The increasing integration of economies',
        'answer3': 'The spread of technology worldwide',
        'answer4': 'The rise of international organizations',
        'correct_answer': 2, // Câu trả lời đúng là answer2
      },
      {
        'image_url': null,
        'quiz_id': 12, // IELTS Reading
        'content': 'Read the passage and choose the correct answer. How does the author describe the future of technology?',
        'answer1': 'Bright and full of possibilities',
        'answer2': 'Uncertain and unpredictable',
        'answer3': 'Dangerous and risky',
        'answer4': 'Confusing and complex',
        'correct_answer': 1, // Câu trả lời đúng là answer1
      }

    ];

    for (final question in questions) {
      await db.insert('QUESTION', question);
    }
  }

  // I N S E R T -- C O M P L E T E -- Q U I Z

  // I N S E R T -- F E E D B A C K

  // I N S E R T -- D I S C O U N T

  Future<void> insertDiscounts(Database db) async {
    final discounts = [
      {
        'name': 'Try to upgrade rank',
        'value': 10,
        'rank_id': 1,
      },
      {
        'name': 'Welcome to Silver Member',
        'value': 20,
        'rank_id': 2,
      },
      {
        'name': 'Master Quiz',
        'value': 60,
        'rank_id': 5,
      },
    ];
    for (final discount in discounts) {
      await db.insert('DISCOUNT', discount);
    }
  }

  // I N S E R T -- T Y P E
  Future<void> insertTypes(Database db) async {
    final types = [
      {'name': 'Multiple Choice'},
      {'name': 'True/False'},
    ];
    for (final type in types) {
      await db.insert('TYPE', type);
    }
  }

  // I N S E R T -- S U B J E C T
  Future<void> insertSubjects(Database db) async {
    final subjects = [
      {'name': 'Java Programming'},
      {'name': 'Flutter Programming'},
      {'name': 'Android Programming'},
      {'name': 'IOS Programming'},
      {'name': 'Chinese HSK3'},
      {'name': 'Japanese JLPT N3'},
      {'name': 'Japanese JLPT N4'},
      {'name': 'Ielts'},
    ];
    for (final subject in subjects) {
      await db.insert('SUBJECT', subject);
    }
  }

  //------------------------------------------------------ F U N C T I O N -------------------------------------------------

  // A D D -- U S E R
  Future<int> addNewUser(User user) async {
    List<Map<String, dynamic>> users = await getAllUser();
    for (Map<String, dynamic> u in users) {
      if (u['username'] == user.username) {
        throw Exception("Username already exists");
      } else if (u['email'] == user.email) {
        throw Exception("Email already exists");
      }
    }
    final db = await instance.database;
    return db.insert('USER', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateRankByScore(int score, int userId) async {
    final db = await instance.database;
    final rankList = await getAllRank();
    int newRankId = 0;

    for (var r in rankList) {
      if (score > r['min_score']) {
        newRankId = r['id'];
      } else {
        break;
      }
    }

    if (newRankId != 0) {
      return db.update('USER', {'rank_id': newRankId},
          where: 'id = ?', whereArgs: [userId]);
    }
    return 0;
  }

  // U P D A T E -- U S E R
  Future<int> updateUser(User user, int userId) async {
    final db = await instance.database;
    try {
      return db
          .update('USER', user.toMap(), where: 'id = ?', whereArgs: [userId]);
    } catch (e) {
      throw Exception('Update user error!');
    }
  }

  Future<int> updateAvatar(String url, int userId) async {
    final db = await instance.database;
    try {
      return db.update('USER', {'url': url},
          where: 'id = ?', whereArgs: [userId]);
    } catch (e) {
      throw Exception('Update image error!');
    }
  }

  Future<int> updateName(String name, int userId) async {
    final db = await instance.database;
    try {
      return db.update('USER', {'name': name},
          where: 'id = ?', whereArgs: [userId]);
    } catch (e) {
      throw Exception('Update new name error!');
    }
  }

  Future<int> updateDob(String dob, int userId) async {
    final db = await instance.database;
    try {
      return db.update('USER', {'dob': dob},
          where: 'id = ?', whereArgs: [userId]);
    } catch (e) {
      throw Exception('Update new dob error!');
    }
  }

  // U P D A T E -- P A S S W O R D
  Future<int> updatePasswordUser(String email, String newPassword) async {
    final db = await instance.database;
    User? user = await getUserByEmail(email);
    String oldPassword = user!.password;
    if (oldPassword == newPassword) {
      throw Exception('Please enter different the old password');
    }
    return db.update('USER', {'password': newPassword},
        where: 'id = ?', whereArgs: [user!.id]);
  }

  Future<int> updateUserTotalScore(int score, int userId) async {
    final db = await instance.database;
    try {
      return await db.update('USER', {'total_score': score},
          where: 'id = ?', whereArgs: [userId]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // G E T - A L L - U S E R
  Future<List<Map<String, dynamic>>> getAllUser() async {
    final db = await instance.database;
    return db.query('USER');
  }

  // G E T - A L L - U S E R - DESC
  Future<List<Map<String, dynamic>>> getAllUserByDesc() async {
    final db = await instance.database;
    return db.query('USER', orderBy: 'total_score DESC');
  }

  // G E T - U S E R - B Y - N A M E
  Future<User?> getUserByUsername(String username) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> users =
        await db.query('USER', where: 'username = ?', whereArgs: [username]);
    if (users.isNotEmpty) {
      //Chuyen phan tu dau tien cua map -> doi tuong
      return User.fromMap(users.first);
    }
    return null;
  }

  // G E T - U S E R - B Y - E M A I L
  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> users =
        await db.query('USER', where: 'email = ?', whereArgs: [email]);
    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    }
    return null;
  }

  // G E T _ P A S S W O R D - B Y - U S E R - I D
  Future<String> getPasswordByUserId(String email) async {
    final db = await instance.database;
    User? user = await getUserByEmail(email);
    return user!.password;
  }

  // G E T - U S E R - B Y - I D
  Future<User?> getUserById(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> users =
        await db.query('USER', where: 'id = ?', whereArgs: [id]);
    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    }
    return null;
  }

  // [ P I N ]
  Future<int> addNewPin(String password, String email) async {
    final db = await instance.database;
    User? user = await getUserByEmail(email);
    if (user != null) {
      Pin? getPin = await getPinByUserId(user.id!);
      if (getPin != null) {
        print("PIN existed");
        //CHECK TIME
        DateTime realTime = DateTime.now();
        if (realTime.isAfter(getPin.expiredAt!)) {
          await deletePinByPinId(getPin.id!);
          print("DELETE EXPIRED PIN");

          //CREATE NEW PIN
          Pin newPin = Pin(userId: user.id!, pinCode: password);

          await db.insert('PIN', newPin.toMap());
          print('DA INSERT NEW PIN');
          return 1;
        } else {
          throw Exception('Error already request for $email');
        }
      } else {
        print("DANG O DAY");
        Pin newPin = Pin(userId: user.id!, pinCode: password);
        await db.insert('PIN', newPin.toMap());
        print('DA INSERT NEW PIN NULL');
        return 1;
      }
    }
    throw Exception('User are not found');
  }

  Future<Pin?> getPinByUserId(int userId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> pins =
        await db.query('PIN', where: 'user_id = ?', whereArgs: [userId]);
    if (pins.isNotEmpty) {
      return Pin.fromMap(pins.first);
    }
    return null;
  }

  Future<void> deletePinByPinId(int pinId) async {
    final db = await instance.database;
    db.delete('PIN', where: 'id = ?', whereArgs: [pinId]);
  }

  // [ R A N K ]
  Future<Rank?> getRankByRankId(int rankID) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> ranks =
        await db.query('RANK', where: 'id = ?', whereArgs: [rankID]);
    if (ranks.isNotEmpty) {
      return Rank.fromMap(ranks.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllRank() async {
    final db = await instance.database;
    return db.query('RANK');
  }

  // [ S U B J E C T]
  Future<List<Map<String, dynamic>>> getAllSubjects() async {
    final db = await DBHelper.instance.database;
    return db.query('SUBJECT');
  }

  Future<int> addNewSubject(Subject subject) async {
    final db = await instance.database;
    final listSubjects = await getAllSubjects();
    bool check = listSubjects.any((items) => items['name'] == subject.name);
    if (check) {
      throw Exception('Subject already exist');
    } else {
      return db.insert('SUBJECT', subject.toMap());
    }
  }

  Future<Subject?> getSubjectById(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> subjects =
        await db.query('SUBJECT', where: 'id = ?', whereArgs: [id]);
    if (subjects.isNotEmpty) {
      return Subject.fromMap(subjects.first);
    }
    return null;
  }

  // [ Q U I Z ]

  //Add Quiz
  Future<int> addNewQuiz(Quiz quiz, int userId) async {
    final db = await DBHelper.instance.database;
    final ownQuiz = await getQuizByUserId(userId);
    final checkAny = ownQuiz.any((items) => items['title'] == quiz.title);
    if (checkAny) {
      throw Exception('Quiz already exist! Try again');
    } else {
      return db.insert('QUIZ', quiz.toMap());
    }
  }

  //Update Quiz
  Future<int> updateQuiz(Quiz quiz, int userId) async {
    final db = await instance.database;
    final ownQuiz = await getQuizByUserId(userId);
    final checkAny = ownQuiz
        .any((items) => items['id'] == quiz.id && items['user_id'] == userId);
    if (checkAny) {
      return db.update('QUIZ', quiz.toMap());
    } else {
      throw Exception('Quiz not found! Try again');
    }
  }

  //Delete Quiz
  Future<void> deleteQuizById(int id) async {
    final db = await instance.database;
    db.delete('QUIZ', where: 'id = ?', whereArgs: [id]);
  }

  //Get All Quiz
  Future<List<Map<String, dynamic>>> getAllQuiz() async {
    final db = await instance.database;
    return db.query('QUIZ');
  }

  //Get Quiz By Subject Id
  Future<List<Map<String, dynamic>>> getQuizBySubjectId(int subjectId) async {
    final db = await instance.database;
    return db.query('QUIZ', where: 'subject_id = ?', whereArgs: [subjectId]);
  }

  //Get Quiz By User Id
  Future<List<Map<String, dynamic>>> getQuizByUserId(int userId) async {
    final db = await instance.database;
    return db.query('QUIZ', where: 'user_id = ?', whereArgs: [userId]);
  }

  //Update Quiz Favorite Status
  Future<int> updateIsFavorite(int quizId, int status) async {
    final db = await instance.database;
    return db.update(
      'QUIZ',
      {'isFavorite': status}, // Giá trị cần cập nhật
      where: 'id = ?',
      whereArgs: [quizId],
    );
  }

  //Get Quiz By Id
  Future<Quiz?> getQuizById(int quizId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> quizs =
        await db.query('QUIZ', where: 'id = ?', whereArgs: [quizId]);
    if (quizs.isNotEmpty) {
      return Quiz.fromMap(quizs.first);
    } else {
      return null;
    }
  }

  // [ T Y P E ]
  Future<Type?> getTypeById(int typeId) async {
    final db = await DBHelper.instance.database;
    final List<Map<String, dynamic>> types =
        await db.query('TYPE', where: 'id = ?', whereArgs: [typeId]);
    if (types.isNotEmpty) {
      return Type.fromMap(types.first);
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllType() async {
    final db = await DBHelper.instance.database;
    return db.query('TYPE');
  }

  // [ Q U E S T I O N ]
  Future<List<Map<String, dynamic>>> getQuestionListByQuizId(int quizId) async {
    final db = await DBHelper.instance.database;
    return db.query('QUESTION', where: 'quiz_id=?', whereArgs: [quizId]);
  }

  Future<Question?> getQuestionById(int questionId) async {
    final db = await DBHelper.instance.database;
    final List<Map<String, dynamic>> questions =
        await db.query('QUESTION', where: 'id = ?', whereArgs: [questionId]);
    if (questions.isNotEmpty) {
      return Question.fromMap(questions.first);
    }
    return null;
  }

  // [ F A V O R I T E ]
  Future<int> addNewFavorite(Favorite favorite, int quizId, int userId) async {
    final db = await DBHelper.instance.database;
    final isFavoriteExists = await db.query(
      'FAVORITE',
      where: 'quiz_id = ? AND user_id = ?',
      whereArgs: [quizId, userId],
    );

    if (isFavoriteExists.isNotEmpty) {
      throw Exception('Already existed');
    }
    await DBHelper.instance.updateIsFavorite(quizId, 1);
    return db.insert('FAVORITE', favorite.toMap());
  }

  Future<void> removeFavorite(int quizId, int userId) async {
    final db = await DBHelper.instance.database;
    final isFavoriteExists = await db.query(
      'FAVORITE',
      where: 'quiz_id = ? AND user_id = ?',
      whereArgs: [quizId, userId],
    );

    if (isFavoriteExists.isNotEmpty) {
      // Cập nhật trạng thái isFavorite
      await DBHelper.instance.updateIsFavorite(quizId, 0);

      // Xóa mục yêu thích
      await db.delete(
        'FAVORITE',
        where: 'quiz_id = ? AND user_id = ?',
        whereArgs: [quizId, userId],
      );
    }
  }

  Future<Favorite?> getFavoriteByUserId(int userId) async {
    final db = await DBHelper.instance.database;
    final List<Map<String, dynamic>> favorites =
        await db.query('FAVORITE', where: 'user_id = ?', whereArgs: [userId]);
    if (favorites.isNotEmpty) {
      return Favorite.fromMap(favorites.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllFavoriteByUserId(int userId) async {
    final db = await DBHelper.instance.database;
    return db.query('FAVORITE', where: 'user_id=?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getAllFavorite() async {
    final db = await DBHelper.instance.database;
    return db.query('FAVORITE');
  }

  // [ C O M P L E T E - Q U I Z ]
  Future<int> createNewCompleteQuiz(CompletedQuiz complete, int userId) async {
    final db = await DBHelper.instance.database;
    final completeList =
        await DBHelper.instance.getAllCompleteQuizByUserId(userId);
    bool check =
        completeList.any((items) => items['quiz_id'] == complete.quizId);
    if (check) {
      throw Exception('Quiz already join');
    } else {
      return db.insert('COMPLETED_QUIZ', complete.toMap());
    }
  }

  Future<int> updateNumberCorrectAnswer(
      int correctCount, int userId, int quizId) async {
    final db = await DBHelper.instance.database;
    final questionList =
        await DBHelper.instance.getQuestionListByQuizId(quizId);
    int totalQuestionOfQuiz = questionList.length;
    if (correctCount > totalQuestionOfQuiz) {
      return 0;
    } else {
      return db.update('COMPLETED_QUIZ', {'number_correct': correctCount},
          where: 'user_id = ? AND quiz_id = ?', whereArgs: [userId, quizId]);
    }
  }

  Future<int> updateNumberCorrectAnswerReset(int userId, int quizId) async {
    final db = await DBHelper.instance.database;
    final questionList =
        await DBHelper.instance.getQuestionListByQuizId(quizId);
    int totalQuestionOfQuiz = questionList.length;
    return db.update('COMPLETED_QUIZ', {'number_correct': 0},
        where: 'user_id = ? AND quiz_id = ?', whereArgs: [userId, quizId]);
  }

  Future<int> updateCompleteQuizProgress(
      int progress, int userId, int quizId) async {
    final db = await DBHelper.instance.database;
    return db.update('COMPLETED_QUIZ', {'progress': progress},
        where: 'user_id = ? AND quiz_id = ?', whereArgs: [userId, quizId]);
  }

  Future<int> updateStatusUnlock(int quizId, int userId) async {
    final db = await instance.database;
    return db.update('COMPLETED_QUIZ', {'status': 'unlock'},
        where: 'user_id = ? AND quiz_id = ?', whereArgs: [userId, quizId]);
  }

  Future<int> updateStatusDid(int quizId, int userId) async {
    final db = await instance.database;
    return db.update('COMPLETED_QUIZ', {'status': 'did'},
        where: 'user_id = ? AND quiz_id = ?', whereArgs: [userId, quizId]);
  }

  Future<int> updateCompleteQuiz(
      int score, int userId, int quizId, DateTime dateTime) async {
    final db = await DBHelper.instance.database;
    return db.update(
      'COMPLETED_QUIZ',
      {'score': score, 'completed_at': dateTime.toIso8601String()},
      where: 'user_id = ? AND quiz_id = ?',
      whereArgs: [userId, quizId],
    );
  }

  Future<int> updatePaidAtTime(int userId, int quizId) async {
    final db = await DBHelper.instance.database;
    return db.update(
        'COMPLETED_QUIZ', {'paid_at': DateTime.now().toIso8601String()},
        where: 'quiz_id = ? AND user_id = ?', whereArgs: [quizId, userId]);
  }

  Future<void> deleteCompleteQuiz(int userId, int quizId) async {
    final db = await instance.database;
    await db.delete('COMPLETED_QUIZ',
        where: 'user_id=? AND quiz_id=?', whereArgs: [userId, quizId]);
  }

  Future<List<Map<String, dynamic>>> getAllCompleteQuizByUserId(
      int userId) async {
    final db = await DBHelper.instance.database;
    return db.query('COMPLETED_QUIZ', where: 'user_id=?', whereArgs: [userId]);
  }

  Future<CompletedQuiz?> getCompleteQuizByQuizIdAndUserId(int userId) async {
    final db = await DBHelper.instance.database;
    final List<Map<String, dynamic>> completes = await db
        .query('COMPLETED_QUIZ', where: 'user_id = ?', whereArgs: [userId]);
    print('Complete cua user');
    if (completes.isNotEmpty) {
      return CompletedQuiz.fromMap(completes.first);
    }
    return null;
  }

  Future<CompletedQuiz?> getCompleteQuiz(int userId, int quizId) async {
    final db = await DBHelper.instance.database;
    final List<Map<String, dynamic>> completes = await db
        .query('COMPLETED_QUIZ', where: 'user_id = ? AND quiz_id = ?', whereArgs: [userId,quizId]);
    if (completes.isNotEmpty) {
      return CompletedQuiz.fromMap(completes.first);
    }
    return null;
  }

  // [ C A R T ] & [ C A R T -- I T E M  ]
  Future<int> createCart(Cart cart, int userId) async {
    final db = await DBHelper.instance.database;
    final cartList = await cartListByUserId(userId);
    if (cartList.isNotEmpty) {
      throw CartAlreadyExistException(msg: 'User only create one cart');
    }
    try {
      return await db.insert(
        'CART',
        cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> cartListByUserId(int userId) async {
    final db = await DBHelper.instance.database;
    return db.query('CART', where: 'user_id=?', whereArgs: [userId]);
  }

  Future<Cart?> getCartByUserId(int userId) async {
    final List<Map<String, dynamic>> carts = await cartListByUserId(userId);
    if (carts.isNotEmpty) {
      return Cart.fromMap(carts.first);
    }
    return null;
  }

  Future<int> addQuizToCart(CartItem cartItems, int userId) async {
    final db = await instance.database;
    final cart = await getCartByUserId(userId);
    final cartItemsList = await getCartItemsByCartId(cart!.id!);
    final completeList = await getAllCompleteQuizByUserId(userId);
    bool check = cartItemsList.any((items) => items['quiz_id'] == cartItems.quizId);
    bool checkComplete = completeList.any((items) => items['quiz_id'] == cartItems.quizId && items['user_id'] == userId);
    if (check) {
      throw QuizAlreadyExistException(msg: 'Quiz already exist in Cart');
    } else if (checkComplete) {
      throw QuizAlreadyExistException(msg: 'Quiz already have');
    } else {
      return await db.insert('CART_ITEM', cartItems.toMap());
    }
  }

  Future<List<Map<String, dynamic>>> getCartItemsByCartId(int cartId) async {
    final db = await instance.database;
    return await db
        .query('CART_ITEM', where: 'cart_id = ?', whereArgs: [cartId]);
  }

  Future<int> removeQuizFromCart(int quizId, int cartId) async {
    final db = await instance.database;
    return db.delete('CART_ITEM',
        where: 'quiz_id = ? AND cart_id = ?', whereArgs: [quizId, cartId]);
  }


  // [ Q U E S T I O N ]
  Future<int> addNewQuestion(Question question, int quizId, int userId) async {
    final db = await instance.database;
    final questionList =
    await DBHelper.instance.getQuestionListByQuizId(quizId);
    bool check = questionList.any((items) => items['content'] == question.content);
    if (check) {
      throw Exception('Question already exist');
    } else {
      return db.insert('QUESTION', question.toMap());
    }
  }

  // [ D I S C O U N T ]
  Future<List<Map<String,dynamic>>> getAllVoucherByRankId(int rankId) async {
    final db = await instance.database;
    return db.query('DISCOUNT',where: 'rank_id=?',whereArgs: [rankId]);
  }

  //1 rank 1 voucher
  Future<Discount?> getVoucherByRankId(int rankId) async {
    final List<Map<String, dynamic>> vouchers = await getAllVoucherByRankId(rankId);
    if (vouchers.isNotEmpty) {
      return Discount.fromMap(vouchers.first);
    }
    return null;
  }


}
