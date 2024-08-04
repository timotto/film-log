import 'package:film_log_wear/widgets/open_on_phone_button.dart';
import 'package:film_log_wear/widgets/swipe_dismiss.dart';
import 'package:flutter/material.dart';

class AddFilmPage extends StatelessWidget {
  const AddFilmPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SwipeDismiss(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Use your phone to add a new film'),
                  OpenOnPhoneButton(),
                ],
              ),
            ),
          ),
        ),
      );
}
