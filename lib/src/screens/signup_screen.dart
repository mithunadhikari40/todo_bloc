import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo/src/blocs/auth_bloc.dart';
import 'package:todo/src/blocs/auth_bloc_provider.dart';
import 'package:todo/src/screens/todo_screen.dart';
import 'package:todo/src/utils/snackbar_helper.dart';
import 'package:todo/src/widgets/custom_app_bar.dart';
import 'package:todo/src/widgets/input_email.dart';
import 'package:todo/src/widgets/input_name.dart';
import 'package:todo/src/widgets/input_password.dart';
import 'package:todo/src/widgets/input_phone.dart';
import 'package:todo/src/widgets/shared/app_colors.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController =
      TextEditingController(text: "gmail@email.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "password");

  @override
  Widget build(BuildContext ctx) {
    return AuthBlocProvider(
      child: Builder(builder: (context) {
        final AuthBloc authBloc = AuthBlocProvider.of(context);

        return Scaffold(
          appBar: buildCustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: blackColor87,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            context: context,
            subTitle: "Create your \n account",
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 24),
                    InputName(),
                    InputPhone(),
                    InputEmail(controller: _emailController),
                    InputPassword(controller: _passwordController),
                    _buildSubmitButton(context, authBloc),
                    SizedBox(height: 12),
                    _buildTermsAndConditions(context),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              _buildSignInSection(context)
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: primaryColor, height: 1.5),
              children: [
                TextSpan(
                    text: 'By continuing, you agree to our\n ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  style: TextStyle(color: primaryColor),
                  children: [
                    TextSpan(
                        text: 'Terms and conditions ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Terms and conditions clicked");
                          }),
                    TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blueColor,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Privacy policy clicked");
                          })
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, AuthBloc authBloc) {
    return StreamBuilder(
        stream: authBloc.loadingStatusStream,
        initialData: false,
        builder: (context, AsyncSnapshot<bool> loadingSnapshot) {
          return StreamBuilder(
              stream: authBloc.buttonStreamForLogin,
              builder: (context, snapshot) {
                return Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide.none),
                        padding: EdgeInsets.all(18.0),
                        primary: primaryColor,
                      ),
                      onPressed: snapshot.hasData && (!loadingSnapshot.data!)
                          ? () {
                              _onSubmit(authBloc, context);
                            }
                          : null,
                      child: loadingSnapshot.data!
                          ? CircularProgressIndicator()
                          : Text("Submit"),
                    ),
                  ),
                );
              });
        });
  }

  Future _onSubmit(AuthBloc authBloc, BuildContext context) async {
    authBloc.changeLoadingStatus(true);
    try {
      final response = await authBloc.register();
      authBloc.changeLoadingStatus(false);
      if (response == null) {
        showSnackBar(context, "Signup failed, please try again");
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return TodoScreen();
        }));
      }
    } catch (e) {
      authBloc.changeLoadingStatus(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e")),
      );
    }
  }

  Widget _buildSignInSection(BuildContext context) {
    return Column(
      children: [
        Divider(),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Alreay have an account?"),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Login"),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: primaryColor)),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
