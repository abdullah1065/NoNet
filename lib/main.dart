import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const NoNetApp());
}

class NoNetApp extends StatelessWidget {
  const NoNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoNet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NoNetHomePage(),
    );
  }
}

class NoNetHomePage extends StatefulWidget {
  const NoNetHomePage({super.key});

  @override
  State<NoNetHomePage> createState() => _NoNetHomePageState();
}

class _NoNetHomePageState extends State<NoNetHomePage> {
  final TextEditingController _controller = TextEditingController();
  File? _image;
  File? _pdfFile;

  // List to store conversation messages
  List<Map<String, String>> messages = [];

  // Function to handle sending message
  void _sendMessage() {
    final text = _controller.text;
    setState(() {
      // Add user message to messages list
      messages.add({"type": "user", "text": text});
      // Auto-reply by the bot
      if (text.toLowerCase() == 'hi') {
        messages.add({"type": "bot", "text": "Hello!"});
      } else {
        // Add more conditions for different replies or default message
        messages.add({"type": "bot", "text": "I'm not sure what you mean."});
      }
    });
    _controller.clear();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('NoNet'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display conversation history
              ListView.builder(
                shrinkWrap: true, // Use this to make ListView work inside Column
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ListTile(
                    title: Text(message['text']!),
                    subtitle: Text(message['type']!),
                    leading: CircleAvatar(
                      child: Text(message['type'] == 'user' ? 'U' : 'B'),
                    ),
                  );
                },
              ),
              if (_image != null) Image.file(_image!),
              if (_pdfFile != null) Text('PDF Selected: ${_pdfFile!.path.split('/').last}'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 6, // This will take up 6 parts of the space
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1, // This will take up 1 part of the space
                  child: FloatingActionButton(
                    onPressed: _sendMessage,
                    tooltip: 'Send message',
                    child: const Icon(Icons.send),
                    backgroundColor: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Take/Upload Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 5,
                        shadowColor: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: _pickPDF,
                      child: const Text('Upload PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 5,
                        shadowColor: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
