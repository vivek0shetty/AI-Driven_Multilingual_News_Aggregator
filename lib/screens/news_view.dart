import 'package:flutter/material.dart';
import 'package:flutter_new_application/config/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsView extends StatefulWidget {
  final String title;
  final String? imageUrl;
  final String content;

  const NewsView({
    required this.title,
    required this.imageUrl,
    required this.content,
  });

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  String displayedContent = ""; // Content displayed on the page
  bool isLoading = true; // Loading state
  bool hasError = false; // Error state

  @override
  void initState() {
    super.initState();
    _fetchDetailedContent(widget.content);
  }

  Future<void> _fetchDetailedContent(String content) async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

  
    const String apiUrl = "Add your api url here";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer ${AppConfig.apiKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a professional journalist writing a detailed, engaging news article. Write the article in a natural, narrative flow with multiple paragraphs, like a real news article. Avoid headings like 'Introduction,' 'Conclusion,' or 'Summary.'"
            },
            {
              "role": "user",
              "content":
                  "Write a detailed news article about '$content' in a continuous narrative style, with multiple paragraphs, ensuring it's engaging and structured like a real news article."
            },
          ],
          "max_tokens": 3500,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String generatedContent =
            responseData['choices'][0]['message']['content'].trim();

        setState(() {
          displayedContent = generatedContent;
          isLoading = false;
        });
      } else {
        throw Exception(
            "Failed to fetch AI data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _translateContent(String targetLanguage) async {
    setState(() {
      isLoading = true;
      hasError = false;
    });


    const String apiUrl = "Add your api url here";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer ${AppConfig.apiKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a professional translator."},
            {
              "role": "user",
              "content":
                  "Translate the following content into $targetLanguage:\n$displayedContent"
            },
          ],
          "max_tokens": 3500,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String translatedContent =
            responseData['choices'][0]['message']['content'].trim();

        setState(() {
          displayedContent = translatedContent;
          isLoading = false;
        });
      } else {
        throw Exception(
            "Failed to fetch AI data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _summarizeContent() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    const String apiUrl = "Add your api url here";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer ${AppConfig.apiKey}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a professional journalist tasked with summarizing news articles concisely and clearly. Write a polished and informative summary that highlights the key points of the article in 3-4 lines."
            },
            {
              "role": "user",
              "content":
                  "Summarize the following article in a professional journalistic style, keeping it concise and highlighting the most important points in 3-4 sentences: \n$displayedContent"
            },
          ],
          "max_tokens": 250,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String summary =
            responseData['choices'][0]['message']['content'].trim();

        setState(() {
          displayedContent = summary;
          isLoading = false;
        });
      } else {
        throw Exception(
            "Failed to fetch AI data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _showLanguageSelectorDialog() {
    String selectedLanguage = "English"; // Default language
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Language"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                value: selectedLanguage,
                items: [
                  "English", // Added English option
                  "Spanish",
                  "French",
                  "German",
                  "Chinese",
                  "Hindi",
                ].map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _translateContent(selectedLanguage);
              },
              child: Text("Translate"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "Translate") {
                _showLanguageSelectorDialog();
              } else if (value == "Summarize") {
                _summarizeContent(); // Handle summarize action
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "Translate",
                  child: Text("Translate"),
                ),
                PopupMenuItem<String>(
                  value: "Summarize",
                  child: Text("Summarize"),
                ),
              ];
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Text(
                    "Failed to fetch data. Please try again later.",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.imageUrl != null)
                        Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        )
                      else
                        Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: Center(
                            child: Text(
                              "No Image Available",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ),
                      SizedBox(height: 16),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        displayedContent,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: NewsView(
        title: 'Sample News Title',
        imageUrl: 'https://example.com/image.jpg', // Use a valid image URL here
        content:
            'This is a sample news content that will be used to generate the detailed content from the API.',
      ),
    ));
