import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe({super.key});

  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            children: [
              Header(title: '编辑食谱')
            ],
          ),
        ),
      ),
    );
  }
}
