import 'package:flutter/material.dart';
import 'package:mentalhealthtrackerapp/QuizPage.dart';
import 'package:mentalhealthtrackerapp/HomeScreen.dart';

class Assessment extends StatefulWidget {
  final String selectedDisease;

  Assessment({Key? key, required this.selectedDisease}) : super(key: key);

  @override
  State<Assessment> createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment> {
  final List<String> depression = [
    'Are you having thoughts that you would be better off dead, or of hurting yourself?',
    'Are you having trouble concentrating on things such as reading the newspaper or watching TV?',
    'Are you feeling bad about yourself (e.g., feel like a failure or constantly let your family down)?',
    'Do you have a poor appetite or are you overeating?',
    'Are you feeling tired or having little energy?',
    'Are you having trouble falling or staying asleep, or sleeping too much?',
    'Are you feeling down, depressed, or hopeless?',
    'Do you have little interest or pleasure in doing things?',
    'Do you feel overwhelmed with feelings of sadness or hopelessness?',
    'Do you find it difficult to get out of bed in the morning?',
    'Are you having difficulty enjoying activities you once loved?'
  ];

  final List<String> anxiety = [
    'Are you feeling nervous, anxious, or on edge?',
    'Are you feeling unable to stop or control worrying?',
    'Are you worrying too much about different things?',
    'Are you having trouble relaxing?',
    'Are you so restless that it is hard to sit still?',
    'Are you feeling easily annoyed or irritable?',
    'Are you feeling as if something awful might happen?',
    'Are you experiencing physical symptoms like a racing heart or sweating?',
    'Do you have trouble sleeping because of your worries?',
    'Do you avoid situations that make you anxious?',
    'Do you find it hard to concentrate because of your anxiety?'
  ];

  final List<String> grief = [
    'Are you experiencing intense sadness or despair?',
    'Are you having trouble accepting the loss of a loved one?',
    'Are you feeling guilty about things related to the loss?',
    'Are you withdrawing from friends and family?',
    'Are you having trouble carrying out normal routines or tasks?',
    'Are you feeling angry or irritable without reason?',
    'Are you experiencing difficulty sleeping or having nightmares?',
    'Are you avoiding reminders of your loss?',
    'Do you feel numb or detached from reality?',
    'Are you having trouble focusing on daily activities?',
    'Do you find it hard to find joy in life after your loss?'
  ];

  final List<String> ptsd = [
    'Are you experiencing flashbacks or nightmares?',
    'Do you avoid places or activities that remind you of a traumatic event?',
    'Are you feeling on edge or easily startled?',
    'Do you have trouble sleeping due to anxiety or fear?',
    'Are you feeling detached or estranged from others?',
    'Are you having trouble concentrating or focusing?',
    'Do you experience intense distress at reminders of a traumatic event?',
    'Do you feel hopeless about the future?',
    'Are you having physical reactions like sweating or heart palpitations?',
    'Do you feel emotionally numb or disconnected?',
    'Are you experiencing frequent, uncontrollable anger or irritability?'
  ];

  final List<String> schizophrenia = [
    'Are you experiencing any brain fog?',
    'Are you struggling to remember to eat or drink water?',
    'Are your thoughts jumbled or are you unable to think clearly?',
    "Are you having trouble seeing things or are you seeing things that aren't there?",
    'Do you feel extremely tired?',
    'Are the happy thoughts speeding up your thought process?',
    'Are the sad thoughts slowing down your thought process?',
    'Are you having any grandiose thoughts?',
    'Do you hear voices that others do not hear?',
    'Do you believe people are out to get you?',
    'Are you finding it hard to distinguish reality from hallucinations?'
  ];

  final List<String> psychosisQuestions = [
    'Are you experiencing hallucinations or delusions?',
    'Do you have trouble distinguishing between reality and imagination?',
    'Are you having disorganized thoughts or speech?',
    'Do you feel paranoid or excessively suspicious?',
    'Are you withdrawing from social interactions or relationships?',
    'Do you have unusual or bizarre thoughts?',
    'Are you experiencing extreme mood swings or emotional disturbances?',
    'Do you feel as if people are watching or talking about you?',
    'Are you unable to express your thoughts clearly?',
    'Do you feel like you have special powers or abilities?',
    'Are you finding it hard to focus on everyday tasks?'
  ];

  final List<String> eatingDisorder = [
    'Are you excessively concerned about your weight or body shape?',
    'Do you engage in binge eating or purging behaviors?',
    'Are you restricting your food intake to lose weight?',
    'Do you have a distorted body image?',
    'Are you experiencing severe weight loss or weight gain?',
    'Are you feeling guilty or ashamed about eating?',
    'Are you obsessed with dieting or food?',
    'Do you feel out of control when eating?',
    'Are you exercising excessively to control your weight?',
    'Are you hiding your eating habits from others?',
    'Do you feel anxious or stressed around meal times?'
  ];

  final List<String> bipolarDisorder = [
    'Are you experiencing extreme mood swings?',
    'Do you have periods of intense energy followed by periods of deep depression?',
    'Are you engaging in risky or impulsive behaviors?',
    'Do you have trouble sleeping or need less sleep during high periods?',
    'Are you feeling excessively happy or euphoric for no reason?',
    'Do you feel hopeless or extremely sad during low periods?',
    'Are you having trouble concentrating or making decisions?',
    'Do you have periods of unusually high self-esteem or grandiosity?',
    'Do you feel unusually talkative or pressured to keep talking?',
    'Do you experience racing thoughts or jump from one idea to another?',
    'Do you have periods where you spend money excessively or engage in reckless activities?'
  ];

  final List<String> addiction = [
    'Are you unable to stop using a substance or engaging in a behavior?',
    'Do you experience cravings or urges to use the substance?',
    'Are you experiencing withdrawal symptoms when not using?',
    'Are you neglecting responsibilities due to the addiction?',
    'Do you continue using despite negative consequences?',
    'Are you spending a lot of time thinking about or obtaining the substance?',
    'Are you unable to control or reduce your use?',
    'Do you lie to others about your usage?',
    'Are you withdrawing from social or recreational activities?',
    'Do you use the substance to cope with stress or emotions?',
    'Are you experiencing financial or legal problems due to your use?'
  ];

  final List<String> epilepsy = [
    'Are you experiencing frequent seizures?',
    'Do you have periods of confusion or memory loss?',
    'Are you feeling tired or fatigued after seizures?',
    'Are you having trouble concentrating or focusing?',
    'Do you experience unusual sensations or feelings before a seizure?',
    'Are you having trouble with coordination or balance?',
    'Do you have headaches or migraines after seizures?',
    'Do you feel anxiety or fear about having seizures?',
    'Are you avoiding activities due to fear of having a seizure?',
    'Do you need to take medication to control your seizures?',
    'Are your seizures affecting your daily life and activities?'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigateToQuiz(widget.selectedDisease);
    });
  }

  void navigateToQuiz(String conclusion) {
    if (conclusion == 'Depression') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
              depression, 11, 'Depression', [Colors.blue, Colors.greenAccent]),
        ),
      );
    } else if (conclusion == 'Anxiety') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuizPage(anxiety, 11, 'Anxiety', [Colors.red, Colors.pinkAccent]),
        ),
      );
    } else if (conclusion == 'Grief') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuizPage(grief, 11, 'Grief', [Colors.grey, Colors.blueGrey]),
        ),
      );
    } else if (conclusion == 'Post-traumatic stress disorder') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
              ptsd,
              11,
              'Post-Traumatic Stress Disorder',
              [Colors.deepPurple, Colors.purpleAccent]),
        ),
      );
    } else if (conclusion == 'Schizophrenia') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(schizophrenia, 11, 'Schizophrenia',
              [Colors.purple, Colors.indigo]),
        ),
      );
    } else if (conclusion == 'Psychosis') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(psychosisQuestions, 11, 'Psychosis',
              [Colors.brown, Colors.deepOrange]),
        ),
      );
    } else if (conclusion == 'Eating Disorder') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(eatingDisorder, 11, 'Eating Disorder',
              [Colors.amber, Colors.deepOrangeAccent]),
        ),
      );
    } else if (conclusion == 'Bipolar Disorder') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(bipolarDisorder, 11,
              'Bipolar Disorder', [Colors.pink, Colors.pinkAccent]),
        ),
      );
    } else if (conclusion == 'Addiction') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(addiction, 11, 'Addiction',
              [Colors.cyan, Colors.lightBlueAccent]),
        ),
      );
    } else if (conclusion == 'Epilepsy') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(epilepsy, 11, 'Epilepsy',
              [Colors.deepOrange, Colors.deepOrangeAccent]),
        ),
      );
    } else {
      // Handle unknown condition
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unknown condition: $conclusion'),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 204, 214, 243), // soft off-white
        foregroundColor: Colors.black87,
        elevation: 1,
        title: const Text(
          'The Level of Your Mentality',
          style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      drawer: const Menu(),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
