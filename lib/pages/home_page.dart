import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_habit_tile.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';
import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void initState() {

    // read existing habits on app startup
    final TextEditingController textController = TextEditingController();
    super.initState();
  }

  //text controller
  final TextEditingController textController = TextEditingController();

  //create a new habit
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Create a new habit"),
          ),
          actions: [
            //save button
            MaterialButton(
              onPressed: () {
                //get the new habit name
                String newHabitName = textController.text;

                //save to db
                context.read<HabitDatabase>().addHabit(newHabitName);

                //pop box
                Navigator.pop(context);

                //clear controller
                textController.clear();
              },
              child: const Text('Save'),
            ),

            //cancel button
            MaterialButton(
                onPressed: () {
                  //pop box
                  Navigator.pop(context);

                  //clear controller.
                  textController.clear();
                },
              child: const Text('Cancel'),
            )
          ],
        )
    );
  }


  // check habit on and off
  void checkHabitOnOff(bool? value, Habit habit) {
    //update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add, color: Colors.black,),
      ),
      body: _buildHabitList(),
    );
  }

  //build habit list
  Widget _buildHabitList() {
    //habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
        itemBuilder: (context, index) {
          //get each individual habit
          final habit = currentHabits[index];

          //check if the habit is completed today
          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

          //return habit tile UI
          return MyHabitTile(
              isCompleted:
              isCompletedToday,
              text: habit.name,
              onChanged: (value) => checkHabitOnOff(value, habit),
          );
        }
    );
  }
}

