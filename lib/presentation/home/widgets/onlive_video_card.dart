import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                      color: Color(0xffE4B7FF),
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
            height: 160,
            color: Color(0xffE4B7FF),
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
