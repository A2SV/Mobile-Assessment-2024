import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/new_model.dart';
import 'package:flutter_news_app/screens/search_screen.dart';
import 'package:flutter_news_app/widgets/drawer_widget.dart';
import 'package:flutter_news_app/widgets/home/all_news.dart';
import 'package:flutter_news_app/widgets/home/tab_item.dart';
import 'package:flutter_news_app/widgets/home/top_trending.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum TabType { allNews, topTrending }

late List<NewModel> newList;

class _HomeState extends State<Home> {
  TabType selectedPage = TabType.allNews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const NewsAppTitle(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (c) => SearchScreen()));
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  )),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  TabItem(
                    title: "All News",
                    selected: selectedPage == TabType.allNews ? true : false,
                    callback: () {
                      setState(() {
                        selectedPage = TabType.allNews;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TabItem(
                    title: "Top Trending",
                    selected:
                        selectedPage == TabType.topTrending ? true : false,
                    callback: () {
                      setState(() {
                        selectedPage = TabType.topTrending;
                      });
                    },
                  ),
                ],
              ),
              Flexible(
                child: selectedPage == TabType.allNews
                    ? const AllNews()
                    : const TopTrending(),
              ),
            ],
          ),
        ));
  }
}

class NewsAppTitle extends StatelessWidget {
  const NewsAppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "News App",
      style: GoogleFonts.aboreto(fontWeight: FontWeight.w800, fontSize: 30),
    );
  }
}
