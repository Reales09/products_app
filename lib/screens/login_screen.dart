import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 230,
            ),
            CardContainer(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Login',
                      style: Theme.of(context).textTheme.headlineMedium),
                  SizedBox(height: 10),
                  // Text('Formulario'),

                  ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(), child: _LoginForm()),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Text(
              'AZ Smart Technology - Copyright © 2022, Todos los derechos reservados. All rights reserved. Design and powered by AZ Smart.',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'register'),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(StadiumBorder()),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(
                'Crear una nueva cuenta',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            SizedBox(height: 50),
          ]),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
        child: Form(
      //TODO: Manter la referencia al KEY
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Ingresa usuario',
              labelText: 'Usuario',
              prefixIcon: Icons.person_outline,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no es un correo valido';
            },
          ),
          SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'Ingresa contraseña',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              if (value != null && value.length >= 6) {
                return null;
              } else {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
            },
          ),
          SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Container(
                  child: Text(loginForm.isloading ? 'Espere...' : 'Ingresar',
                      style: TextStyle(color: Colors.white))),
              onPressed: loginForm.isloading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService =
                          Provider.of<AuthService>(context, listen: false);
                      if (!loginForm.isValidForm()) return;
                      loginForm.isloading = true;

                      //TODO: validar si el login es correcto

                      final String? errorMessage = await authService.login(
                          loginForm.email, loginForm.password);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        // TODO: Mostrar error en pantalla
                        NotificacionService.showSnackbar(errorMessage);
                        loginForm.isloading = false;
                      }
                    })
        ],
      ),
    ));
  }
}
