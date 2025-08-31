import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                    valueColor: new AlwaysStoppedAnimation(Color(0xffE4B7FF)),
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
