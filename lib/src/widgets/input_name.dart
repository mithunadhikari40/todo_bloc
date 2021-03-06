import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:todo/src/blocs/auth_bloc.dart';
import 'package:todo/src/blocs/auth_bloc_provider.dart';
import 'package:todo/src/widgets/shared/app_colors.dart';

class InputName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = AuthBlocProvider.of(context);
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: Text(
                "Your name",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
              ),
            ),
            StreamBuilder(
                stream: authBloc.nameStream,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  return TextField(
                    onChanged: authBloc.changeName,
                    keyboardType: TextInputType.name,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16.0),
                        prefixIcon: Container(
                            width: Math.min(
                                MediaQuery.of(context).size.width / 6, 40),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: greyColor))),
                            child: Icon(Icons.person),
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: blackColor87, width: 1),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(4.0),
                          ),
                        ),
                        hintText: "Ram Kumar Shrestha",
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null),
                  );
                })
          ],
        ));
  }
}
