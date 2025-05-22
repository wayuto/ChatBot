import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app/appState.dart';
import '../widgets/syntaxHighlighter.dart';
import '../pages/settingsPage.dart';

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
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          '${appState.appBar}',
          maxLines: 1,
          minFontSize: 10,
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MySettingsPage()),
              );
            },
            icon: Icon(Icons.settings),
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
                  icon:
                      !appState.isThinking
                          ? Icon(Icons.send)
                          : Icon(Icons.circle),
                  onPressed: () async {
                    if (appState.isThinking) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Tips'),
                            content: Text('Model is thinking...'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    var text = _controller.text;
                    if (text.trim().isEmpty) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Tips'),
                            content: Text("Message couldn't be empty."),
                            actions: [
                              TextButton(
                                child: Text('Got it.'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
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
