class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserManagementHeader(),
      drawer: const AppDrawer(),
      body: const HomeScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<AuthProvider>(context, listen: false).logout();
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}