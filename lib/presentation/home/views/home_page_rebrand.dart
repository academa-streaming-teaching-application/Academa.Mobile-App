import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePageRebrand extends StatelessWidget {
  const HomePageRebrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Logo + Academa Heading
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'lib/config/assets/academa_logo.svg',
              width: 16,
              height: 16,
            ),
            const SizedBox(
              width: 4,
            ),
            const Text(
              'Academa',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //OnLive Card Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Live Activos',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          //OnLive Card Slider
          SizedBox(
            height: 300,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (context, _) => SizedBox(
                width: 16,
              ),
              itemBuilder: (context, index) => OnLiveVideoCard(),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          //Keep Watching title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Continúa viendo',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          //Keep Watching Card
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: 6,
              separatorBuilder: (context, _) => SizedBox(
                width: 16,
              ),
              itemBuilder: (context, index) => KeepWatchingCard(),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          //Top-Rated Class title
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
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: 6,
              separatorBuilder: (context, _) => SizedBox(
                width: 16,
              ),
              itemBuilder: (context, index) => KeepWatchingCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class KeepWatchingCard extends StatelessWidget {
  const KeepWatchingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: Color(0xff1D1D1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffF4B2B0),
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
                    Text(
                      'Repaso de limites e integrales',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(
                      width: 220,
                      child: Text(
                        '12 clases | Materia matemática 1 para ingenieros',
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
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 110,
                  child: LinearProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 91, 91, 94),
                    valueColor: new AlwaysStoppedAnimation(Color(0xffFEB7FF)),
                    value: 0.1,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Text(
                'Tiempo restante: 5 min',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class OnLiveVideoCard extends StatelessWidget {
  const OnLiveVideoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: Color(0xff1D1D1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffF4B2B0),
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
                const SizedBox(
                  width: 8,
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: const Text(
                    'Materia matemática 1 para ingenieros',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 160, // Ajusta esta altura para la imagen
            color: Color(0xffFEB7FF),
            child: SvgPicture.asset(
              'lib/config/assets/live_colaboration.svg',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  size: 32,
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clase 12',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 40,
                      child: const Text(
                        'Repaso de limites e integrales',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
