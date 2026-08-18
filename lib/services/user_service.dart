import '../models/user_model.dart';
import '../repositories/customer_repository.dart';

class UserService {
  const UserService(this.repository);
  final CustomerRepository repository;
  UserModel? findById(String id) {
    for (final user in repository.users) { if (user.id == id) return user; }
    return null;
  }
}
