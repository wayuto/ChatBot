import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../app/appState.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () async {
            var model = await showDialog<String>(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text('Choose a model:'),
                  children: [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, 'Qwen/QwQ-32B'),
                      child: Text('Qwen/QwQ-32B'),
                    ),
                    Divider(),

                    SimpleDialogOption(
                      onPressed:
                          () => Navigator.pop(
                            context,
                            'internlm/internlm2_5-7b-chat',
                          ),
                      child: Text('internlm/internlm2_5-7b-chat'),
                    ),
                    Divider(),

                    SimpleDialogOption(
                      onPressed:
                          () =>
                              Navigator.pop(context, 'deepseek-ai/DeepSeek-V3'),
                      child: Text('deepseek-ai/DeepSeek-V3'),
                    ),
                    Divider(),

                    SimpleDialogOption(
                      onPressed:
                          () => Navigator.pop(context, 'THUDM/GLM-4-32B-0414'),
                      child: Text('THUDM/GLM-4-32B-0414'),
                    ),
                  ],
                );
              },
            );
            if (model != null) {
              appState.response = 'Model changed!';
              appState.setModel(model);
            } else {
              DoNothingAction();
            }
          },
          child: Text("ChatBot"),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text('Clean all history?'),
                    children: [
                      SimpleDialogOption(
                        child: Text('Yes'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                      Divider(),

                      SimpleDialogOption(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ],
                  );
                },
              );

              result
                  ? {
                    appState.clear(),
                    appState.response = 'No message yet...',
                    setState(() {}),
                  }
                  : DoNothingAction();
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(appState.response),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Send me messages",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    appState.response = 'Thinking...';
                    var text = _controller.text;
                    _controller.text = '';
                    await appState.getResponse(text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
