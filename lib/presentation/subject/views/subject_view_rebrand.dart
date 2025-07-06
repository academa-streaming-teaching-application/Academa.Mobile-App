import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SubjectViewRebrand extends StatelessWidget {
  const SubjectViewRebrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubjectViewAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: [
            SizedBox(height: 8),
            SubjectHeading(),
            SizedBox(height: 16),
            Text(
              'Sobre el curso',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'En este curso podras reforzar tus bases matematicas sobre limites con videos teoricos y practicos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 16),
            ...List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SubjectVideoCard(),
              ),
            ),
            Text(
              'Profesor',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff1D1D1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Hugo Duque',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class SubjectViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SubjectViewAppBar({
    super.key,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Clase',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.ios_share_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SubjectVideoCard extends StatelessWidget {
  const SubjectVideoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xffFE4B7FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'lib/config/assets/study_view.svg',
              width: 72,
              height: 64,
              placeholderBuilder: (context) => Container(
                decoration: BoxDecoration(
                  color: Color(0xffFE4B7FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 72,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 250,
                child: Text(
                  'Repaso de limites e integrales',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  maxLines: 3,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '10:12 min',
                style: TextStyle(
                  color: Color(0xff6C6C6C),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class SubjectHeading extends StatelessWidget {
  const SubjectHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Color(0xffFE4B7FF),
              borderRadius: BorderRadius.circular(100)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'lib/config/assets/book.svg',
              width: 32,
              height: 32,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '12 clases',
                    style: TextStyle(
                      color: Color(0xff6C6C6C),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Icon(
                    Icons.star_rate_rounded,
                    size: 18,
                    color: Color(0xff6C6C6C),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Text(
                    '5.2 | 100 estudiantes',
                    style: TextStyle(
                      color: Color(0xff6C6C6C),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 350,
                child: Text(
                  'Repaso de limites e integrales',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
