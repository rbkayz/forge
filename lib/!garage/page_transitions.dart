// return PageRouteBuilder(
// pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
// transitionsBuilder: (context, animation, secondaryAnimation, child) {
// const begin = Offset(0.5, 0.5);
// const end = Offset (0.4,0.4);
// var curve = Curves.ease;
// final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
// final offsetAnimation = animation.drive(tween);
// return SlideTransition(position: offsetAnimation, child: child);
// },
// );