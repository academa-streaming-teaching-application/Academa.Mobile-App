import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class RoadmapsView extends StatelessWidget {
  const RoadmapsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoadmapAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: [
            SizedBox(height: 8),
            SizedBox(height: 16),
            ...List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RoadmapCard(),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class RoadmapAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RoadmapAppBar({
    super.key,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      centerTitle: true,
      title: Text(
        'Mis Rutas',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 400,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.pop(context);
                        },
                        child: Text('Click me to close the modal'),
                      ),
                    ),
                  );
                });
          },
          icon: Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class RoadmapCard extends StatelessWidget {
  const RoadmapCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/roadmap-subjects');
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 188, 183, 255),
                borderRadius: BorderRadius.circular(100)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.route),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    'Repaso de limites e integrales',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    maxLines: 2,
                  ),
                ),
                Text(
                  '12 clases',
                  style: TextStyle(
                    color: Color(0xff6C6C6C),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
