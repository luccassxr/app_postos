import 'package:app_postos/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('exibe a tela de acesso do WK Cliente', (tester) async {
    await tester.pumpWidget(const WKClienteApp());

    expect(find.text('WK Cliente'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Criar cadastro'), findsOneWidget);
  });
}
