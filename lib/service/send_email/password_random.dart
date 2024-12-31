import 'dart:math';

class PasswordService {

  String generateRandomPin(){
    const lengthPassword = 6;
    const characters = '0123456789';
    StringBuffer password = StringBuffer();
    Random random = Random();
    for(int i = 0; i < lengthPassword; i++) {
      int randomIndex = random.nextInt(characters.length);
      password.write(characters[randomIndex]);
    }
    print(password.toString());
    return password.toString();
  }


}