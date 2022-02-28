import 'package:clean_architecture/app/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: MultiProvider(
            providers: [
              Provider<AuthDatasourceContract>(create: (_) => AuthDatasourceImpl()),
              Provider<AuthRepositoryContract>(create: (context) => AuthRespositoryImpl(context.read<AuthDatasourceContract>())),
              Provider<LoginUseCaseContract>(create: (context) => LoginUseCase(context.read<AuthRepositoryContract>())),
              BlocProvider<AuthBloc>(create: (context) => AuthBloc(context.read<LoginUseCaseContract>())),
            ],
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({ Key? key }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(flex: 1),
        Icon(Icons.account_circle, size: MediaQuery.of(context).size.width / 3),
        const Spacer(flex: 1),

        BlocConsumer<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            if (state is AuthSuccessState) {
              // Redireciona o usuário
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                content: Text('Usuário logado'),
              ));
            }
          },
          builder: (BuildContext context, AuthState state) {
            if (state is AuthErrorState) {
              return Text(
                state.message,
                style: TextStyle(color: Colors.red[500]),
              );
            }

            if (state is AuthLoadingState) {
              return const CircularProgressIndicator();
            }

            return Container();
          },
        ),
        const SizedBox(height: 16),

        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('Email'),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('Senha'),
          ),
        ),
        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: () => context.read<AuthBloc>().add(AuthLoginEvent(
            email: emailController.text,
            password: passwordController.text,
          )),
          child: const Text('Entrar'),
        ),

        const Spacer(flex: 2),
      ],
    );
  }
}
