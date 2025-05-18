import 'package:academa_streaming_platform/config/const/banner_test.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/horizontal_slider.dart';
import 'package:academa_streaming_platform/presentation/profile/widgets/custom_profile_app_bar.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keepWatchingHeight = size.height * 0.12;
    return Scaffold(
      appBar: CustomProfileAppBar(),
      body: CustomBodyContainer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.30,
                    height: size.width * 0.30,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'lib/config/assets/profile_pic_test.jpg'),
                          fit: BoxFit.contain, // ajusta la imagen al contenedor
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Jhon Doe',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        Text('Impulsando el aprendizaje',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            maxLines: 1, // limita a una línea
                            overflow: TextOverflow.ellipsis)
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: CustomButton(
                text: 'Email',
                textColor: Colors.white,
                backgroundColor: Colors.black,
                textSize: 16,
                buttonWidth: size.width,
                buttonHeight: size.height * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre mi',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'El Dr. Juan Pérez es licenciado en Física por la Universidad Central, con más de 10 años de experiencia diseñando e impartiendo clases tanto presenciales como en línea',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Clases',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
            HorizontalSlider(
              cards: keepWatching,
              height: keepWatchingHeight,
              horizontalPadding: 32,
            ),
          ],
        ),
      ),
    );
  }
}
