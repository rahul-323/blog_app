abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker{

  final InternetConnection internetConnection;
  @override

  Future<bool> get isConnected ()async{

  }

}
