import 'package:academa_streaming_platform/presentation/search/widgets/search_class_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Clases',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            ...List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 8, right: 8),
                child: TopRatedClassCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(104);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.black,
      title: const Text(
        'Búsqueda',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              showSearch(
                context: context,
                delegate: SearchClassDelegate(),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 72, 72, 75)),
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
              ),
              child: Row(
                children: const [
                  Icon(Icons.search_rounded,
                      color: Color.fromARGB(255, 72, 72, 75)),
                  SizedBox(width: 8),
                  Text(
                    'Qué te gustaría aprender',
                    style: TextStyle(
                      color: Color.fromARGB(255, 72, 72, 75),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopRatedClassCard extends StatelessWidget {
  const TopRatedClassCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xffE4B7FF),
                ),
                width: double.infinity,
                height: 160,
                child: SvgPicture.asset(
                  'lib/config/assets/education_gathering.svg',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(50, 0, 0, 0),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  width: 48,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xff1D1D1E),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        '5.2',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffFE4B7FF),
                    borderRadius: BorderRadius.circular(100)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SvgPicture.asset(
                    'lib/config/assets/book.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 40,
                      child: const Text(
                        'Materia matemática 1 para ingenieros',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: Text(
                        'Impartido por Hugo Duque',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
