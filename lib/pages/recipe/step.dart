import 'package:flutter/material.dart';
import 'package:food/widgets/header.dart';
import 'package:food/widgets/c_button.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi_light.dart';
import 'package:food/model/recipe.dart';
import 'package:food/config.dart';

class StepPage extends StatefulWidget {
  const StepPage({super.key});

  @override
  _StepPageState createState() => _StepPageState();
}

class _StepPageState extends State<StepPage> {
  late int currentStep;
  late Recipe recipe;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentStep = 0;
    final args = ModalRoute.of(context)!.settings.arguments as Recipe;
    recipe = args;
  }

  void nextStep() {
    if (currentStep < recipe.instructions!.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(
                        title: recipe.name,
                        icon: recipe.kind!.icon,
                      ),
                      const SizedBox(height: 100),
                      // 显示步骤图片
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 150,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  IMG_SERVER_URI + recipe.image,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child:
                                          Icon(Icons.error, color: Colors.red),
                                    );
                                  },
                                )),
                          )
                        ],
                      ),

                      const SizedBox(height: 35),
                      Text(
                        '第${currentStep + 1}步',
                        style: const TextStyle(fontSize: 20),
                      ),
                      // 当前步骤
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            recipe.instructions![currentStep],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),

                      // const Spacer(),
                      // 上一步和下一步按钮
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CButton(
                              startIcon: Iconify(
                                MdiLight.seek_previous,
                                color: Colors.white,
                              ),
                              onPressed: previousStep,
                              text: '上一步',
                              type: 'secondary',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CButton(
                              startIcon: Iconify(
                                MdiLight.seek_next,
                                color: Colors.white,
                              ),
                              onPressed: nextStep,
                              text: '下一步',
                              type: 'secondary',
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
