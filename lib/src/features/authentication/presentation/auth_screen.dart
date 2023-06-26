
// class AuthScreen extends ConsumerWidget {
//   const AuthScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authStateChangesProvider);
//     return authState.maybeWhen(
//       data: (user) => user != null ? const ChangeRoleScreen() : const LoginScreen(),
//       // TODO: Should also handle errors
//       orElse: () => Scaffold(
//         appBar: AppBar(),
//         body: const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }
