import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app/appState.dart';
import '../widgets/syntaxHighlighter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
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
              await appState.setModel(model);
              appState.appBar = "Model: ${appState.model}";
            }
          },
          child: Text("${appState.appBar}"),
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
              if (result == true) {
                await appState.clear();
              }
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(15),
              controller: _scrollController,
              itemCount: appState.history.length,
              itemBuilder: (context, index) {
                final msg = appState.history[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          isUser
                              ? Text(msg['content'] ?? '')
                              : Markdown(
                                data: msg['content'] ?? '',
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                syntaxHighlighter: MySyntaxHighlighter(),
                                selectable: true,
                                styleSheet: MarkdownStyleSheet(
                                  codeblockDecoration: BoxDecoration(
                                    color: Color(0xFF282C34),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onTapLink: (text, href, title) async {
                                  if (href == null) return;
                                  var url = Uri.parse(href);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  }
                                },
                              ),
                    ),
                  ),
                );
              },
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
                    var text = _controller.text;
                    if (text.trim().isEmpty) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Tips'),
                            content: Text("Message couldn't be empty."),
                          );
                        },
                      );
                    }
                    _controller.clear();
                    appState.appBar = "Thinking...";
                    scrollToBottom();
                    await appState.getResponse(text);
                    appState.appBar = "Model: ${appState.model}";
                    scrollToBottom();
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
