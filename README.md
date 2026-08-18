# WK Cliente

MVP Flutter/Android do programa de fidelidade da rede de postos WK.

## Funcionalidades

- cadastro com validação, senha armazenada como hash e prevenção de CPF/e-mail duplicados;
- login por e-mail ou CPF, sessão persistente e logout;
- QR de identificação contendo apenas `WKCLIENT:<customerId>`;
- pontos calculados por service (`R$ 1,00 = 1 ponto`, descartando centavos);
- extrato persistente de abastecimentos e resgates;
- cupons com validade, custo, saldo e proteção contra resgate duplicado;
- busca nas seis unidades iniciais;
- simulador de abastecimento visível somente em builds debug.

A persistência atual usa `SharedPreferences` e é explicitamente destinada ao MVP local. O contrato `CustomerRepository` permite trocar a implementação por Firebase. Créditos de pontos deverão ser gravados somente por backend confiável no ambiente de produção.

## Executar

```bash
flutter create . --platforms=android --org com.grupowk --project-name app_postos
flutter pub get
flutter analyze
flutter test
flutter run
```

Não há logos ou imagens externas. `BrandLogo` usa temporariamente um ícone do Flutter.
